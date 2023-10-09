public struct MemorySection {
    public let year: Int
    public let memories: [MediaWrapper]
    
    public init(year: Int, memories: [MediaWrapper]) {
        self.year = year
        self.memories = memories
    }
}

extension MemorySection: Identifiable {
    public var id: Int { year }
}
