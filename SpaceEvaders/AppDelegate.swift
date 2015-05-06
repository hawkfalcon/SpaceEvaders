import UIKit
import SpriteKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool {
        Fabric.with([Crashlytics()])
        GCHelper.sharedInstance.authenticateLocalUser()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(Options.option.getOptions(), forKey: "options")
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }
}

