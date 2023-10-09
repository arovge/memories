import SwiftUI

struct MediaGridView: View {
    @Bindable var viewModel: DashboardViewModel
    
    var gridLayout: [GridItem] {
        Array(repeating: .init(.flexible()), count: viewModel.layout.rawValue)
    }
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.memorySections) { section in
                HStack {
                    Text(String(section.year))
                        .foregroundColor(.secondaryLabel)
                        .font(.headline)
                    Spacer()
                }
                    
                LazyVGrid(columns: gridLayout, spacing: 10) {
                    ForEach(section.memories, id: \.self) { memory in
                        NavigationLink(
                            destination: MediaView(
                                for: memory,
                                share: {
                                    viewModel.share(year: section.year, media: memory)
                                }
                            )
                        ) {
                            Image(uiImage: memory.placeholderImage)
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: gridLayout.count == 1 ? 200 : 100)
                                .cornerRadius(5)
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
            .padding(10)
            .animation(.interactiveSpring(), value: gridLayout.count)
        }
    }
}
