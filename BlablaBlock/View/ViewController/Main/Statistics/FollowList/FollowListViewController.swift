//
//  FollowListViewController.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import UIKit
import Resolver

final class FollowListViewController: BaseViewController {
    
    let tableView = FollowListTableView()
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
