import SwiftUI

struct MemoriesView: View {
    @Environment(DashboardViewModel.self) var viewModel
    
    var body: some View {
        VStack {
            if viewModel.memorySections.isEmpty {
                ContentUnavailableView(
                    "No memories today",
                    systemSymbol: .photoOnRectangleAngled,
                    description: Text("Take some more pictures for next year!")
                )
            } else {
                MediaGridView()
                    .environment(viewModel)
            }
        }
    }
}

#Preview {
    NavigationView {
        MemoriesView()
            .environment(DashboardViewModel())
    }
}
