//
//  Portfolio.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Foundation
import UIKit

struct Portfolio: Decodable {

    let code: Int
    let data: PortfolioData
    
    func getAssetSum() -> Double {
        let sum = data.assets.map { $0.value.double }.reduce(0, +)
        return sum
    }
    
    func getViewData() -> [PortfolioViewData] {
        var viewDataList = [PortfolioViewData]()
        var sortedAssets = data.assets
        sortedAssets.sort { $0.balance.double > $1.balance.double }
        for data in sortedAssets {
            let unrealizedProfit: String
            if let profit = data.unrealizedProfit {
                let doubleValue = profit.double
                let roundedValue = round(100 * doubleValue) / 100
                unrealizedProfit = roundedValue.toPrecisedString()
            } else {
                unrealizedProfit = "NA"
            }
            viewDataList.append(
                PortfolioViewData(
                    currency: data.currency,
                    valueWeight: data.percentage.toPrettyPrecisedString(),
                    balance: data.balance.toPrettyPrecisedString(),
                    value: data.value.toPrettyPrecisedString(),
                    unrealizedProfit: unrealizedProfit
                )
            )
        }
        return viewDataList
    }
    
}

struct PortfolioData: Decodable {
    
    let totalValue: String
    let percentage: Double
    let assets: [PortfolioAsset]
    
    func getTotalValueString() -> NSAttributedString {
        let amount = "$\(totalValue.toPrettyPrecisedString())"
        let unit = " USDT"
        let attribuedString = NSMutableAttributedString()
        attribuedString.append(NSAttributedString(
            string: amount,
            attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)
            ]
        ))
        attribuedString.append(NSAttributedString(
            string: unit,
            attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)
            ]
        ))
        return attribuedString
    }
    
    func getProfitString() -> NSAttributedString {
        let sign: String
        let color: UIColor
        if percentage < 0 {
            sign = "-"
            color = #colorLiteral(red: 0.8666666667, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
        } else {
            sign = "+"
            color = #colorLiteral(red: 0.2352941176, green: 0.831372549, blue: 0.5568627451, alpha: 1)
        }
        let rate = "\(sign)\(percentage.toPrettyPrecisedString())%"
        let attribuedString = NSMutableAttributedString()
        attribuedString.append(NSAttributedString(
            string: "總資產(",
            attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)
            ]
        ))
        attribuedString.append(NSAttributedString(
            string: rate,
            attributes: [
                NSAttributedString.Key.foregroundColor : color,
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)
            ]
        ))
        attribuedString.append(NSAttributedString(
            string: ")",
            attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)
            ]
        ))
        return attribuedString
    }
    
}

struct PortfolioAsset: Decodable, Equatable {
    
    let entryPrice: String?
    let currentPrice: String?
    let unrealizedProfit: String?
    let exchange: String
    let currency: String
    let value: String
    let type: String
    let balance: String
    let percentage: String
    
}

struct PortfolioViewData: Decodable, Equatable {
    
    let currency: String
    let valueWeight: String
    let balance: String
    let value: String
    let unrealizedProfit: String
    
}
