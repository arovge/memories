import SwiftUI

struct MediaGridView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var gridLayout: [GridItem] {
        Array(repeating: .init(.flexible()), count: viewModel.layout.columnCount)
    }
    
    var body: some View {
        ScrollView {
            ForEach(0 ..< viewModel.years.count) { index in
                HStack {
                    Text(String(viewModel.years[index]))
                        .foregroundColor(.secondaryLabel)
                        .font(.headline)
                    Spacer()
                }
                    
                LazyVGrid(columns: gridLayout, spacing: 10) {
                    ForEach(viewModel.media[viewModel.years[index]] ?? [], id: \.self) { item in
                        NavigationLink(destination: MediaView(for: item, share: viewModel.share)) {
                            Image(uiImage: item.placeholderImage)
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: gridLayout.count == 1 ? 200 : 100)
                                .cornerRadius(5)
                        }
                        .contextMenu {
                            Button(action: viewModel.share) {
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
