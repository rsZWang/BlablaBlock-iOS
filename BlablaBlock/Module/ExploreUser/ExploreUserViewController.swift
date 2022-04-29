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
    
    private weak var parentCoordinator: MainCoordinator!
    private let viewModel: ExploreUserViewModelType
    
    init(
        parentCoordinator: MainCoordinator?,
        viewModel: ExploreUserViewModelType
    ) {
        self.parentCoordinator = parentCoordinator
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
        
        pickerView.delegate = self
        pickerView.itemList = ExploreUserFilter.titleList
        
        tableView.addSubview(refreshControl)
        
        emptyLabel.text = "請至設定頁面串接交易所API，\n以獲取追蹤他人投資組合"
        emptyLabel.font = .boldSystemFont(ofSize: 18)
        emptyLabel.textColor = .white
        emptyLabel.numberOfLines = 5
        emptyLabel.isHidden = true
    }
    
    private func setupLayout() {
        view.addSubview(statusBarSection)
        statusBarSection.snp.makeConstraints { make in
            make.height.equalTo(Utils.statusBarHeight)
            make.leading.top.trailing.equalToSuperview()
        }
        
        view.addSubview(topSearchSectionView)
        topSearchSectionView.snp.makeConstraints { make in
            make.top.equalTo(statusBarSection.snp.bottom)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        topSearchSectionView.addSubview(searchTitleLabel)
        searchTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        topSearchSectionView.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        topSearchSectionView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(searchTitleLabel.snp.trailing).offset(24)
            make.top.equalToSuperview().offset(12)
            make.trailing.equalTo(pickerView.snp.leading).offset(-24)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topSearchSectionView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(tableView)
        }
    }
    
    private func setupBinding() {
        searchTextField.rx
            .text
            .orEmpty
            .skip(2)
            .bind(to: viewModel.inputs.userName)
            .disposed(by: disposeBag)
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.refresh)
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .bind(to: viewModel.inputs.selectedIndexPath)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .users
            .drive(
                tableView.rx.items(
                    cellIdentifier: ExploreUserTableViewCell.identifier,
                    cellType: ExploreUserTableViewCell.self
                ),
                curriedArgument: { [weak self] (row, element, cell) in
                    cell.viewModel = self?.viewModel
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
        
        viewModel.outputs
            .selectedUser
            .emit(onNext: { [weak self] user in
                self?.parentCoordinator?.toPortfolio(user: user)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .refreshControl
            .emit(to: refreshControl.rx.isRefreshing)
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
    private let topSearchSectionView = UIView()
    private let searchTitleLabel = UILabel()
    private let searchTextField: UITextField = TextFieldWithPadding()
    private let tableView = ExploreUserTableView()
    private let refreshControl = UIRefreshControl()
    private let emptyLabel = UILabel()
}

extension ExploreUserViewController: BlablaBlockPickerViewDelegate {
    func blablaBlockPickerView(_ view: BlablaBlockPickerView, selectedIndex: Int) {
        if let filter = ExploreUserFilter(index: selectedIndex) {
            viewModel.inputs.filter.accept(filter)
        }
    }
}
