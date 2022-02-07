import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel = DashboardViewModel()
    
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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(viewModel.currentMonthAndDay)
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
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DashboardView()
        }
    }
}
