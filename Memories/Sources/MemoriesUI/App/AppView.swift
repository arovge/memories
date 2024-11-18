import SwiftUI

public struct AppView: View {
    @Environment(\.scenePhase) var scenePhase
    @State var viewModel = AppViewModel()
    @State var navigator = Navigator()
    
    public init() {}
    
    public var body: some View {
        NavigationStack(path: $navigator.path) {
            ProgressView()
                .navigationDestination(for: Route.self) { route in
                    renderRoute(for: route)
                }
                .task {
                    await viewModel.handleAppear(navigator)
                }
                .onChange(of: scenePhase) { oldValue, newValue in
                    guard oldValue != .active && newValue == .active else { return }
                    Task {
                        await viewModel.handleAppear(isFromSceneChange: true, navigator)
                    }
                }
        }
    }
    
    func renderRoute(for route: Route) -> some View {
        Group {
            switch route {
            case .requestAccess:
                RequestAccessView()
                    .navigationBarBackButtonHidden()
            case .dashboard:
                DashboardView()
                    .navigationBarBackButtonHidden()
            case .settings:
                SettingsView()
            }
        }
        .environment(navigator)
    }
}
