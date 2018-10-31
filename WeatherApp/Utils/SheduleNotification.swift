import Foundation
import UserNotifications
import UIKit

final class SheduleNotification {
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
        dateComponents.minute = 52
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    final class func removeNotifications(withIdentifers identifiers: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
