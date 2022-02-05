import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView()
                    .foregroundColor(.secondaryLabel)
            } else {
                MemoriesView(viewModel: viewModel)
            }
        }
        .navigationBarTitle("Your memories")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(today)
                    .foregroundColor(.secondaryLabel)
                    .font(.headline)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.toggleLayout()
                } label: {
                    Image(systemName: "square.grid.2x2")
                }
            }
        }
        .onAppear {
            viewModel.handleAppear()
        }
    }
    
    var today: String {
        let today = Date().toString(format: "MMMM d, yyyy")
        return "for \(today)"
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DashboardView(viewModel: .init())
        }
    }
}
