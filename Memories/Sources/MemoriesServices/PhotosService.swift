import PhotosUI
import MemoriesModels

public class PhotosService {
    private let logger = Logger()
    private let imageRequestOptions = PHImageRequestOptions()
    private let videoRequestOptions = PHVideoRequestOptions()
    private let imageCachingManager = PHCachingImageManager()
    
    public init() {
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.isSynchronous = true
        imageRequestOptions.deliveryMode = .opportunistic
        imageRequestOptions.resizeMode = .fast
        
        videoRequestOptions.isNetworkAccessAllowed = true
        videoRequestOptions.deliveryMode = .fastFormat
        
        imageCachingManager.allowsCachingHighQualityImages = true
    }
    
    public func requestAccess() async -> PHAuthorizationStatus {
        // TOOD: Should this be read not readWrite?
        await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    }
    
    public func getAssets() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeHiddenAssets = false
        fetchOptions.sortDescriptors = [
            .init(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = .init(
            format: "mediaType == %d || mediaType == %d",
            PHAssetMediaType.image.rawValue,
            PHAssetMediaType.video.rawValue
        )
        
        return PHAsset.fetchAssets(with: fetchOptions)
    }
    
    public func getImage(
        asset: PHAsset,
        targetSize: CGSize,
        contentMode: PHImageContentMode
    ) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            imageCachingManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: contentMode,
                options: imageRequestOptions,
                resultHandler: { image, info in
                    if let image {
                        continuation.resume(returning: image)
                    }
                    let error = info?[PHImageErrorKey] as? Error
                    continuation.resume(throwing: PhotosError.loading(error))
                }
            )
        }
    }
    
    public func getVideo(asset: PHAsset) async throws -> AVPlayerItem {
        try await withCheckedThrowingContinuation { continuation in
            imageCachingManager.requestPlayerItem(
                forVideo: asset,
                options: videoRequestOptions,
                resultHandler: { playerItem, info in
                    if let playerItem {
                        continuation.resume(returning: playerItem)
                    }
                    let error = info?[PHImageErrorKey] as? Error
                    continuation.resume(throwing: PhotosError.loading(error))
                })
        }
    }
    
    public enum PhotosError: Error {
        case loading((any Error)?)
    }
}
