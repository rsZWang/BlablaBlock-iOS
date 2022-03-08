//
//  Portfolio.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Foundation
import UIKit

public struct PortfolioApi: Decodable {

    let code: Int
    let data: PortfolioApiData
    
}

public struct PortfolioApiData: Decodable {
    
    let percentage: Double
    let totalValue: String
    let assets: [PortfolioApiDataAsset]
    
    static var defaultProfitString: NSAttributedString {
        let rate = "+0%"
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
                NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2352941176, green: 0.831372549, blue: 0.5568627451, alpha: 1),
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
    
    static var defaultAssetSumString: NSAttributedString {
        let attribuedString = NSMutableAttributedString()
        attribuedString.append(NSAttributedString(
            string: "$0",
            attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)
            ]
        ))
        attribuedString.append(NSAttributedString(
            string: " USDT",
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
            sign = ""
            color = #colorLiteral(red: 0.8666666667, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
        } else {
            sign = "+"
            color = #colorLiteral(red: 0.2352941176, green: 0.831372549, blue: 0.5568627451, alpha: 1)
        }
        let rate = "\(sign)\(percentage.toPrettyPrecisedString().appendTo2Precision())%"
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
    
    func getAssetSumString() -> NSAttributedString {
        let amount = "$\(totalValue.double.toPrettyPrecisedString())"
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
    
    func getAssetsViewData() -> [PortfolioAssetViewData] {
        var assetsViewData = [PortfolioAssetViewData]()
        var sortedAssets = assets
        sortedAssets.sort { $0.value.double > $1.value.double }
        for data in sortedAssets {
            let unrealizedProfit: String
            if let profit = data.unrealizedProfit {
                let doubleValue = profit.double
                let roundedValue = round(100 * doubleValue) / 100
                unrealizedProfit = roundedValue.toPrecisedString()
            } else {
                unrealizedProfit = "N/A"
            }
            assetsViewData.append(
                PortfolioAssetViewData(
                    exchange: ExchangeType.init(rawValue: data.exchange)!,
                    type: PortfolioType.init(rawValue: data.type)!,
                    currency: data.currency,
                    valueWeight: data.percentage.double.toPrettyPrecisedString().appendTo2Precision(),
                    balance: data.balance.double.toPrettyPrecisedString().appendTo2Precision(),
                    value: data.value.double.toPrettyPrecisedString().appendTo2Precision(),
                    unrealizedProfit: unrealizedProfit
                )
            )
        }
        return assetsViewData
    }
    
}

public struct PortfolioApiDataAsset: Decodable, Equatable {
    
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

public struct PortfolioViewData: Equatable {
    
    let profit: NSAttributedString
    let sum: NSAttributedString
    let assets: [PortfolioAssetViewData]
    
}

public struct PortfolioAssetViewData: Equatable {
    
    let exchange: ExchangeType
    let type: PortfolioType
    let currency: String
    let valueWeight: String
    let balance: String
    let value: String
    let unrealizedProfit: String
    
}

public enum PortfolioType: String, Equatable {
    
    case all = "all"
    case spot = "spot"              // 現貨
    case margin = "margin"          // 現貨槓桿
    case lending = "lending"        // 借貸
    case futures = "futures"        // 合約裡的現貨
    case positions = "positions"    // 合約的持倉
    case liquidity = "liquidity"
    
    static let titleList = ["所有類別", "現貨", "現貨槓桿", "借貸", "合約裡的現貨", "合約的持倉", "流動性資產"]
    static let typeList = ["all", "spot", "margin", "lending", "futures", "positions", "liquidity"]
    
    static func map(type: String) -> String {
        if let index = typeList.firstIndex(where: { $0 == type }) {
            return titleList[index]
        } else {
            return "Unknown type \(type)"
        }
    }
}
