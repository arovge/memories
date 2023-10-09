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
    private let logger = Logger()
    private var loaded: Bool = false
    
    func handleAppear() async {
        if loaded { return }
        loaded = true
        
        let accessLevel = await notificactionService.getNotificationAccessLevel()
        loading = false
        // TODO: Do something with access level
    }
    
    func save() {
        
    }
}
