import UIKit
import Flutter
import Firebase



@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure() //add this before the code below
    GeneratedPluginRegistrant.register(with: self)
    // Request permission to use notifications
        requestNotificationAuthorization(application)

        return true
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  func requestNotificationAuthorization(_ application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }

    // This method will be called once the user has granted permission and APNs has successfully registered the app
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert APNs token to string
        let apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()

        // Print the APNs token (you can send it to your server if needed)
        print("APNs token: \(apnsToken)")

        // Pass the APNs token to Firebase (if FCM token is requested later)
        Messaging.messaging().apnsToken = deviceToken
    }

    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
}
