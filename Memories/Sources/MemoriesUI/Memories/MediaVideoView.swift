import SwiftUI
import AVKit

struct MediaVideoView: View {
    @State var player: AVPlayer
    
    init(playerItem: AVPlayerItem) {
        // A copy is required as only one AVPlayerItem can be associated with an AVPlayer at a time
        // Even though the SwiftUI view is destroyed when leaving this screen, and onDisappear replaces the current item,
        // it still isn't enough for the item to become dissociated from the player
        let item = playerItem.copy() as! AVPlayerItem
        self.player = AVPlayer(playerItem: item)
    }
    
    var body: some View {
        VideoPlayer(player: player)
            .onDisappear {
                self.player.replaceCurrentItem(with: nil)
            }
    }
}
