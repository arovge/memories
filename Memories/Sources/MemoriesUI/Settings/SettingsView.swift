import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
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
                    dismiss()
                }
                .disabled(true) // TODO: Fix
            }
        }
        .task {
            await viewModel.handleAppear()
        }
    }
    
    @ViewBuilder
    var fields: some View {
        Form {
            Section(header: Text("Notifications")) {
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
        }
    }
}
