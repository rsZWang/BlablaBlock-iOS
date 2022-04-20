//
//  ExploreUserViewController.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/3.
//

import UIKit
import SnapKit
import Resolver
import RxDataSources

final class ExploreUserViewController: BaseViewController {
    
    private let viewModel: ExploreUserViewModelType
    
    init(viewModel: ExploreUserViewModelType) {
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
    
    private func setupUI() {
        view.backgroundColor = .grayE5E5E5
        
        searchTitleLabel.font = .boldSystemFont(ofSize: 24)
        searchTitleLabel.text = "探索"
        searchTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        searchTextField.layer.cornerRadius = 4
        searchTextField.font = .systemFont(ofSize: 14)
        searchTextField.placeholder = "🔍  搜尋"
        searchTextField.backgroundColor = .white
        
        tableView.addSubview(refreshControl)
        
        emptyLabel.text = "請至設定頁面串接交易所API，\n以獲取追蹤他人投資組合"
        emptyLabel.font = .boldSystemFont(ofSize: 18)
        emptyLabel.textColor = .white
        emptyLabel.numberOfLines = 5
        emptyLabel.isHidden = true
    }
    
    private func setupLayout() {
        view.addSubview(statusBarSection)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        statusBarSection.snp.makeConstraints { make in
            make.height.equalTo(statusBarHeight)
            make.leading.top.trailing.equalToSuperview()
        }
        
        view.addSubview(topSearchSectionView)
        topSearchSectionView.snp.makeConstraints { make in
            make.top.equalTo(statusBarSection.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        topSearchSectionView.addSubview(searchTitleLabel)
        topSearchSectionView.addSubview(searchTextField)
        
        searchTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalTo(searchTextField)
        }

        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(searchTitleLabel.snp.trailing).offset(24)
            make.top.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topSearchSectionView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topSearchSectionView)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        searchTextField.rx
            .text
            .orEmpty
            .skip(1)
            .bind(to: viewModel.inputs.userName)
            .disposed(by: disposeBag)
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.refresh)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .users
            .drive(
                tableView.rx.items(
                    cellIdentifier: ExploreUserTableViewCell.identifier,
                    cellType: ExploreUserTableViewCell.self
                ),
                curriedArgument: { (row, element, cell) in
                    cell.bind(element)
                }
            )
            .disposed(by: disposeBag)
        
//        viewModel.outputs
//            .users
//            .map { [AnimatableSectionModel<String, UserApiData>(model: "", items: $0)] }
//            .drive(tableView.rx.items(
//                dataSource:
//                    RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, UserApiData>>(
//                        configureCell: { _, tableView, indexPath, item in
//                            let cell = tableView.dequeueReusableCell(withIdentifier: ExploreUserTableViewCell.identifier, for: indexPath) as! ExploreUserTableViewCell
//                            cell.bind(item)
//                            return cell
//                        }
//                    )
//            ))
//            .disposed(by: disposeBag)
        
        viewModel.outputs
            .isNotEmpty
            .distinctUntilChanged()
            .drive(emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
//        viewModel.outputs
//            .selectedUser
//            .emit(onNext: coordinator.showPortfolioBy)
//            .disposed(by: disposeBag)
        
        viewModel.outputs
            .refreshControl
            .emit(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag) 
    }
    
    private let statusBarSection = UIView()
    private let topSearchSectionView = UIView()
    private let searchTitleLabel = UILabel()
    private let searchTextField: UITextField = TextFieldWithPadding()
    private let tableView = ExploreUserTableView()
    private let refreshControl = UIRefreshControl()
    private let emptyLabel = UILabel()
}