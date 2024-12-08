import SwiftUI
import MemoriesModels

struct MediaGridView: View {
    @Environment(DashboardViewModel.self) var viewModel
    
    var gridLayout: [GridItem] {
        Array(repeating: .init(.flexible()), count: viewModel.layout.rawValue)
    }
    
    var body: some View {
        ForEach(viewModel.memorySections) { section in
            renderYear(section)
        }
        .padding(10)
        .animation(.interactiveSpring(), value: gridLayout.count)
    }
    
    @ViewBuilder
    func renderYear(_ section: MemorySection) -> some View {
        HStack {
            Text(String(section.year))
                .foregroundColor(.secondary)
                .font(.headline)
            Spacer()
        }
            
        LazyVGrid(columns: gridLayout, spacing: 10) {
            ForEach(section.media, id: \.self) { memory in
                NavigationLink(
                    destination: MediaView(
                        for: memory,
                        share: {
                            viewModel.share(year: section.year, media: memory)
                        }
                    )
                ) {
                    ProgressView()
//                        Image(uiImage: memory.placeholderImage)
//                            .resizable()
//                            .scaledToFill()
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .frame(height: gridLayout.count == 1 ? 200 : 100)
//                            .cornerRadius(5)
                }
                .contextMenu {
                    Button {
                        viewModel.share(year: section.year, media: memory)
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}
