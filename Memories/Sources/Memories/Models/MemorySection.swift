struct MemorySection {
    let year: Int
    let memories: [MediaWrapper]
}

extension MemorySection: Identifiable {
    var id: Int { year }
}
