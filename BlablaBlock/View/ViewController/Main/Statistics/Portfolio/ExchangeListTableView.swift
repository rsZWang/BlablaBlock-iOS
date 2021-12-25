//
//  ExchangeListTableView.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/31.
//

import UIKit
import Differ

class ExchangeListTableView: UITableView {
    
    private var dataList = [PortfolioData]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        register(UINib(nibName: "ExchangeListTableViewCell", bundle: nil), forCellReuseIdentifier: "ExchangeListTableViewCell")
        dataSource = self
    }
    
    func bind(data: [PortfolioData]) {
        let oldData = [PortfolioData](self.dataList)
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
    
    func bind(_ portfolio: PortfolioData) {
        nameLabel.text = portfolio.exchange
        percentageLabel.text = "(?.?%)"
        amountLabel.text = "\(portfolio.balance)"
        valueLabel.text = "$\(portfolio.value)"
    }
     
}
