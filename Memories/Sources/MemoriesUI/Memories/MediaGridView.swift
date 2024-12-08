import SwiftUI
import MemoriesModels

struct MediaGridView: View {
    @Environment(DashboardViewModel.self) var viewModel
    
    var gridLayout: [GridItem] {
        Array(repeating: .init(.flexible()), count: viewModel.layout.rawValue)
    }
    
    var body: some View {
        ForEach(viewModel.memorySections) { section in
            renderSection(section)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .animation(.interactiveSpring(), value: gridLayout.count)
    }
    
    @ViewBuilder
    func renderSection(_ section: MemorySection) -> some View {
        Text(String(section.year))
            .foregroundColor(.secondary)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        LazyVGrid(columns: gridLayout, spacing: 10) {
            ForEach(section.media) { memory in
                ImagePreview(for: memory, gridLayout: gridLayout)
            }
        }
        .padding(.bottom)
    }
}
