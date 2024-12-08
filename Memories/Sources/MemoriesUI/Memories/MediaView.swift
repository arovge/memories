import SwiftUI
import AVKit
import MemoriesModels

struct MediaView: View {
    let media: MediaWrapper
    let share: () -> Void
    
    init(for media: MediaWrapper, share: @escaping () -> Void) {
        self.media = media
        self.share = share
    }
    
    var body: some View {
        VStack {
            switch media.media {
            case .image(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .contextMenu {
                        shareButton
                    }
            case .video(let playerItem):
                MediaVideoView(playerItem: playerItem)
                    .contextMenu {
                        shareButton
                    }
            }
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
