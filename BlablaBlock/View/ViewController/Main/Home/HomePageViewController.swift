//
//  HomePageViewController.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/28.
//

import UIKit
import Resolver

final class HomePageViewController: BaseViewController {
    
    @Injected var homeViewModel: HomeViewModel
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.inputs.viewWillAppear.accept(())
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
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        homeViewModel.outputs
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
    
}
