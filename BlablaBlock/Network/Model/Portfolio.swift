//
//  Portfolio.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Foundation
import UIKit
import RxDataSources

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
        sortedAssets.sort { $0.value > $1.value }
        for data in sortedAssets {
//            let unrealizedProfit: String
//            if let profit = data.unrealizedProfit {
//                let doubleValue = profit.double
//                let roundedValue = round(100 * doubleValue) / 100
//                unrealizedProfit = roundedValue.toPrecisedString()
//            } else {
//                unrealizedProfit = "N/A"
//            }
//            let exchange = ExchangeType.init(rawValue: data.exchange)!
//            let type = PortfolioType.init(rawValue: data.type) ?? .management
//            assetsViewData.append(
//                PortfolioAssetViewData(
//                    identity: "\(exchange.rawValue)_\(type.rawValue)",
//                    exchange: exchange,
//                    type: type,
//                    currency: data.currency,
//                    valueWeight: data.percentage.double.toPrettyPrecisedString().appendTo2Precision(),
//                    balance: data.balance.double.toPrettyPrecisedString().appendTo2Precision(),
//                    value: data.value.double.toPrettyPrecisedString().appendTo2Precision(),
//                    unrealizedProfit: unrealizedProfit
//                )
//            )
            var dayChange: String? = Double(data.dayChange)?.toPrettyPrecisedString()
            if let change = dayChange, !change.isEmpty {
                dayChange = "\(change)％"
            } else {
                dayChange = "N/A"
            }
            
            assetsViewData.append(
                PortfolioAssetViewData(
                    identity: "\(data.currency)_\(data.balance)",
                    currency: data.currency,
                    balance: data.balance.toPrettyPrecisedString(),
                    value: "$\(data.value.toPrettyPrecisedString())",
                    dayChange: dayChange!,
                    percentage: "(\(data.percentage.toPrettyPrecisedString())%)"
                )
            )
        }
        return assetsViewData
    }
}

public struct PortfolioApiDataAsset: Decodable, Equatable {

    let currency: String
    let balance: Double
    let value: Double
    let dayChange: String
    let percentage: Double
}

public struct PortfolioViewData: Equatable {
    
    let profit: NSAttributedString
    let sum: NSAttributedString
    let assets: [PortfolioAssetViewData]
}

public struct PortfolioAssetViewData: Equatable, IdentifiableType {
    
    public typealias Identity = String
    public var identity: String
    
    let currency: String
    let balance: String
    let value: String
    let dayChange: String
    let percentage: String
}

public enum PortfolioType: String, Equatable {
    
    case all = "all"
    case spot = "spot"              // 現貨
    case margin = "margin"          // 現貨槓桿
    case futures = "futures"        // 合約裡的現貨
    case positions = "positions"    // 合約的持倉
    case management = "management"  // 理財
    
    static let titleList = ["所有類別", "現貨", "現貨槓桿", "合約裡的現貨", "合約的持倉", "理財"]
    static let typeList = ["all", "spot", "margin", "futures", "positions", "management"]
    
    static func map(type: String) -> String {
        switch type {
        case "lending", "liquidity":
            return "理財"
        default:
            if let index = typeList.firstIndex(where: { $0 == type }) {
                return titleList[index]
            } else {
                return "Unknown type (\(type))"
            }
        }
    }
}

public enum AssetType: String, Equatable {
    
    case all = "all"
    case spot = "spot"              // 現貨
    case margin = "margin"          // 現貨槓桿
    case lending = "lending"        // 借貸
    case futures = "futures"        // 合約裡的現貨
    case positions = "positions"    // 合約的持倉
    case liquidity = "liquidity"    // 流動性資產
    
    static let titleList = ["所有類別", "現貨", "現貨槓桿", "借貸", "合約裡的現貨", "合約的持倉", "流動性資產"]
    static let typeList = ["all", "spot", "margin", "lending", "futures", "positions", "liquidity"]
    
    static func map(type: String) -> String {
        if let index = typeList.firstIndex(where: { $0 == type }) {
            return titleList[index]
        } else {
            return "Unknown type (\(type))"
        }
    }
}
