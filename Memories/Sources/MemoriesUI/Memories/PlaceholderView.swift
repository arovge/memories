import SwiftUI
import AVKit
import MemoriesModels

struct PlaceholderView: View {
    @Environment(DashboardViewModel.self) var viewModel
    @State var loading = true
    @State var image = UIImage?.none
    let media: MediaWrapper
    let gridLayout: [GridItem]
    
    init(for media: MediaWrapper, gridLayout: [GridItem]) {
        self.media = media
        self.gridLayout = gridLayout
    }
    
    var body: some View {
        VStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: gridLayout.count == 1 ? 200 : 100)
                    .cornerRadius(5)
            } else {
                ProgressView()
            }
        }
        .task {
            image = await viewModel.getImage(media.asset)
            loading = false
        }
    }
}
