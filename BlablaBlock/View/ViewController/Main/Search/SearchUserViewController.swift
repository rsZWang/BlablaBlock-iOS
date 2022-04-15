//
//  SearchUserViewController.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import UIKit
import SnapKit
import Resolver
import RxDataSources

final class SearchUserViewController: BaseViewController {
    
    @Injected var coordinator: MainCoordinator
    @Injected var viewModel: UserViewModelType
    
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
        pickerView.bind(textField: pickerViewTextField)
        pickerView.itemList = SearchUserFilter.titleList
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
            make.height.equalTo(70)
        }
        
        topSearchSectionView.addSubview(searchTitleLabel)
        searchTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        
        topSearchSectionView.addSubview(filterButton)
        filterButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchTitleLabel)
            make.trailing.equalToSuperview().offset(-26)
        }
        
        topSearchSectionView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalTo(searchTitleLabel)
            make.leading.equalTo(searchTitleLabel.snp.trailing).offset(40)
            make.trailing.equalTo(filterButton.snp.leading).offset(-26)
        }
        
        topSearchSectionView.addSubview(pickerViewTextField)
        pickerViewTextField.snp.makeConstraints { make in
            make.width.height.equalTo(0)
            make.leading.top.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
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
            .bind(to: viewModel.inputs.userName)
            .disposed(by: disposeBag)
        
        filterButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.pickerViewTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        collectionView.rx
            .itemSelected
            .bind(to: viewModel.inputs.selectedIndexPath)
            .disposed(by: disposeBag)
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.refresh)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .users
            .drive(
                collectionView.rx.items(
                    cellIdentifier: SearchUserCollectionViewCell.identifier,
                    cellType: SearchUserCollectionViewCell.self
                ),
                curriedArgument: { (row, element, cell) in
                    cell.bind(element)
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .isNotEmpty
            .distinctUntilChanged()
            .drive(emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .selectedUser
            .emit(onNext: coordinator.showPortfolioBy)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .finishLoading
            .emit(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }

    private let statusBarSection: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "bg_gray")
        return view
    }()
    
    private let topSearchSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "bg_gray")
        return view
    }()
    
    private let searchTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.text = "探索"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let searchTextField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.layer.cornerRadius = 4
        textField.font = .systemFont(ofSize: 14)
        textField.placeholder = "🔍  搜尋"
        textField.backgroundColor = .white
        return textField
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_search_user_filter"), for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private lazy var pickerView: PickerView = {
        let pickerView = PickerView()
        pickerView.pickerViewDelegate = self
        return pickerView
    }()
    
    private let pickerViewTextField: UITextField = UITextField()
    
    private lazy var collectionView: SearchUserCollectionView = {
        let collectionView = SearchUserCollectionView()
        collectionView.backgroundColor = #colorLiteral(red: 0.1803734004, green: 0.1804045737, blue: 0.1803635955, alpha: 1)
        collectionView.addSubview(refreshControl)
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = UIRefreshControl()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "請至設定頁面串接交易所API，\n以獲取追蹤他人投資組合"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 5
        label.isHidden = true
        return label
    }()
}

extension SearchUserViewController: PickerViewDelegate {
    public func onSelected(index: Int, item: String) {
        viewModel.inputs
            .filter
            .accept(SearchUserFilter.filter(index))
    }
}
