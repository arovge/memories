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
        .toolbarBackgroundVisibility(showToolbar ? .visible : .hidden, for: .navigationBar)
        .toolbarVisibility(showToolbar ? .visible : .hidden, for: .navigationBar)
        .toolbarBackground(.black, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemSymbol: .chevronLeft)
                        .fontWeight(.semibold)
                }
            }
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(media.createdWhenDate)
                        .font(.subheadline.weight(.semibold))
                    Text(media.createdWhenTime)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            ToolbarItemGroup {
                if let fullImage {
                    let photo = Image(uiImage: fullImage)
                    ShareLink(item: photo, preview: SharePreview(media.createdWhen, image: photo))
                        .fontWeight(.semibold)
                }
            }
        }
    }
    
    var image: UIImage {
        fullImage ?? preview
    }
}
