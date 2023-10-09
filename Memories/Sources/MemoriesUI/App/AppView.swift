import SwiftUI

public struct AppView: View {
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
        .environmentObject(navigator)
    }
}
