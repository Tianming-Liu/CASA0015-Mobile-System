import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    //Load API key from Keys.plist
    var keys: NSDictionary?

    if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
      keys = NSDictionary(contentsOfFile: path)
    }

    if let dict = keys {
      let apiKey = dict["GOOGLE_MAPS_API_KEY"] as! String
      GMSServices.provideAPIKey(apiKey)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
