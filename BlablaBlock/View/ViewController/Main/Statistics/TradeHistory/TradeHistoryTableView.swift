//
//  TradeHistoryTableView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import Foundation
import UIKit

final class TradeHistoryTableView: UITableView {
    
    static let reuseIdentifer = "TradeHistoryTableViewCell"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = nil
        contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        register(TradeHistoryTableViewCell.self, forCellReuseIdentifier: TradeHistoryTableView.reuseIdentifer)
        separatorStyle = .none
    }
}
