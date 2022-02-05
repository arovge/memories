import SwiftUI
import Photos
import PhotosUI

class DashboardViewModel: ObservableObject {
    @Published var media: [MediaWrapper] = []
    @Published var loading: Bool = true
    @Published var error: Bool = false
    private var started: Bool = false
    private let requestOptions: PHImageRequestOptions = PHImageRequestOptions()
    
    init() {
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = true
    }
    
    func handleAppear() {
        // ensure that this is only done once
        guard !started else { return }
        started = true
        
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
        
        loading = false
    }
    
    func requestImage(for asset: PHAsset, with manager: PHImageManager) {
        manager.requestImage(
            for: asset,
            targetSize: .init(width: 100, height: 100),
            contentMode: .aspectFill,
            options: self.requestOptions,
            resultHandler: { image, info in
                if let image = image {
                    let wrapper = MediaWrapper(image, asset)
                    if wrapper.isMemory {
                        self.media.append(wrapper)
                    }
                }
            })
    }
}
