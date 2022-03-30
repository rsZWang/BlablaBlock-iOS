//
//  MainCoordinator.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/26.
//

import UIKit
import Toast_Swift
import RxSwift

final class MainCoordinator: NSObject, Coordinator {
    
    private let mainSB = UIStoryboard(name: "Main", bundle: nil)
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private lazy var resetPasswordDialog: InputAlertBuilder = InputAlertBuilder() 
    
    override init() {
        navigationController = UINavigationController()
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
    }

    func start() {
//        let vc = LauncherViewController()
//        navigationController.pushViewController(vc, animated: false)
    }
    
    func signIn() {
        let vc = SignInViewController.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func resetPassword(token: String) {
        if let vc = Utils.findMostTopViewController() as? BaseViewController {
            resetPasswordDialog
                .setTitle("重設密碼")
                .setMessage("")
                .addTextField(tag: 1, placeholder: "新密碼")
                .setConfirmButton(title: "送出", action: { result in
                    Timber.i("result: \(result)")
                    if let password = result[1] {
                        Timber.i("password: \(password)")
                        AuthService.resetPassword(token: token, password: password)
                            .request()
                            .observe(on: MainScheduler.asyncInstance)
                            .subscribe(
                                onSuccess: { response in
                                    switch response {
                                    case .success(_):
                                        vc.view.makeToast("重設成功🥳", duration: 2.0)
                                    case .failure(_):
                                        vc.view.makeToast("重設失敗，請再嘗試看看😅", duration: 2.0)
                                    }
                                },
                                onFailure: { error in
                                    vc.promptAlert(error: error)
                                }
                            )
                            .disposed(by: vc.disposeBag)
                    }
                })
                .build()
                .show()
        }
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
        let vc = mainSB.instantiateViewController(withIdentifier: "PortfolioViewController") as! PortfolioViewController
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
