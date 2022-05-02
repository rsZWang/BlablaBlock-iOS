//
//  AppDelegate.swift
//  BlablaBlock
//
//  Created by yhw on 2021/10/20.
//

import UIKit
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate, UISceneDelegate {

    var window: UIWindow?
    private let mainCoordinator = MainCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if DEBUG
        FirebaseApp.configure(options: FirebaseOptions(
            contentsOfFile: Bundle.main.path(
                forResource: "GoogleService-Info-debug",
                ofType: "plist"
            )!
        )!)
        #else
        FirebaseApp.configure()
        #endif
        EventTracker.initialize()
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: { _, _ in }
        )
        UIApplication.shared.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        if #available(iOS 13, *) { } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = mainCoordinator.navigationController
            window.makeKeyAndVisible()
            self.window = window
        }
        mainCoordinator.start()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlString = url.absoluteString
        Timber.i("Open from: \(urlString)")
        if urlString.contains("/users/password/edit") {
            // Reset password link
            if let token = Utils.getQueryStringParameter(url: urlString, param: "reset_password_token") {
                mainCoordinator.resetPassword(token: token)
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(
        application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { token, error in
            if let error = error {
                Timber.e("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                Timber.i("FCM registration token: \(token)")
            }
        }
    }
    
    // 使用者點選推播時觸發
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void)
    {
        EventTracker.Builder()
            .logEvent(.CHECK_NOTIFICATIONS)
        completionHandler()
    }
    
    // 讓 App 在前景也能顯示推播
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Timber.i("Firebase registration token: \(String(describing: fcmToken))")

//        let dataDict: [String: String] = ["token": fcmToken ?? ""]
//        NotificationCenter.default.post(
//            name: Notification.Name("FCMToken"),
//            object: nil,
//            userInfo: dataDict
//        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
