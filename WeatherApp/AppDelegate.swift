import UIKit
import GooglePlaces
import UserNotifications
import CoreData
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey(AppDelegateConstant.googleAPIKey)
        let  center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (_, _) in
        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        //        CoreDataManager.sharedManager.saveContext()
    }
}
