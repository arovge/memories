import Photos

public struct MediaSection {
    public let year: Int
    public let media: [MediaItem]
    
    public init(year: Int, media: [MediaItem]) {
        self.year = year
        self.media = media
    }
}

extension MediaSection: Identifiable {
    public var id: Int { year }
}
