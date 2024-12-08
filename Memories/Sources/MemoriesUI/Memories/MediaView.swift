import SwiftUI
import AVKit
import MemoriesModels

struct MediaView: View {
    @Environment(DashboardViewModel.self) var viewModel
    @State var loading = true
    @State var image = UIImage?.none
    let media: MediaWrapper
    let share: () -> Void
    
    init(for media: MediaWrapper, share: @escaping () -> Void) {
        self.media = media
        self.share = share
    }
    
    var body: some View {
        VStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
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
            print("started")
            image = await viewModel.getImage(media.asset)
            loading = false
            print("finished....")
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
        Button(action: share) {
            Label("Share", systemSymbol: .squareAndArrowUp)
        }
    }
}
