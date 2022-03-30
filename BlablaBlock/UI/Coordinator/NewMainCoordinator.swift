//
//  NewMainCoordinator.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/20.
//

import UIKit

final class NewMainCoordinator: NSObject, Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    override init() {
        navigationController = UINavigationController()
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        Timber.i("start")
        let vc = LauncherViewController(
            homeViewModel: HomeViewModel(),
            userViewModel: UserViewModel(),
            portfolioViewModel: PortfolioViewModel(),
            exchangeViewModel: ExchangeApiViewModel()
        )
        navigationController.pushViewController(vc, animated: false)
    }
    
    func signIn() {
        
    }
    
    func main(
        homeViewModel: HomeViewModelType,
        userViewModel: UserViewModelType,
        portfolioViewModel: PortfolioViewModelType,
        exchangeViewModel: ExchangeApiViewModel
    ) {
        let vc = MainTabBarController(
            homeViewModel: homeViewModel,
            userViewModel: userViewModel,
            portfolioViewModel: portfolioViewModel,
            exchangeViewModel: exchangeViewModel
        )
        navigationController.pushViewController(vc, animated: true)
    }
}
