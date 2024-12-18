import SwiftUI
import AVKit
import MemoriesModels

struct PlaceholderView: View {
    @Namespace var animation
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
        NavigationLink {
            if let image {
                ImageViewer(for: media, preview: image)
                    .navigationTransition(.zoom(sourceID: "image", in: animation))
                    .environment(viewModel)
            }
        } label: {
            VStack {
                // TOOD: Handle error loading state
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: gridLayout.count == 1 ? 200 : 100)
                        .cornerRadius(5)
                        .matchedTransitionSource(id: "image", in: animation)
                } else {
                    ProgressView()
                }
            }
            .task {
                guard image == nil else { return }
                image = await viewModel.getImage(
                    media.asset,
                    targetSize: CGSize(width: 200, height: 200)
                )
                loading = false
            }
        }
        .disabled(image == nil)
    }
}
