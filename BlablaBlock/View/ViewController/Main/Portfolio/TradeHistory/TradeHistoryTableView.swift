//
//  TradeHistoryTableView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import Foundation
import UIKit

final class TradeHistoryTableView: UITableView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
        backgroundColor = nil
        contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        separatorStyle = .none
        register(TradeHistoryTableViewCell.self, forCellReuseIdentifier: TradeHistoryTableViewCell.identifier)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
}