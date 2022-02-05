import SwiftUI

struct MediaView: View {
    let media: MediaWrapper
    
    init(for media: MediaWrapper) {
        self.media = media
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image(uiImage: media.uiImage)
                .resizable()
                .scaledToFit()
            if let date = date {
                Text(date)
                    .foregroundColor(.secondaryLabel)
                    .font(.callout)
            }
            Spacer()
        }
    }
    
    var date: String? {
        if let formattedDate = media.formattedCreatedWhen {
            return "Taken on \(formattedDate)"
        }
        return nil
    }
}
