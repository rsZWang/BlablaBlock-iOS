//
//  FollowingPortfolioTableView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/24.
//

import UIKit

final class FollowingPortfolioTableView: UITableView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        separatorStyle = .none
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        rowHeight = 56
        allowsSelection = false
        register(FollowingPortfolioTableViewCell.self, forCellReuseIdentifier: FollowingPortfolioTableViewCell.identifier)
//        dataSource = self
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
}

//extension FollowingPortfolioTableView: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: FollowingPortfolioTableViewCell.identifier, for: indexPath) as! FollowingPortfolioTableViewCell
////        cell.bind(notification: notifications[indexPath.row], followBtnTap: followBtnTap)
//        return cell
//    }
//}
