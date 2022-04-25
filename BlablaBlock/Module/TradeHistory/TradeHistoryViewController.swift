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
    
    private let viewModel: TradeHistoryViewModelType
    private let userId: Int
    
    init(
        userId: Int,
        viewModel: TradeHistoryViewModelType
    ) {
        self.userId = userId
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupBinding()
        viewModel.inputs.userId.accept(userId)
        viewModel.inputs.viewDidLoad.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupUI() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pickerView)
        view.backgroundColor = .grayEDEDED
        pickerView.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        pickerView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        viewModel.outputs
            .currencyList
            .drive(onNext: { [weak self] list in
                self?.pickerView.itemList = list
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .historyData
            .drive(
                tableView.rx.items(
                    cellIdentifier: TradeHistoryTableViewCell.identifier,
                    cellType: TradeHistoryTableViewCell.self
                ),
                curriedArgument: { (row, element, cell) in
                    cell.bind(history: element)
                }
            ) 
            .disposed(by: disposeBag)
    }
    
    private let pickerView = BlablaBlockPickerView(style: .bordered)
    private let tableView = TradeHistoryTableView()
}

extension TradeHistoryViewController: BlablaBlockPickerViewDelegate {
    func blablaBlockPickerView(_ view: BlablaBlockPickerView, selectedIndex: Int) {
        viewModel.inputs
            .selectedCurrencyIndex
            .accept(selectedIndex)
    }
}
