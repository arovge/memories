import SwiftUI
import PhotosUI

class DashboardViewModel: ObservableObject {
    @Published var media: [Int: [MediaWrapper]] = [:]
    @Published var requestedMedia: [MediaWrapper] = []
    @Published var loading: Bool = true
    @Published var layout: ColumnLayout = .single
    @Published var error: Bool = false
    @Published var hasPhotosAccess: Bool = false
    private let photosService: PhotosService = PhotosService()
    private var started: Bool = false
    private let requestOptions: PHImageRequestOptions = PHImageRequestOptions()
    
    init() {
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = true
    }
    
    var years: [Int] {
        media.keys.sorted(by: >)
    }
    
    func handleAppear() {
        // ensure that this is only done once
        guard !started else { return }
        started = true
        
        photosService.requestAccess { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async { self.hasPhotosAccess = true }
                self.fetchPhotos()
            default:
                self.hasPhotosAccess = false
            }
        }
    }
    
    func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            .init(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = .init(
            format: "mediaType == %d || mediaType == %d",
            PHAssetMediaType.image.rawValue,
            PHAssetMediaType.video.rawValue
        )
        
        let manager = PHImageManager.default()
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        
        fetchResult.enumerateObjects { asset, _, _ in
            switch asset.mediaType {
            case .image:
                self.requestImage(for: asset, with: manager)
            case .video:
                // TODO: Store video. Need to see how the views can render them
                print("video")
            default:
                print("unknown media type")
            }
        }
        
        DispatchQueue.main.async {
            self.media = self.requestedMedia.reduce(into: [:] as [Int: [MediaWrapper]]) { acc, media in
                let components = Calendar.current.dateComponents([.year], from: media.createdDate)
                guard let year = components.year else { return }
                let newValue = acc[year, default: []] + [media]
                acc[year] = newValue.sorted(by: { $0.createdWhen < $1.createdWhen })
            }
            self.loading = false
        }
    }
    
    func requestImage(for asset: PHAsset, with manager: PHImageManager) {
        manager.requestImage(
            for: asset,
            targetSize: .init(width: 100, height: 100),
            contentMode: .aspectFill,
            options: self.requestOptions,
            resultHandler: { image, info in
                if let image = image, let wrapper = MediaWrapper(image: image, asset: asset), wrapper.isMemory {
                    DispatchQueue.main.async { self.requestedMedia.append(wrapper) }
                }
            })
    }
    
    func toggleLayout() {
        layout = layout.next()
    }
    
    func share() {
        
    }
}
