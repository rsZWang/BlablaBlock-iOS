//
//  TradeHistoryViewController.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import UIKit
import SnapKit
import Resolver

final class TradeHistoryViewController: BaseViewController {
    
    private let tableView: TradeHistoryTableView = TradeHistoryTableView()
    
    @Injected var viewModel: TradeHistoryViewModel
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        viewModel.inputs.viewDidLoad.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupUI() {
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = #colorLiteral(red: 0.1803734004, green: 0.1804045737, blue: 0.1803635955, alpha: 1)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        viewModel.outputs
            .historyData
            .drive(
                tableView.rx.items(
                    cellIdentifier: TradeHistoryTableView.reuseIdentifier,
                    cellType: TradeHistoryTableViewCell.self
                ),
                curriedArgument: { (row, element, cell) in
                    cell.bind(history: element)
                }
            ) 
            .disposed(by: disposeBag)
    }
    
}
