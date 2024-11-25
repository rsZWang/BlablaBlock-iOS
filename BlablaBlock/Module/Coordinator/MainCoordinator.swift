//
//  MainCoordinator.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/20.
//

import UIKit

final public class MainCoordinator: Coordinator {
    
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    private let signInViewController = SignInViewController(viewModel: SignInViewModel())
    
    init() {
        navigationController = UINavigationController()
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
//        let profolioCoordinator = Coordinator()
    }
    
//    func start() {
//        let vc = LauncherViewController(
//            homePageViewModel: HomePageViewModel(),
//            exploreUserViewModel: ExploreUserViewModel(),
//            portfolioViewModel: PortfolioViewModel(),
//            exchangeViewModel: ExchangeApiViewModel()
//        )
//        navigationController.pushViewController(vc, animated: false)
//    }
    
//    func main(
//        homePageViewModel: HomePageViewModelType,
//        exploreUserViewModel: ExploreUserViewModelType,
//        portfolioViewModel: PortfolioViewModelType,
//        exchangeViewModel: ExchangeApiViewModel
//    ) {
//        let vc = MainTabBarController(
//            homePageViewModel: homePageViewModel,
//            exploreUserViewModel: exploreUserViewModel,
//            portfolioViewModel: portfolioViewModel,
//            exchangeViewModel: exchangeViewModel
//        )
//        navigationController.pushViewController(vc, animated: true)
//    }
    
    public func resetPassword(token: String) {
        if let vc = Utils.findMostTopViewController() as? SignInViewController {
            vc.resetPassword(token: token)
        }
    }
    
    public func start() {
        let vc = LauncherViewController(
            parentCoordinator: self,
            viewModel: LauncherViewModel()
        )
        navigationController.pushViewController(vc, animated: false)
    }
    
    public func signIn() {
        signInViewController.parentCoordinator = self
        navigationController.pushViewController(signInViewController, animated: true)
    }
    
    public func main() {
        let vc = MainTabBarController(
            parentCoordinator: self
//            parentCoordinator: self,
//            homePageViewModel: HomePageViewModel(),
//            exploreUserViewModel: ExploreUserViewModel(),
//            portfolioViewModel: PortfolioViewModel(),
//            followViewModel: FollowViewModel(),
//            exchangeViewModel: ExchangeApiViewModel()
        )
        navigationController.pushViewController(vc, animated: true)
        if navigationController.viewControllers.count == 2 {
            signInViewController.parentCoordinator = self
            navigationController.viewControllers.insert(signInViewController, at: 1)
        }
    }
    
    public func toPortfolio(user: UserPerformanceApiData) {
//        let vc = PortfolioViewController(
//            parentCoordinator: self,
//            viewModel: PortfolioViewModel(),
//            followViewModel: FollowViewModel(),
//            user: user
//        )
//        navigationController.pushViewController(vc, animated: true)
    }
    
    public func toFollow(
        isDefaultPageFollower: Bool,
        viewModel: FollowViewModelType
    ) {
        let vc = FollowViewController(
            parentCoordinator: self,
            viewModel: viewModel,
            isDefaultPageFollower: isDefaultPageFollower
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func toTradyHistory(userId: Int) {
        let vc = TradeHistoryViewController(
            viewModel: TradeHistoryViewModel(),
            userId: userId
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func changeLanguage() {
        navigationController.popViewController(animated: false)
        let vc = MainTabBarController(
            parentCoordinator: self
//            parentCoordinator: self,
//            homePageViewModel: HomePageViewModel(),
//            exploreUserViewModel: ExploreUserViewModel(),
//            portfolioViewModel: PortfolioViewModel(),
//            followViewModel: FollowViewModel(),
//            exchangeViewModel: ExchangeApiViewModel()
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func loguot() {
        navigationController.popToViewController(signInViewController, animated: true)
    }
    
    public func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
