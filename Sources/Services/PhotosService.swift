import PhotosUI

class PhotosService {
    private let logService: LogService = LogService()
    private let imageRequestOptions: PHImageRequestOptions = PHImageRequestOptions()
    
    init() {
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.isSynchronous = true
    }
    
    func requestAccess(_ callback: @escaping (_ status: PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: callback)
    }
    
    func fetchMedia(addMedia: @escaping (_ wrapper: MediaWrapper) -> Void) {
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
                self.logService.log(info: "Unknown media type: \(asset.mediaType)")
            }
        }
    }
    
    func requestImage(for asset: PHAsset, callback: @escaping (_ wrapper: MediaWrapper) -> Void) {
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
    
    func requestVideo(for asset: PHAsset, callback: @escaping (_ wrapper: MediaWrapper) -> Void) {
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
