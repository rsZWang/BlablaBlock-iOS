//
//  PorfolioCoordinator.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/25.
//

import UIKit

final class PorfolioCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init() {
        navigationController = UINavigationController()
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
    }
    
    func start() {}
    
    func toTradeHistory(userId: Int) {
        let vc = TradeHistoryViewController(
            userId: userId,
            viewModel: TradeHistoryViewModel()
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didFinishTradeHistory() {
        
    }
}
