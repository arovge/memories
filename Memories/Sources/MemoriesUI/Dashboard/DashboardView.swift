import SwiftUI

public struct DashboardView: View {
    @State var viewModel = DashboardViewModel()
    @EnvironmentObject var navigator: Navigator
    
    public init() {}
    
    public var body: some View {
        VStack {
            if !viewModel.hasPhotosAccess {
                Text("You don't have photo access. Please allow")
            } else if viewModel.loading {
                ProgressView()
            } else {
                MemoriesView(viewModel: viewModel)
            }
        }
        .navigationBarTitle("Your memories")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(viewModel.currentMonthAndDay)
                    .foregroundColor(.secondaryLabel)
                    .font(.headline)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                menu
            }
        }
        .task {
            await viewModel.handleAppear()
        }
    }
    
    @ViewBuilder
    var menu: some View {
        Menu {
            if viewModel.layout.nextZoomInLevel != nil {
                Button {
                    viewModel.layout.zoomIn()
                } label: {
                    Label("Zoom In", systemSymbol: .plusMagnifyingGlass)
                }
            }
            if viewModel.layout.nextZoomOutLevel != nil {
                Button {
                    viewModel.layout.zoomOut()
                } label: {
                    Label("Zoom Out", systemSymbol: .minusMagnifyingGlass)
                }
            }
            Button {
                navigator.push(.settings)
            } label: {
                Label("Settings", systemSymbol: .gearshape)
            }
        } label: {
            Image(systemSymbol: .ellipsis)
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
