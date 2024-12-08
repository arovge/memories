import PhotosUI

public struct MediaWrapper: Hashable {
    public let asset: PHAsset
    public let createdDate: Date
    
    public init?(asset: PHAsset) {
        guard let createdDate = asset.creationDate else { return nil }
        self.createdDate = createdDate
        self.asset = asset
    }

    public var isMemory: Bool {
        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let createdDate = Calendar.current.dateComponents([.year, .month, .day], from: createdDate)
        return today.month == createdDate.month
            && today.day == createdDate.day
            && today.year != createdDate.year
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
}

extension MediaWrapper: Identifiable {
    public var id: String { asset.localIdentifier }
}
