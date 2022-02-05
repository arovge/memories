import PhotosUI

class PhotosService {
    func requestAccess(_ callback: @escaping (_ status: PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: callback)
    }
    
    func loadPhotos() -> [UIImage] {
        // TODO: Implement
        return []
    }
}
