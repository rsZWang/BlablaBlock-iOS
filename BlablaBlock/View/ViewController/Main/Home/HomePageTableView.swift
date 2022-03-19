//
//  HomePageTableView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/28.
//

import UIKit

final class HomePageTableView: UITableView {
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
        register(HomePageTableViewCell.self, forCellReuseIdentifier: HomePageTableViewCell.reuseIdentifier)
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        backgroundColor = nil
        allowsSelection = false
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
}
