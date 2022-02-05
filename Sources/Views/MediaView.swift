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
            if let date = date {
                Text(date)
                    .foregroundColor(.secondaryLabel)
                    .font(.callout)
            }
            Spacer()
        }
        .contextMenu {
            Button("Share", action: share)
        }
    }
    
    var date: String? {
        if let formattedDate = media.formattedCreatedWhen {
            return "Taken on \(formattedDate)"
        }
        return nil
    }
}
