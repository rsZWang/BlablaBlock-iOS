//
//  FollowListTableView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import UIKit

final class FollowListTableView: UITableView {
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
        backgroundColor = nil
        contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        separatorStyle = .none
        register(FollowListTableViewCell.self, forCellReuseIdentifier: FollowListTableViewCell.identifier)
        tableFooterView = UIView()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
}
