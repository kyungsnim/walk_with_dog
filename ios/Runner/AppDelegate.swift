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
    // GMSServices.provideAPIKey("AIzaSyCxpAI7_oyr4Na46DdT9Zmv_0uX1IuXt74")
    GMSServices.provideAPIKey("AIzaSyC9Dlk1jky-n9-FKd-e25sgsi64YxTkb-k")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
