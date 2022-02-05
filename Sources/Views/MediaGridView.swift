import SwiftUI

struct MediaGridView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var gridLayout: [GridItem] {
        Array(repeating: .init(.flexible()), count: viewModel.layout.columnCount)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout, spacing: 10) {
                ForEach(viewModel.media, id: \.self) { item in
                    NavigationLink(destination: MediaView(for: item, share: viewModel.share)) {
                        Image(uiImage: item.placeholderImage)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: gridLayout.count == 1 ? 200 : 100)
                            .cornerRadius(5)
                    }
                }
            }
            .padding(10)
            .animation(.interactiveSpring(), value: gridLayout.count)
        }
    }
}
