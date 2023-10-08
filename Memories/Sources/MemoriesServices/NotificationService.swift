import UIKit

public class NotificationService {
    private let logService: LogService = LogService()
    
    public init() {}
    
    public func requestAccess() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                self.logService.log(error)
            }
            
            // TODO: Schedule recurring notification
        }
    }
    
    public func getNotificationAccessLevel(_ callback: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            callback(settings.authorizationStatus)
        }
    }
    
    public func updateNotificationRecurrence() {
        // TODO: Implement
    }
}
