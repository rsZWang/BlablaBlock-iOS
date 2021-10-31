//
//  ExchangeListTableView.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/31.
//

import UIKit

class ExchangeListTableView: UITableView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        dataSource = self
    }

}

extension ExchangeListTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeListCell", for: indexPath)
        Timber.i("CELLLLLL")
        return cell
    }
    
}
