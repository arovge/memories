import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.loading {
                    ProgressView()
                } else {
                    fields
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.save()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                viewModel.handleAppear()
            }
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
