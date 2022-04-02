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
        viewModel.inputs.viewDidLoad.accept(())
        tableView.separatorStyle = .none
        setupLayout()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.viewWillAppear.accept(())
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
        tableView.followBtnTap = viewModel.inputs.followBtnTap
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.refresh)
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
