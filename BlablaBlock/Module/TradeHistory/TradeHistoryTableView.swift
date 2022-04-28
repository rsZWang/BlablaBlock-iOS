//
//  TradeHistoryTableView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import UIKit

final class TradeHistoryTableView: UITableView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
        contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        separatorStyle = .none
        allowsSelection = false
        backgroundColor = .grayEDEDED
        register(TradeHistoryTableViewCell.self, forCellReuseIdentifier: TradeHistoryTableViewCell.identifier)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
}
