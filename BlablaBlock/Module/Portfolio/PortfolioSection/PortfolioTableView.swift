//
//  PortfolioTableView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/24.
//

import UIKit

final class PortfolioTableView: UITableView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        separatorStyle = .none
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        register(PortfolioTableViewCell.self, forCellReuseIdentifier: PortfolioTableViewCell.identifier)
        
//        backgroundColor = nil
//        allowsSelection = false
        dataSource = self
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
//    func refresh(notifications: [NotificationApiData]) {
//        let oldNotifications = self.notifications
//        self.notifications = notifications
//        self.animateRowChanges(oldData: oldNotifications, newData: notifications)
//        DispatchQueue.main.asyncAfter(deadline: .now()+2) { [weak self] in
//            self?.reloadVisibleCells()
//        }
//    }
//
//    func update(notifications: [NotificationApiData]) {
//        self.notifications = notifications
//        self.reloadVisibleCells()
//    }
}

extension PortfolioTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PortfolioTableViewCell.identifier, for: indexPath) as! PortfolioTableViewCell
//        cell.bind(notification: notifications[indexPath.row], followBtnTap: followBtnTap)
        return cell
    }
}
