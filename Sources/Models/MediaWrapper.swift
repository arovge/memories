import UIKit
import PhotosUI

// TODO: Support video
enum MediaWrapper: Hashable {
    case image(UIImage, PHAsset)
    case video(UIImage, PHAsset)
    
    var uuid: UUID { UUID() }
    
    var isMemory: Bool {
//        guard let createdWhen = createdWhen else { return false }
//        let today = Calendar.current.dateComponents([.month, .day], from: Date())
//        let createdDate = Calendar.current.dateComponents([.month, .day], from: createdWhen)
//        return today.month == createdDate.month && today.month == createdDate.month
        true
    }
    
    var createdWhen: Date? {
        switch self {
        case .image(_, let asset):
            return asset.creationDate
        case .video(_, let asset):
            return asset.creationDate
        }
    }
    
    var formattedCreatedWhen: String? {
        createdWhen?.toString(format: "MMMM d, yyyy")
    }
    
    var placeholderImage: UIImage {
        switch self {
        case .image(let image, _):
            return image
        case .video(let image, _):
            return image
        }
    }
}
