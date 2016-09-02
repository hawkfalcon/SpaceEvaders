import UIKit
import SpriteKit
import Fabric
import Crashlytics
import GameAnalytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey:Any]?) -> Bool {
        Fabric.with([Crashlytics.self, GameAnalytics.self])
        GCHelper.sharedInstance.authenticateLocalUser()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        let defaults = UserDefaults.standard
        defaults.set(Options.option.getOptions(), forKey: "options")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }
}

