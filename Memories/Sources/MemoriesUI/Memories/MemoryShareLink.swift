import SwiftUI
import MemoriesModels

struct MemoryShareLink: View {
    let media: MediaWrapper
    let image: UIImage
    
    init(_ media: MediaWrapper, _ image: UIImage) {
        self.media = media
        self.image = image
    }
    
    var body: some View {
        let photo = Image(uiImage: image)
        ShareLink(item: photo, preview: SharePreview(media.createdWhen, image: photo))
    }
}
