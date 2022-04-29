//
//  HomePageTableView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/28.
//

import UIKit
import RxCocoa
import Differ

final class HomePageTableView: UITableView {
    
    private var notifications: [NotificationApiData] = []
    weak var viewModel: HomePageViewModelType!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
        register(HomePageTableViewCell.self, forCellReuseIdentifier: HomePageTableViewCell.identifier)
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        backgroundColor = nil
        separatorStyle = .none
        allowsSelection = false
//        dataSource = self
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    func refresh(notifications: [NotificationApiData]) {
        let oldNotifications = self.notifications
        self.notifications = notifications
        self.animateRowChanges(oldData: oldNotifications, newData: notifications, isEqual: { $0 == $1 })
    }
}

extension HomePageTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomePageTableViewCell.identifier, for: indexPath) as! HomePageTableViewCell
        cell.viewModel = viewModel
        cell.bind(notification: notifications[indexPath.row])
        return cell
    }
}
