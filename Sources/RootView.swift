import SwiftUI

@main
struct RootView: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                DashboardView(viewModel: .init())
            }
        }
    }
}
