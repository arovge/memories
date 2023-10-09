import UIKit

public class NotificationService {
    private let logger = Logger()
    
    public init() {}
    
    public func requestAccess() async throws {
        do {
            let hasNotificationAccess = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            
            // TODO: Schedule recurring notification if access
            
        } catch {
            logger.log(error)
            throw error
        }
    }
    
    public func getNotificationAccessLevel() async -> UNNotificationSettings {
        await UNUserNotificationCenter.current().notificationSettings()
    }
    
    public func updateNotificationRecurrence() {
        // TODO: Implement
    }
}
