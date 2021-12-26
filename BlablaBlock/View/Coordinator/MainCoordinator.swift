//
//  MainCoordinator.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/26.
//

import UIKit

class MainCoordinator: Coordinator {
    
    private let mainSB = UIStoryboard(name: "Main", bundle: nil)
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init() {
        navigationController = UINavigationController()
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
    }

    func start() {
        let vc = LauncherViewController()
        navigationController.pushViewController(vc, animated: false)
    }
    
    func signIn() {
        let vc = SignInViewController.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func main(isSignIn: Bool, hasLinked: Bool) {
        let tabBarController = mainSB.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        tabBarController.tabBar.barTintColor = UIColor(named: "gray_tab_bar")!
        tabBarController.selectedIndex = hasLinked ? 0 : 1
        navigationController.pushViewController(tabBarController, animated: true)
        if !isSignIn {
            let signInViewController = SignInViewController.instantiate()
            navigationController.viewControllers.insert(signInViewController, at: 1)
        }
    }
    
    func popToSignIn() {
        let signInViewController = navigationController.viewControllers[1]
        navigationController.popToViewController(signInViewController, animated: true)
    }
    
}
