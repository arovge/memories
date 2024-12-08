import UIKit
import PhotosUI

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
//    public let media: Media
    public let asset: PHAsset
    public let createdDate: Date
    
    public init?(asset: PHAsset) {
        guard let createdDate = asset.creationDate else { return nil }
        self.createdDate = createdDate
//        self.media = media
        self.asset = asset
    }
        
    public var isMemory: Bool {
        let today = Calendar.current.dateComponents([.month, .day], from: Date())
        let createdDateMonthDay = Calendar.current.dateComponents([.month, .day], from: createdDate)
        return today.month == createdDateMonthDay.month
            && today.day == createdDateMonthDay.day
    }
    
    public var createdWhen: String {
        createdDate.formatted(
            .dateTime
            .year(.defaultDigits)
            .month(.abbreviated)
            .day(.defaultDigits)
            .hour()
            .minute()
        )
    }
    
//    public var placeholderImage: UIImage {
//        switch media {
//        case .image(let image):
//            return image
//        case .video(let playerItem):
//            return UIImage()//UIImage(systemSymbol: .playFill) ?? UIImage()
//        }
//    }
}

extension MediaWrapper: Identifiable {
    public var id: String { asset.localIdentifier }
}
