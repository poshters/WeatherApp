import UIKit
import GooglePlaces
import GoogleMaps
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import UserNotifications
import Fabric
import Crashlytics
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey(AppDelegateConstant.googleAPIKey)
        GMSServices.provideAPIKey(AppDelegateConstant.googlMapAPIKey)
        GIDSignIn.sharedInstance().clientID = AppDelegateConstant.googleSignIn
        let  center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (_, _) in
        }
        FBSDKApplicationDelegate.sharedInstance()?.application(application,
                                                               didFinishLaunchingWithOptions: launchOptions)
              Fabric.with([Crashlytics.self])
        self.logUser()
        FirebaseApp.configure()
        return true
    }
    
    func logUser() {
        Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
        Crashlytics.sharedInstance().setUserIdentifier("12345")
        Crashlytics.sharedInstance().setUserName("Test User")
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?, sourceApplication:
            options[UIApplication.OpenURLOptionsKey.sourceApplication] as?String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
}
