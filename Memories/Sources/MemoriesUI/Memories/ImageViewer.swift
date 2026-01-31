import SwiftUI
import MemoriesModels

struct ImageViewer: View {
    @Environment(DashboardViewModel.self) var viewModel
    @Environment(\.dismiss) var dismiss
    @Binding var image: UIImage?
    @State var showToolbar = true
    let media: MediaItem
    
    init(for media: MediaItem, preview: Binding<UIImage?>) {
        self.media = media
        self._image = preview
    }
    
    var body: some View {
        VStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            withAnimation(.interactiveSpring) {
                showToolbar.toggle()
            }
        }
        .ignoresSafeArea()
        .task {
//            guard image == nil else { return }
            // Load higher quality image to use instead of lower quality preview
            if let fullImage = await viewModel.getImage(media.asset, targetSize: nil) {
                image = fullImage
            }
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
                if let image {
                    let photo = Image(uiImage: image)
                    ShareLink(item: photo, preview: SharePreview(media.createdWhen, image: photo))
                        .fontWeight(.semibold)
                }
            }
        }
    }
    
//    var image: UIImage {
//        fullImage ?? preview
//    }
}
