import SwiftUI
import MemoriesModels

struct ImageViewer: View {
    @Environment(DashboardViewModel.self) var viewModel
    @Environment(\.dismiss) var dismiss
    @State var fullImage: UIImage?
    @State var showToolbar = true
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            withAnimation(.interactiveSpring) {
                showToolbar.toggle()
            }
        }
        .ignoresSafeArea()
        .task {
            guard fullImage == nil else { return }
            // Load higher quality image to use instead of lower quality preview
            fullImage = await viewModel.getImage(media.asset, targetSize: nil)
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .statusBarHidden(!showToolbar)
        .toolbarVisibility(showToolbar ? .visible : .hidden, for: .navigationBar)
        .toolbarBackground(.black, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemSymbol: .chevronLeft)
                }
            }
            ToolbarItem(placement: .principal) {
                Text(media.createdWhen)
                    .font(.subheadline)
            }
            ToolbarItemGroup {
                if let fullImage {
                    let photo = Image(uiImage: fullImage)
                    ShareLink(item: photo, preview: SharePreview(media.createdWhen, image: photo))
                }
            }
        }
    }
    
    var image: UIImage {
        fullImage ?? preview
    }
}
