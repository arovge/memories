import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var loading: Bool = true
    @Published var error: Bool = false
    @Published var hasPhotosAccess: Bool = false
    @Published var canSendDailyNotifications: Bool = false
    @Published var dailyNotificationSendTime: Date = Date()
    @Published var notificationsAuthorizationStatus: UNAuthorizationStatus = .notDetermined
    private let photosService: PhotosService = PhotosService()
    private let notificactionService: NotificationService = NotificationService()
    private let logService: LogService = LogService()
    private var loaded: Bool = false
    
    func handleAppear() {
        if loaded { return }
        loaded = true
        
        notificactionService.getNotificationAccessLevel { status in
            DispatchQueue.main.async {
                self.notificationsAuthorizationStatus = status
                self.loading = false
            }
        }
    }
    
    func save() {
        
    }
}
