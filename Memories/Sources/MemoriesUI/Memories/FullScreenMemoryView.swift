import SwiftUI
import MemoriesModels

struct FullScreenMemoryView: View {
    @State var loading = true
    @State var image: UIImage
    let media: MediaWrapper
    let share: () -> Void
    
    init(for media: MediaWrapper, preview: UIImage, share: @escaping () -> Void) {
        self.media = media
        self._image = State(initialValue: preview)
        self.share = share
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
            if let createdWhen = media.createdWhen {
                ToolbarItem(placement: .principal) {
                    Text(createdWhen)
                        .font(.subheadline)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                shareButton
            }
        }
    }
    
    var shareButton: some View {
        Button {
            share()
        } label: {
            Label("Share", systemSymbol: .squareAndArrowUp)
        }
    }
}
