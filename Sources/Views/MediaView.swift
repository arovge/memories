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
                .contextMenu {
                    Button(action: share) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            Text(description)
                .foregroundColor(.secondaryLabel)
                .font(.callout)
            Text(media.createdDate.toString(format: "y, MMM d, HH:mm:ss"))
                .foregroundColor(.secondaryLabel)
                .font(.callout)
            Spacer()
        }
    }
    
    var description: String {
        "Taken on \(media.createdWhen)"
    }
}
