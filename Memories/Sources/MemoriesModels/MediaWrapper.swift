import UIKit
import PhotosUI
import MemoriesUtility

public enum Media: Hashable {
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
public struct MediaWrapper: Hashable {
    public let media: Media
    let asset: PHAsset
    public let createdDate: Date
    
    public init?(media: Media, asset: PHAsset) {
        guard let creationDate = asset.creationDate else { return nil }
        self.media = media
        self.asset = asset
        self.createdDate = creationDate
    }
        
    public var isMemory: Bool {
        let today = Calendar.current.dateComponents([.month, .day], from: Date())
        let createdDate = Calendar.current.dateComponents([.month, .day], from: createdDate)
        return today.month == createdDate.month && today.month == createdDate.month
    }
    
    public var createdWhen: String {
        // TODO: Use new formatted API
        createdDate.formatted("MMMM d, yyyy h:mm a")
    }
    
    public var placeholderImage: UIImage {
        switch media {
        case .image(let image):
            return image
        case .video(let playerItem):
            return UIImage(systemSymbol: .playFill) ?? UIImage()
        }
    }
}
