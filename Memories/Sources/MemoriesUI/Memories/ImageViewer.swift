import SwiftUI
import MemoriesModels

struct ImageViewer: View {
    @Environment(DashboardViewModel.self) var viewModel
    @Environment(\.dismiss) var dismiss
    @State var fullImage: UIImage?
    let media: MediaItem
    let preview: UIImage
    
    init(for media: MediaItem, preview: UIImage) {
        self.media = media
        self.preview = preview
    }
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        }
        .task {
            guard fullImage == nil else { return }
            // Load higher quality image to use instead of lower quality preview
            fullImage = await viewModel.getImage(media.asset, targetSize: nil)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(media.createdWhen)
                    .font(.subheadline)
            }
            ToolbarItemGroup {
                if let fullImage {
                    let photo = Image(uiImage: fullImage)
                    ShareLink(item: photo, preview: SharePreview(media.createdWhen, image: photo))
                }
                Button {
                    dismiss()
                } label: {
                    Image(systemSymbol: .xmark)
                }
            }
        }
    }
    
    var image: UIImage {
        fullImage ?? preview
    }
}
