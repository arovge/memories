import UIKit
import PhotosUI

enum MediaType {
    case image
    case video
}

struct MediaWrapper: Hashable {
    let uiImage: UIImage
    let asset: PHAsset
    let type: MediaType
    
    init(_ uiImage: UIImage, _ asset: PHAsset) {
        self.uiImage = uiImage
        self.asset = asset
        self.type = .image
    }
    
    // TODO: Change this initializer to support videos
//    init(_ uiImage: UIImage, _ asset: PHAsset) {
//        self.uiImage = uiImage
//        self.asset = asset
//        self.type = .video
//    }
    
    var isMemory: Bool {
        if let creationDate = asset.creationDate {
            let todayDate = Date()
            let today = Calendar.current.dateComponents([.month, .day], from: todayDate)
            let createdWhen = Calendar.current.dateComponents([.month, .day], from: creationDate)
            return today.month == createdWhen.month && today.month == createdWhen.month
        }
        return false
    }
    
    var formattedCreatedWhen: String? {
        asset.creationDate?.toString(format: "MMMM d, yyyy")
    }
}
