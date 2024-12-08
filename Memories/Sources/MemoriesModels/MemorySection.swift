import Photos

public struct MemorySection {
    public let year: Int
    public let media: [MediaWrapper]
    
    public init(year: Int, media: [MediaWrapper]) {
        self.year = year
        self.media = media
    }
}

extension MemorySection: Identifiable {
    public var id: Int { year }
}
