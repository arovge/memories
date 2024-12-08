import PhotosUI
import MemoriesModels
import MemoriesUtility

public class PhotosService {
    private let logger = Logger()
    private let imageRequestOptions = PHImageRequestOptions()
    private let imageCachingManager = PHCachingImageManager()
    
    public init() {
        imageCachingManager.allowsCachingHighQualityImages = true
        
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.isSynchronous = true
        imageRequestOptions.deliveryMode = .opportunistic
        imageRequestOptions.resizeMode = .fast
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
        id: String,
        targetSize: CGSize = PHImageManagerMaximumSize,
        contentMode: PHImageContentMode = .default
    ) async throws -> UIImage? {
        let results = PHAsset.fetchAssets(
            withLocalIdentifiers: [id],
            options: nil
        )
        guard let asset = results.firstObject else {
            throw PhotosError.assetNotFound
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            imageCachingManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: contentMode,
                options: imageRequestOptions,
                resultHandler: { image, info in
                    if let error = info?[PHImageErrorKey] as? Error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume(returning: image)
                }
            )
        }
    }
    
//    public func requestImage(for asset: PHAsset) async throws -> MediaWrapper? {
//        try await withCheckedThrowingContinuation { continuation in
//            PHCachingImageManager().requestImage(
//                for: asset,
//                targetSize: .init(width: 1000, height: 1000),
//                contentMode: .aspectFill,
//                options: imageRequestOptions,
//                resultHandler: { image, options in
//                    if let image {
//                        continuation.resume(
//                            returning: MediaWrapper(media: .image(image), asset: asset)
//                        )
//                    }
//                    continuation.resume(throwing: PhotosError.unknown)
//                }
//            )
//        }
//    }
    
//    public func requestVideo(for asset: PHAsset) async throws -> MediaWrapper? {
//        try await withCheckedThrowingContinuation { continuation in
//            PHCachingImageManager.default().requestPlayerItem(
//                forVideo: asset,
//                options: nil,
//                resultHandler: { video, options in
//                    if let video {
//                        continuation.resume(
//                            returning: MediaWrapper(media: .video(video), asset: asset)
//                        )
//                    }
//                    continuation.resume(throwing: PhotosError.unknown)
//                })
//        }
//    }
    
    enum PhotosError: Error {
        case assetNotFound
    }
}
