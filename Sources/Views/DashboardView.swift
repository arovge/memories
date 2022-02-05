import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView()
                    .foregroundColor(.secondaryLabel)
            } else {
                HStack {
                    Text(today)
                        .foregroundColor(.secondaryLabel)
                        .font(.headline)
                    Spacer()
                }
                
                MemoriesView($viewModel.media)
            }
        }
        .navigationBarTitle("Your memories")
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
