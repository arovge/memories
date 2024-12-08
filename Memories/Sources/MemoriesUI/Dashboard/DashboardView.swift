import SwiftUI

public struct DashboardView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(Navigator.self) var navigator
    
    @State var viewModel = DashboardViewModel()
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            MediaGridView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollDisabled(viewModel.loading || !viewModel.hasPhotosAccess || !viewModel.hasMemories)
        .overlay {
            if viewModel.loading {
                ProgressView()
            } else if !viewModel.hasPhotosAccess {
                NoPhotosAccessView()
            } else if !viewModel.hasMemories {
                ContentUnavailableView(
                    "No memories today",
                    systemSymbol: .photoOnRectangleAngled,
                    description: Text("Take some more pictures for next year!")
                )
            }
        }
        .environment(viewModel)
        .navigationBarTitle("Your memories")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text(viewModel.currentMonthAndDay)
                    .foregroundStyle(.secondary)
                    .font(.headline)
            }
            ToolbarItem(placement: .topBarTrailing) {
                trailing()
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            guard oldValue != .active && newValue == .active else { return }
            Task {
                await viewModel.handleAppear(force: true)
            }
        }
    }
    
    @ViewBuilder
    func trailing() -> some View {
        if viewModel.hasPhotosAccess && viewModel.hasMemories {
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
                settingsButton()
            } label: {
                Image(systemSymbol: .ellipsis)
            }
        } else {
            settingsButton()
        }
    }
    
    func settingsButton() -> some View {
        Button {
            navigator.push(.settings)
        } label: {
            Label("Settings", systemSymbol: .gearshape)
        }
    }
}

#Preview {
    NavigationView {
        DashboardView()
    }
}
