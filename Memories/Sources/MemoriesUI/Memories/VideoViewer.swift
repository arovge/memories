import SwiftUI
import AVKit
import MemoriesModels

struct VideoViewer: View {
    @Environment(DashboardViewModel.self) var viewModel
    let media: MediaItem
    let preview: UIImage
    @State var loading = true
    @State var player: AVPlayer?
    
    init(for media: MediaItem, preview: UIImage) {
        self.media = media
        self.preview = preview
    }
    
    var body: some View {
        VStack {
            if let player {
                VideoPlayer(player: player)
                    .onDisappear {
                        self.player?.replaceCurrentItem(with: nil)
                    }
            } else {
                Image(uiImage: preview)
                    .resizable()
                    .scaledToFit()
            }
        }
        .task {
            if let item = await viewModel.getVideo(asset: media.asset) {
                player = AVPlayer(playerItem: item)
            }
            loading = false
        }
    }
}
