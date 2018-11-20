import Foundation
import UserNotifications
import UIKit

final class SheduleNotification {
    
    /// Notification for every day
    ///
    /// - Parameters:
    ///   - title: String
    ///   - subtitle: String
    ///   - body: String
    class func sheduleNotification(title: String, subtitle: String, body: String) {
        let notificationIdentifier = NotificationConstant.identifier
        removeNotifications(withIdentifers: [notificationIdentifier])
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 09
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    /// Remove notifications
    ///
    /// - Parameter identifiers: [String]
    final class func removeNotifications(withIdentifers identifiers: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
