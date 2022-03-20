//
//  HomePageViewController.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/28.
//

import UIKit
import Resolver

final class HomePageViewController: BaseViewController {
    
    private let viewModel: HomeViewModelType
    
    init(viewModel: HomeViewModelType) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.viewWillAppear.accept(())
    }
    
    private func setupUI() {
        view.backgroundColor = .grayE5E5E5
        logoImageView.image = "ic_home_page_logo".image()
        tableView.separatorStyle = .none
    }
    
    private func setupLayout() {
        view.addSubview(statusBarSection)
        view.addSubview(topSectionView)
        topSectionView.addSubview(logoImageView)
        view.addSubview(tableView)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        statusBarSection.snp.makeConstraints { make in
            make.height.equalTo(statusBarHeight)
            make.leading.top.trailing.equalToSuperview()
        }
        
        topSectionView.snp.makeConstraints { make in
            make.top.equalTo(statusBarSection.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.equalToSuperview().offset(24)
            make.top.bottom.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(topSectionView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        viewModel.outputs
            .notifications
            .drive(
                tableView.rx.items(
                    cellIdentifier: HomePageTableViewCell.reuseIdentifier,
                    cellType: HomePageTableViewCell.self
                ),
                curriedArgument: { (row, element, cell) in
                    cell.bind(notification: element)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private let statusBarSection = UIView()
    private let topSectionView = UIView()
    private let logoImageView = UIImageView()
    private let tableView = HomePageTableView()
    
}
