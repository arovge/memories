import PhotosUI

public struct MediaItem: Hashable {
    public let asset: PHAsset
    public let createdDate: Date
    
    public init?(from asset: PHAsset) {
        guard let createdDate = asset.creationDate else { return nil }
        self.createdDate = createdDate
        self.asset = asset
    }

    public var isMemory: Bool {
        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let createdDate = Calendar.current.dateComponents([.year, .month, .day], from: createdDate)
        return today.year != createdDate.year
            && today.month == createdDate.month
            && today.day == createdDate.day
    }
    
    public var createdWhen: String {
        "\(createdWhenDate) \(createdWhenTime)"
    }
    
    public var createdWhenDate: String {
        createdDate.formatted(
            .dateTime
            .year(.defaultDigits)
            .month(.wide)
            .day(.defaultDigits)
        )
    }
    
    public var createdWhenTime: String {
        createdDate.formatted(
            .dateTime
            .hour()
            .minute()
        )
    }
}

extension MediaItem: Identifiable {
    public var id: String { asset.localIdentifier }
}
