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
    var limitedPhotoAccess = false
    
    private let photosService: PhotosService = PhotosService()
    private let notificactionService: NotificationService = NotificationService()
    private let logger = Logger()
    private var loaded: Bool = false
    
    func handleAppear() async {
        if loaded { return }
        loaded = true
        
        await checkPhotosAccess()
        let accessLevel = await notificactionService.getNotificationAccessLevel()
        loading = false
        // TODO: Do something with access level
    }
    
    func checkPhotosAccess() async {
        let result = await photosService.requestAccess()
                
        limitedPhotoAccess = switch result {
        case .notDetermined: // need to prompt here
            false
        case .restricted:
            true
        case .denied:
            false
        case .authorized:
            false
        case .limited:
            true
        @unknown default:
            false
        }
    }
    
    func save() {
        
    }
}
