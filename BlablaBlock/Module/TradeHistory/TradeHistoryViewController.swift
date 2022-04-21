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
    
    @Injected var viewModel: TradeHistoryViewModelType
    var userId: Int?
    
    private let tableView: TradeHistoryTableView = TradeHistoryTableView()
    
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
        view.backgroundColor = #colorLiteral(red: 0.1803734004, green: 0.1804045737, blue: 0.1803635955, alpha: 1)
        pickerView.bind(textField: selectorTextField)
        pickerView.pickerViewDelegate = self
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        currencySelectorSection.addSubview(selectorTextField)
        currencySelectorSection.addSubview(selectorItemLabel)
        currencySelectorSection.addSubview(selectorSeparatorView)
        currencySelectorSection.addSubview(selectorDropLabel)
        
        selectorDropLabel.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.top.trailing.bottom.equalToSuperview()
        }
        
        selectorSeparatorView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(selectorDropLabel.snp.leading)
        }
        
        selectorItemLabel.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.leading.equalToSuperview().offset(6)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(selectorSeparatorView.snp.leading).offset(-6)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: currencySelectorSection)
    }
    
    private func setupBinding() {
        currencySelectorSection.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.selectorTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .currencyList
            .emit(onNext: { [weak self] list in
                self?.pickerView.itemList = list
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .selectedCurrency
            .emit(onNext: { [weak self] currency in
                self?.selectorItemLabel.text = currency
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
    
    private let currencySelectorSection: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    private let selectorItemLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let selectorSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let selectorDropLabel: UILabel = {
        let label = UILabel()
        label.text = " V"
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    
    private let selectorTextField = UITextField()
    private let pickerView = PickerView()
}

extension TradeHistoryViewController: PickerViewDelegate {
    func pickerView(_ pickerView: PickerView, selectedIndex: Int, selectedItem: String) {
        if selectedItem.isNotEmpty {
            viewModel.inputs
                .currencySelected
                .accept(selectedItem)
        }
    }
}
