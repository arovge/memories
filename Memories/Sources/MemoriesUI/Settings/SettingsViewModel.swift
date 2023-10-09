import SwiftUI
import MemoriesServices

@Observable
class SettingsViewModel {
    var loading: Bool = true
    var error: Bool = false
    var hasPhotosAccess: Bool = false
    var canSendDailyNotifications: Bool = false
    var dailyNotificationSendTime: Date = Date()
    var notificationsAuthorizationStatus: UNAuthorizationStatus = .notDetermined
    
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
