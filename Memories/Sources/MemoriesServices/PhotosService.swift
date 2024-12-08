import PhotosUI
import MemoriesModels
import MemoriesUtility

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
    
    public func fetchMedia() async throws -> [MediaWrapper] {
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
        
        return try await withCheckedThrowingContinuation { continutation in
            var media = [MediaWrapper]()
            assets.enumerateObjects { asset, _, _ in
                switch asset.mediaType {
                case .image:
                    break
    //                self.requestImage(for: asset, callback: addMedia)
                case .video:
                    break
    //                self.requestVideo(for: asset, callback: addMedia)
                default:
                    self.logger.info("Unknown media type: \(asset.mediaType)")
                }
            }
            continutation.resume(returning: media)
        }
    }
    
    public func requestImage(for asset: PHAsset) async throws -> MediaWrapper? {
        try await withCheckedThrowingContinuation { continuation in
            PHCachingImageManager().requestImage(
                for: asset,
                targetSize: .init(width: 1000, height: 1000),
                contentMode: .aspectFill,
                options: imageRequestOptions,
                resultHandler: { image, options in
                    if let image {
                        continuation.resume(
                            returning: MediaWrapper(media: .image(image), asset: asset)
                        )
                    }
                    continuation.resume(throwing: PhotosError.unknown)
                }
            )
        }
    }
    
    public func requestVideo(for asset: PHAsset) async throws -> MediaWrapper? {
        try await withCheckedThrowingContinuation { continuation in
            PHCachingImageManager.default().requestPlayerItem(
                forVideo: asset,
                options: nil,
                resultHandler: { video, options in
                    if let video {
                        continuation.resume(
                            returning: MediaWrapper(media: .video(video), asset: asset)
                        )
                    }
                    continuation.resume(throwing: PhotosError.unknown)
                })
        }
    }
    
    enum PhotosError: Error {
        case unknown
    }
}
