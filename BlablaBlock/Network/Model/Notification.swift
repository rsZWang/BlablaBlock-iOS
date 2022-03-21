//
//  Notification.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/1.
//

import UIKit

public struct NotificationApi: Decodable {
    let code: Int
    let data: [NotificationApiData]
}

public struct NotificationApiData: Decodable {
    let userId: Int
    let name: String
    let exchange: String
    let currency: String
    let type: String
    let timestamp: TimeInterval
    let side: String
    let price: Double
    let executedQty: Double
    let isFollow: Bool
    
    func getCurrencyString() -> NSAttributedString {
        let attribuedString = NSMutableAttributedString()
        attribuedString.append(NSAttributedString(
            string: currency,
            attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
            ]
        ))
        attribuedString.append(NSAttributedString(
            string: "（\(PortfolioType.map(type: type))）",
            attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)
            ]
        ))
        return attribuedString
    }
}
