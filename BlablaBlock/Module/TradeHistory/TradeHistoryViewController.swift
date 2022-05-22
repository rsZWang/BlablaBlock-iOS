//
//  TradeHistoryViewController.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import UIKit
import SnapKit

final class TradeHistoryViewController: BaseViewController {
    
    static let filterAll = "vc_trade_history_fitler_crypto_currency".localized()
    
    private let viewModel: TradeHistoryViewModelType!
    private let userId: Int
    
    init(
        viewModel: TradeHistoryViewModelType,
        userId: Int
    ) {
        self.viewModel = viewModel
        self.userId = userId
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
    
    private func setupUI() {
        view.backgroundColor = .grayEDEDED
        
        navigationSectionView.title = "vc_trade_history_order_history".localized()
        navigationSectionView.delegate = self
        
        pickerView.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(statusBarSection)
        statusBarSection.snp.makeConstraints { make in
            make.height.equalTo(Utils.statusBarHeight)
            make.leading.top.trailing.equalToSuperview()
        }
        
        view.addSubview(navigationSectionView)
        navigationSectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(statusBarSection.snp.bottom)
        }
        
        navigationSectionView.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationSectionView.snp.bottom).offset(3)
            make.leading.trailing.bottom.equalToSuperview()
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
    
    private let statusBarSection = UIView()
    private let navigationSectionView = BlablaBlockNavigationBarView()
    private let pickerView = BlablaBlockPickerView(style: .bordered)
    private let tableView = TradeHistoryTableView()
}

extension TradeHistoryViewController: BlablaBlockNavigationBarViewDelegate {
    func onBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension TradeHistoryViewController: BlablaBlockPickerViewDelegate {
    func blablaBlockPickerView(_ view: BlablaBlockPickerView, selectedIndex: Int) {
        viewModel.inputs
            .selectedCurrencyIndex
            .accept(selectedIndex)
    }
}
