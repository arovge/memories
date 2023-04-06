import SwiftUI
import Memories

@main
struct RootView: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                DashboardView()
            }
        }
    }
}
