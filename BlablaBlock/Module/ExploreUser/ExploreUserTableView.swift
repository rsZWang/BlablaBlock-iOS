//
//  ExploreUserTableView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/3.
//

import UIKit

final class ExploreUserTableView: UITableView {
       
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
        backgroundColor = nil
        contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        separatorStyle = .none
        register(ExploreUserTableViewCell.self, forCellReuseIdentifier: ExploreUserTableViewCell.identifier)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
}


extension ExploreUserTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExploreUserTableViewCell.identifier, for: indexPath)
        return cell
    }
}
