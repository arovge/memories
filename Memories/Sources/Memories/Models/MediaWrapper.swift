import UIKit
import PhotosUI

enum Media: Hashable {
    case image(UIImage)
    case video(AVPlayerItem)
    
    func get() -> Any {
        switch self {
        case .image(let image):
            return image
        case .video(let playerItem):
            return playerItem
        }
    }
}

// TODO: Support video
struct MediaWrapper: Hashable {
    let media: Media
    let asset: PHAsset
    let createdDate: Date
    
    init?(media: Media, asset: PHAsset) {
        guard let creationDate = asset.creationDate else { return nil }
        self.media = media
        self.asset = asset
        self.createdDate = creationDate
    }
        
    var isMemory: Bool {
        let today = Calendar.current.dateComponents([.month, .day], from: Date())
        let createdDate = Calendar.current.dateComponents([.month, .day], from: createdDate)
        return today.month == createdDate.month && today.month == createdDate.month
    }
    
    var createdWhen: String {
        createdDate.toString(format: "MMMM d, yyyy h:mm a")
    }
    
    var placeholderImage: UIImage {
        switch media {
        case .image(let image):
            return image
        case .video(let playerItem):
            return UIImage(systemSymbol: .playFill) ?? UIImage()
        }
    }
}
