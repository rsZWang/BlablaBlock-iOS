//
//  MainCoordinator.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/26.
//

import UIKit

final class MainCoordinator: NSObject, Coordinator {
    
    private let mainSB = UIStoryboard(name: "Main", bundle: nil)
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    override init() {
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
//        tabBarController.selectedIndex = hasLinked ? 1 : 2
        navigationController.pushViewController(tabBarController, animated: true)
        if !isSignIn {
            let signInViewController = SignInViewController.instantiate()
            navigationController.viewControllers.insert(signInViewController, at: 1)
        }
    }
    
    func showFollow(isDefaultPageFollower: Bool, followViewModel: FollowViewModelType) {
        let vc = FollowViewController()
        vc.isDefaultPageFollower = isDefaultPageFollower
        vc.viewModel = followViewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showTradeHistoryBy(userId: Int?) {
        let vc = TradeHistoryViewController()
        vc.userId = userId
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showPortfolioBy(user: UserApiData) {
        let vc = mainSB.instantiateViewController(withIdentifier: "StatisticsViewController") as! StatisticsViewController
        vc.user = user
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popToSignIn() {
        let signInViewController = navigationController.viewControllers[1]
        navigationController.popToViewController(signInViewController, animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
}
