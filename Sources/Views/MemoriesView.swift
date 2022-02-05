import SwiftUI

struct MemoriesView: View {
    @Binding var media: [MediaWrapper]
    
    let gridItemLayout: [GridItem] = [
        .init(.fixed(100)),
        .init(.fixed(100)),
        .init(.fixed(100))
    ]
    
    init(_ media: Binding<[MediaWrapper]>) {
        self._media = media
    }
    
    var body: some View {
        VStack {
            Spacer()
            if media.isEmpty {
                Text("No memories today")
                    .foregroundColor(.secondaryLabel)
                    .font(.callout)
                    .padding(.bottom)
                Text("Take some more pictures for next year!")
                    .foregroundColor(.secondaryLabel)
                    .font(.callout)
            } else {
                LazyVGrid(columns: gridItemLayout, spacing: 5) {
                    ForEach(media, id: \.self) { mediaItem in
                        NavigationLink(destination: MediaView(for: mediaItem)) {
                            Image(uiImage: mediaItem.uiImage)
                                .renderingMode(.original)
                                .resizable()
                                .frame(maxWidth: 100, maxHeight: 100)
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(5)
                        }
                    }
                 }
            }
            Spacer()
        }
    }
}

struct MemoriesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MemoriesView(.constant([]))
        }
    }
}
