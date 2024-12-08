import SwiftUI
import AVKit
import MemoriesModels

struct ImagePreview: View {
    @Namespace var animation
    @Environment(DashboardViewModel.self) var viewModel
    @State var loading = true
    @State var preview = UIImage?.none
    let media: MediaItem
    let gridLayout: [GridItem]
    
    init(for media: MediaItem, gridLayout: [GridItem]) {
        self.media = media
        self.gridLayout = gridLayout
    }
    
    var body: some View {
        NavigationLink {
            if let preview {
                ImageViewer(for: media, preview: preview)
                    .navigationTransition(.zoom(sourceID: "image", in: animation))
                    .environment(viewModel)
            }
        } label: {
            VStack {
                // TOOD: Handle error loading state
                if let preview {
                    Image(uiImage: preview)
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
                guard preview == nil else { return }
                preview = await viewModel.getImage(
                    media.asset,
                    targetSize: CGSize(width: 200, height: 200)
                )
                loading = false
            }
            .overlay {
                if media.asset.mediaType == .video {
                    Image(systemSymbol: .playFill)
                }
            }
        }
        .disabled(preview == nil)
    }
}
