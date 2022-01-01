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
    @Injected var mainCoordinator: MainCoordinator

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13, *) {
            
        } else {
            mainCoordinator.start()
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = mainCoordinator.navigationController
            window.makeKeyAndVisible()
            self.window = window
        }
        
        FirebaseApp.configure()
        Resolver.registerAllServices()
        
        return true
    }
    
    static func getThreadName() -> String {
        if Thread.current.isMainThread {
            return "Main Thread"
        } else if let name = Thread.current.name {
            if name == "" {
                return "Anonymous Thread"
            } else {
                return name
            }
        } else {
            return "Unknown Thread"
        }
    }
}
