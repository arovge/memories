import SwiftUI

public struct DashboardView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(Navigator.self) var navigator
    
    @State var viewModel = DashboardViewModel()
    
    public init() {}
    
    public var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView()
            } else if !viewModel.hasPhotosAccess {
                PhotosUnavailableView()
            } else {
                MemoriesView()
                    .environment(viewModel)
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
        .refreshable {
            await viewModel.handleAppear(force: true)
        }
        .task {
            await viewModel.handleAppear()
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            guard oldValue != .active && newValue == .active else { return }
            Task {
                await viewModel.checkPhotosAccess()
            }
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

#Preview {
    NavigationView {
        DashboardView()
    }
}
