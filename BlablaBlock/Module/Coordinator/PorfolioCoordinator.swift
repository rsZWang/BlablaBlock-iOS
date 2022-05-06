//
//  PorfolioCoordinator.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/25.
//

import UIKit

final public class PorfolioCoordinator: Coordinator {
    
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    
    init() {
        navigationController = UINavigationController()
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
    }
    
    public func start() {}
    
    public func toTradeHistory(userId: Int) {
        let vc = TradeHistoryViewController(
            viewModel: TradeHistoryViewModel(),
            userId: userId
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func didFinishTradeHistory() {
        
    }
}
