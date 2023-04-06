import UIKit

class NotificationService {
    private let logService: LogService = LogService()
    
    func requestAccess() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                self.logService.log(error)
            }
            
            // TODO: Schedule recurring notification
        }
    }
    
    func getNotificationAccessLevel(_ callback: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            callback(settings.authorizationStatus)
        }
    }
    
    func updateNotificationRecurrence() {
        // TODO: Implement
    }
}
