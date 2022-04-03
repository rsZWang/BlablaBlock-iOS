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
        let vc = LauncherViewController(
            homePageViewModel: HomePageViewModel(),
            exploreUserViewModel: ExploreUserViewModel(),
            portfolioViewModel: PortfolioViewModel(),
            exchangeViewModel: ExchangeApiViewModel()
        )
        navigationController.pushViewController(vc, animated: false)
    }
    
    func signIn() {
        
    }
    
    func main(
        homePageViewModel: HomePageViewModelType,
        exploreUserViewModel: ExploreUserViewModelType,
        portfolioViewModel: PortfolioViewModelType,
        exchangeViewModel: ExchangeApiViewModel
    ) {
        let vc = MainTabBarController(
            homePageViewModel: homePageViewModel,
            exploreUserViewModel: exploreUserViewModel,
            portfolioViewModel: portfolioViewModel,
            exchangeViewModel: exchangeViewModel
        )
        navigationController.pushViewController(vc, animated: true)
    }
}
