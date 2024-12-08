import SwiftUI
import MemoriesModels

struct ImageViewer: View {
    let image: UIImage
    let media: MediaWrapper
    
    init(for media: MediaWrapper, preview: UIImage) {
        self.media = media
        self.image = preview
    }
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        }
        .task {
            // TODO: Load higher quality version here
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(media.createdWhen)
                    .font(.subheadline)
            }
            ToolbarItem(placement: .topBarTrailing) {
                MemoryShareLink(media, image)
            }
        }
    }
}
