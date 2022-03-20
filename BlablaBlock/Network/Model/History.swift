//
//  History.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import UIKit

public struct HistoryApi: Decodable {
    let code: Int
    let data: [HistoryApiData]
}

public struct HistoryApiData: Decodable {
    let exchange: String
    let currency: String
    let type: String
    let timestamp: TimeInterval
    let side: String
    let price: String
    let executedQty: String
    
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
