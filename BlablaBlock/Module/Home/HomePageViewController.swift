//
//  HomePageViewController.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/28.
//

import UIKit
import RxDataSources

final class HomePageViewController: BaseViewController {
    
    private let viewModel: HomePageViewModelType
    
    init(viewModel: HomePageViewModelType) {
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
        viewModel.inputs.viewDidLoad.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.viewWillAppear.accept(())
    }
    
    private func setupUI() {
        view.backgroundColor = .grayE5E5E5
        pickerView.delegate = self
        logoImageView.image = "ic_home_page_logo".image()
        tableView.viewModel = viewModel
    }
    
    private func setupLayout() {
        view.addSubview(statusBarSection)
        statusBarSection.snp.makeConstraints { make in
            make.height.equalTo(Utils.statusBarHeight)
            make.leading.top.trailing.equalToSuperview()
        }
        
        view.addSubview(topSectionView)
        topSectionView.snp.makeConstraints { make in
            make.top.equalTo(statusBarSection.snp.bottom)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        topSectionView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        topSectionView.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(24)
            make.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topSectionView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.addSubview(refreshControl)
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(tableView)
        }
    }
    
    private func setupBinding() {
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.refresh)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .currencyList
            .drive(onNext: { [weak self] list in
                self?.pickerView.itemList = list
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .refreshControl
            .emit(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
//        viewModel.outputs
//            .notifications
//            .emit(onNext: tableView.refresh)
//            .disposed(by: disposeBag)
        
        viewModel.outputs
            .notifications
            .drive(
                tableView.rx.items(
                    cellIdentifier: HomePageTableViewCell.identifier,
                    cellType: HomePageTableViewCell.self
                ),
                curriedArgument: { [weak self] (row, element, cell) in
                    cell.viewModel = self?.viewModel
                    cell.bind(notification: element)
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .isNotEmpty
            .distinctUntilChanged()
            .emit(to: emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .errorMessage
            .asSignal()
            .emit(onNext: { [weak self] msg in
                self?.promptAlert(message: msg)
            })
            .disposed(by: disposeBag)
    }
    
    private let statusBarSection = UIView()
    private let pickerView = BlablaBlockPickerView(style: .bordered)
    private let topSectionView = UIView()
    private let logoImageView = UIImageView()
    private let tableView = HomePageTableView()
    private let refreshControl = UIRefreshControl()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "請至設定頁面串接交易所API，\n以獲取追蹤他人投資組合"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 5
        label.isHidden = true
        return label
    }()
}

extension HomePageViewController: BlablaBlockPickerViewDelegate {
    func blablaBlockPickerView(_ view: BlablaBlockPickerView, selectedIndex: Int) {
        viewModel.inputs
            .selectedCurrencyIndex
            .accept(selectedIndex)
    }
}
