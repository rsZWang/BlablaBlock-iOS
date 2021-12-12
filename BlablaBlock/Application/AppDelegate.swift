//
//  AppDelegate.swift
//  BlablaBlock
//
//  Created by yhw on 2021/10/20.
//

import UIKit
import Firebase
import Resolver

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate, UISceneDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Resolver.registerAllServices()
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window?.overrideUserInterfaceStyle = .light
    }
}
