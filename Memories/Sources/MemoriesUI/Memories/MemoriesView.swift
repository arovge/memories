import SwiftUI

struct MemoriesView: View {
    @Environment(DashboardViewModel.self) var viewModel
    
    var body: some View {
        VStack {
            if viewModel.memorySections.isEmpty {
                Text("No memories today")
                    .foregroundColor(.secondaryLabel)
                    .font(.headline)
                    .padding(.bottom)
                Text("Take some more pictures for next year!")
                    .foregroundColor(.secondaryLabel)
                    .font(.headline)
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
