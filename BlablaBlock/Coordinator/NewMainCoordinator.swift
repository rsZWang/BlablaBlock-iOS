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
            searchViewModel: SearchViewModel(),
            portfolioViewModel: PortfolioViewModel(),
            exchangeViewModel: ExchangeViewModel()
        )
        navigationController.pushViewController(vc, animated: false)
    }
    
    func signIn() {
        
    }
    
    func main(
        homeViewModel: HomeViewModelType,
        searchViewModel: SearchViewModelType,
        portfolioViewModel: PortfolioViewModelType,
        exchangeViewModel: ExchangeViewModelType
    ) {
        let vc = MainTabBarController(
            homeViewModel: homeViewModel,
            searchViewModel: searchViewModel,
            portfolioViewModel: portfolioViewModel,
            exchangeViewModel: exchangeViewModel
        )
        navigationController.pushViewController(vc, animated: true)
    }
}
