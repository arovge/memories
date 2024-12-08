import SwiftUI
import MemoriesModels

struct FullScreenMemoryView: View {
    @State var loading = true
    @State var image: UIImage
    let media: MediaWrapper
    
    init(for media: MediaWrapper, preview: UIImage) {
        self.media = media
        self._image = State(initialValue: preview)
    }
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
//            Image(systemSymbol: .photo)
//            switch media.asset {
//            case .image(let image):
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .contextMenu {
//                        shareButton
//                    }
//            case .video(let playerItem):
//                MediaVideoView(playerItem: playerItem)
//                    .contextMenu {
//                        shareButton
//                    }
//            }
        }
        .task {
            // TODO: Load higher quality version here
//            image = await viewModel.getImage(media.asset)
            loading = false
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(media.createdWhen)
                    .font(.subheadline)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                MemoryShareLink(media, image)
            }
        }
    }
}
