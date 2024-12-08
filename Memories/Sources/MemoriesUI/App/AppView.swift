import SwiftUI

public struct AppView: View {
    @State var navigator = Navigator()
    
    public init() {}
    
    public var body: some View {
        NavigationStack(path: $navigator.path) {
            EmptyView()
                .navigationDestination(for: Route.self) { route in
                    renderRoute(for: route)
                }
        }
    }
    
    func renderRoute(for route: Route) -> some View {
        Group {
            switch route {
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
