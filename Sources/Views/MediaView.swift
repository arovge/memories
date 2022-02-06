import SwiftUI

struct MediaView: View {
    let media: MediaWrapper
    let share: () -> Void
    
    init(for media: MediaWrapper, share: @escaping () -> Void) {
        self.media = media
        self.share = share
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image(uiImage: media.placeholderImage)
                .resizable()
                .scaledToFit()
            Text(description)
                .foregroundColor(.secondaryLabel)
                .font(.callout)
            Spacer()
        }
        .contextMenu {
            Button("Share", action: share)
        }
    }
    
    var description: String {
        "Taken on \(media.createdWhen)"
    }
}
