//
//  ExchangeListTableView.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/31.
//

import UIKit
import Differ

class ExchangeListTableView: UITableView {
    
    private var dataList = [PortfolioViewData]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        register(UINib(nibName: "ExchangeListTableViewCell", bundle: nil), forCellReuseIdentifier: "ExchangeListTableViewCell")
        dataSource = self
    }
    
    func bind(data: [PortfolioViewData]) {
        let oldData = [PortfolioViewData](self.dataList)
        self.dataList.removeAll()
        self.dataList.append(contentsOf: data)
        animateRowChanges(oldData: oldData, newData: self.dataList)
    }

}

extension ExchangeListTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeListTableViewCell", for: indexPath) as! ExchangeListTableViewCell
        cell.bind(dataList[indexPath.row])
        return cell
    }
    
}

class ExchangeListTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    func bind(_ portfolio: PortfolioViewData) {
        nameLabel.text = portfolio.currency
        percentageLabel.text = "(\(portfolio.valueWeight)%)"
        amountLabel.text = portfolio.balance
        valueLabel.text = "$\(portfolio.value)"
        rateLabel.text = "\(portfolio.unrealizedProfit)%"
        if let profit = Double(portfolio.unrealizedProfit) {
            if profit < 0 {
                rateLabel.textColor = #colorLiteral(red: 0.8666666667, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
            } else {
                rateLabel.textColor = #colorLiteral(red: 0.2352941176, green: 0.831372549, blue: 0.5568627451, alpha: 1)
            }
        } else {
            rateLabel.text?.removeLast()
            rateLabel.textColor = .black
        }
    }
     
}
