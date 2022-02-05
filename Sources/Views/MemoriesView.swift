import SwiftUI

struct MemoriesView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack {
            if viewModel.media.isEmpty {
                Text("No memories today")
                    .foregroundColor(.secondaryLabel)
                    .font(.callout)
                    .padding(.bottom)
                Text("Take some more pictures for next year!")
                    .foregroundColor(.secondaryLabel)
                    .font(.callout)
            } else {
                MediaGridView(viewModel: viewModel)
            }
        }
    }
}

struct MemoriesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MemoriesView(viewModel: .init())
        }
    }
}
