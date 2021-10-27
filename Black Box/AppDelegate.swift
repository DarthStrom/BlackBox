import FlurryAnalytics
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        let builder = FlurrySessionBuilder.init()
            .withCrashReporting(true)
            .withShowError(inLog: true)

        Flurry.startSession(Environment.flurryApiKey, with: builder)
    }
}
