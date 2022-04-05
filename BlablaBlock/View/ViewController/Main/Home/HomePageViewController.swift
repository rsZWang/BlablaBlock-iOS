//
//  HomePageViewController.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/28.
//

import UIKit
import Resolver
import RxDataSources

final class HomePageViewController: BaseViewController {
    
    @Injected var viewModel: HomeViewModelType
    
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
        pickerView.bind(textField: selectorTextField)
        pickerView.pickerViewDelegate = self
        tableView.separatorStyle = .none
    }
    
    private func setupLayout() {
        view.addSubview(statusBarSection)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        statusBarSection.snp.makeConstraints { make in
            make.height.equalTo(statusBarHeight)
            make.leading.top.trailing.equalToSuperview()
        }
        
        view.addSubview(topSectionView)
        topSectionView.snp.makeConstraints { make in
            make.top.equalTo(statusBarSection.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }
        
        topSectionView.addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
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
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(selectorSeparatorView.snp.leading)
        }
        
        topSectionView.addSubview(currencySelectorSection)
        currencySelectorSection.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-18)
            make.width.equalTo(90)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topSectionView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.addSubview(refreshControl)
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(tableView)
        }
    }
    
    private func setupBinding() {
        
        currencySelectorSection.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                Timber.i("show selector")
                self?.selectorTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        tableView.followBtnTap = viewModel.inputs.followBtnTap
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.refresh)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .currencyList
            .emit(onNext: { [weak self] list in
                self?.pickerView.itemList = list.map { currency in
                    if currency == "all" {
                        return "所有幣別"
                    } else {
                        return currency
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .selectedCurrency
            .emit(onNext: { [weak self] currency in
                if currency == "all" {
                    self?.selectorItemLabel.text = "所有幣別"
                } else {
                    self?.selectorItemLabel.text = currency
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .isRefreshing
            .emit(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .notificationsRefresh
            .emit(onNext: tableView.refresh)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .notificationsUpdate
            .emit(onNext: tableView.update)
            .disposed(by: disposeBag)
        
//        viewModel.outputs
//            .notifications
//            .map { [AnimatableSectionModel<String, NotificationApiData>(model: "", items: $0)] }
//            .drive(tableView.rx.items(dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, NotificationApiData>>(
//                configureCell: { [weak self] dataSource, tableView, indexPath, item in
//                    let cell = tableView.dequeueReusableCell(withIdentifier: HomePageTableViewCell.reuseIdentifier, for: indexPath) as! HomePageTableViewCell
//                    cell.bind(notification: item, followBtnTap: self?.viewModel.inputs.followBtnTap)
//                    return cell
//                }
//            )))
//            .drive(
//                tableView.rx.items(
//                    cellIdentifier: HomePageTableViewCell.reuseIdentifier,
//                    cellType: HomePageTableViewCell.self
//                ),
//                curriedArgument: { [weak self] (row, element, cell) in
//                    cell.bind(notification: element, followBtnTap: self?.viewModel.inputs.followBtnTap)
//                }
//            )
//            .disposed(by: disposeBag)
        
        viewModel.outputs
            .isNotEmpty
            .distinctUntilChanged()
            .emit(to: emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private let statusBarSection: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "bg_gray")
        return view
    }()
    
    private let topSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "bg_gray")
        return view
    }()
    
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
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "BlablaBlock"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 26)
        return label
    }()

    private let tableView: HomePageTableView = HomePageTableView()
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

extension HomePageViewController: PickerViewDelegate {
    func onSelected(index: Int, item: String) {
        viewModel.inputs
            .currencySelected
            .accept(item)
    }
}
