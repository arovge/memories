import PhotosUI
import MemoriesModels

public class PhotosService {
    private let logger = Logger()
    private let imageRequestOptions: PHImageRequestOptions = PHImageRequestOptions()
    
    public init() {
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.isSynchronous = true
    }
    
    public func requestAccess() async -> PHAuthorizationStatus {
        // TOOD: Should this be read not readWrite?
        await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    }
    
    public func fetchMedia(addMedia: @escaping (_ wrapper: MediaWrapper) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            .init(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = .init(
            format: "mediaType == %d || mediaType == %d",
            PHAssetMediaType.image.rawValue,
            PHAssetMediaType.video.rawValue
        )
        
        let assets = PHAsset.fetchAssets(with: fetchOptions)
        
        assets.enumerateObjects { asset, _, _ in
            switch asset.mediaType {
            case .image:
                self.requestImage(for: asset, callback: addMedia)
            case .video:
                self.requestVideo(for: asset, callback: addMedia)
            default:
                self.logger.info("Unknown media type: \(asset.mediaType)")
            }
        }
    }
    
    public func requestImage(for asset: PHAsset, callback: @escaping (_ wrapper: MediaWrapper) -> Void) {
        PHCachingImageManager.default().requestImage(
            for: asset,
            targetSize: .init(width: 1000, height: 1000),
            contentMode: .aspectFill,
            options: self.imageRequestOptions,
            resultHandler: { image, info in
                guard let image = image else { return }
                guard let wrapper = MediaWrapper(media: .image(image), asset: asset), wrapper.isMemory else { return }
                callback(wrapper)
            })
    }
    
    public func requestVideo(for asset: PHAsset, callback: @escaping (_ wrapper: MediaWrapper) -> Void) {
        PHCachingImageManager.default().requestPlayerItem(
            forVideo: asset,
            options: nil,
            resultHandler: { item, options in
                guard let item = item else { return }
                guard let wrapper = MediaWrapper(media: .video(item), asset: asset), wrapper.isMemory else { return }
                callback(wrapper)
            })
    }
}
