//
//  AppDelegate.swift
//  BlablaBlock
//
//  Created by yhw on 2021/10/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate, UISceneDelegate {

    var window: UIWindow?
    let mainCoordinator = MainCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        EventTracker.initialize()
        
        if #available(iOS 13, *) { } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = mainCoordinator.navigationController
            window.makeKeyAndVisible()
            self.window = window
        }
        
        return true
    }
}
