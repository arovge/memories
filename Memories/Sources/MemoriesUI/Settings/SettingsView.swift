import SwiftUI

struct SettingsView: View {
    @Environment(Navigator.self) var navigator
    @Environment(\.openURL) var openURL
    @State var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView()
            } else {
                fields
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.save()
                    navigator.back()
                }
                .disabled(true) // TODO: Check if modified
            }
        }
        .task {
            await viewModel.handleAppear()
        }
    }
    
    @ViewBuilder
    var fields: some View {
        Form {
            Section("Notifications") {
                switch viewModel.notificationsAuthorizationStatus {
                case .authorized, .ephemeral, .provisional:
                    Toggle("Enabled", isOn: $viewModel.canSendDailyNotifications.animation(.interactiveSpring()))
                    if viewModel.canSendDailyNotifications {
                        DatePicker(
                            "Time",
                            selection: $viewModel.dailyNotificationSendTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                case .notDetermined, .denied:
                    Text("Notifications are currently not enabled for this app. If you'd like to receive them, please enable them in settings.")
                @unknown default:
                    EmptyView()
                }
            }
            if viewModel.limitedPhotoAccess {
                Text("This app currently has limited photos access. Consider granting it more access in settings to see more memories.")
                Button("Settings") {
                    openURL.callAsFunction(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
        }
    }
}
