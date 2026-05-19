import SwiftUI
import CoreData
import FirebaseCore
import FirebaseMessaging
import UserNotifications

// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {

    var window: UIWindow?
    private var screenProtector: CustomScreenProtectorKit?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        // Screenshot detection
        NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.screenProtector?.showCustomScreen()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.screenProtector?.hideCustomScreen()
            }
        }

        // 🔁 Listen for login/logout updates
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("LoginStatusChanged"),
            object: nil,
            queue: .main
        ) { _ in
            self.checkScreenshotPermission()
        }

        // Window + Screen Protector setup
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = windowScene.windows.first {

                self.window = keyWindow
                let protector = CustomScreenProtectorKit(window: keyWindow)
                self.screenProtector = protector

                //  CHECK permission instead of always enabling
                self.checkScreenshotPermission()
            }
        }

        // Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        requestNotificationPermission()

        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }

        return true
    }

    // MARK: - Screenshot Permission Logic
    private func checkScreenshotPermission() {
        let mobile = UserDefaults.standard.string(forKey: "mobile") ?? ""

        if mobile == "1234567890" {
            //  Allow screenshot
            screenProtector?.disable()
            print(" Screenshot ENABLED")
        } else {
            //  Block screenshot
            screenProtector?.enable()
            print(" Screenshot DISABLED")
        }
    }

    // MARK: - Notification Permission
    private func requestNotificationPermission() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            print(" Notification permission: \(granted)")
            if let error = error {
                print(" Notification error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Toast
    func showToast(message: String) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first })
            .first else { return }

        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        label.layer.cornerRadius = 12
        label.clipsToBounds = true

        let width = window.frame.width - 40
        label.frame = CGRect(
            x: 20,
            y: window.frame.height - 120,
            width: width,
            height: 50
        )

        window.addSubview(label)

        UIView.animate(withDuration: 0.4, delay: 2.0, options: .curveEaseOut) {
            label.alpha = 0
        } completion: { _ in
            label.removeFromSuperview()
        }
    }

    // MARK: - APNs
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print(" Failed to register: \(error.localizedDescription)")
    }
}



// MARK: - Firebase Messaging Delegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            UserDefaults.standard.set(token, forKey: "FCMToken")
            NotificationCenter.default.post(
                name: NSNotification.Name("FCMTokenUpdated"),
                object: nil,
                userInfo: ["token": token]
            )
            print(" FCM Token updated: \(token)")
        }
    }
}

// MARK: - UNUserNotificationCenter Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo
        print(" Notification received in foreground: \(userInfo)")
        completionHandler([.banner, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo
        print(" Notification tapped: \(userInfo)")
        completionHandler()
    }
}


// MARK: - SwiftUI App Entry
@main
struct webpadaiApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  
    
    var body: some Scene {
        WindowGroup {
           
            NavigationManager()
                .onAppear {
                    // Listen for FCM token updates
                    NotificationCenter.default.addObserver(
                        forName: NSNotification.Name("FCMTokenUpdated"),
                        object: nil,
                        queue: .main
                    ) { notification in
                        if let token = notification.userInfo?["token"] as? String {
                            print("🎯 FCM Token updated in app: \(token)")
                        }
                    }
                }
        }
    }
}


