//
//  FollowListTableView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import UIKit

protocol FollowListTableViewDelegate {
    func onCellClicked(index: Int)
    func onFollowClicked(index: Int)
}

final class FollowListTableView: UITableView {
    
    var followListTableViewDelegate: FollowListTableViewDelegate?
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
        backgroundColor = nil
        contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        separatorStyle = .none
        allowsSelection = false
        register(FollowListTableViewCell.self, forCellReuseIdentifier: FollowListTableViewCell.reuseIdentifier)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
}

//extension FollowListTableView: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        6
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return tableView.dequeueReusableCell(withIdentifier: FollowListTableViewCell.reuseIdentifier, for: indexPath)
//    }
//}
