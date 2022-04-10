//
//  FollowingPortfolioAssetTableView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/10.
//

import UIKit
import Differ

final class FollowingPortfolioAssetTableView: UITableView {
    
    private var dataList = [PortfolioAssetViewData]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        register(UINib(nibName: "FollowingPortfolioAssetTableViewCell", bundle: nil), forCellReuseIdentifier: FollowingPortfolioAssetTableViewCell.identifier)
    }
    
    func bind(data: [PortfolioAssetViewData]) {
        let oldData = [PortfolioAssetViewData](self.dataList)
        self.dataList.removeAll()
        self.dataList.append(contentsOf: data)
        animateRowChanges(
            oldData: oldData,
            newData: self.dataList,
            deletionAnimation: .bottom,
            insertionAnimation: .top
        )
    }
}

final class FollowingPortfolioAssetTableViewCell: UITableViewCell {
    
    static let identifier = "FollowingPortfolioAssetTableViewCell"

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var dateChangeLabel: UILabel!
    
    func bind(_ portfolio: PortfolioAssetViewData) {
        iconImageView.currency(name: portfolio.currency)
        nameLabel.text = portfolio.currency
        percentageLabel.text = portfolio.percentage
        dateChangeLabel.text = portfolio.dayChange
        
        var dayChangeDouble = portfolio.dayChange
        dayChangeDouble.removeAll(where: { $0 == "％" })
        if Double(dayChangeDouble) ?? 0 < 0 {
            dateChangeLabel.textColor = #colorLiteral(red: 0.8666666667, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
        } else {
            dateChangeLabel.textColor = #colorLiteral(red: 0.2352941176, green: 0.831372549, blue: 0.5568627451, alpha: 1)
        }
    }
}
