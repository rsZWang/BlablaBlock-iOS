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
    let status: String
    let data: PortfolioApiData
}

public struct PortfolioApiData: Decodable {
    
    let percentage: Double?
    let totalValue: Double?
    let asset: [PortfolioApiDataAsset]
    
    static var defaultAssetProfitString: NSAttributedString {
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
    
    func getAssetSumString() -> NSAttributedString {
        let amount = "$\(totalValue?.toPrettyPrecisedString() ?? "0")"
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
        var sortedAssets = asset
        sortedAssets.sort { $0.value > $1.value }
        for data in sortedAssets {
            var dayChange: String? = data.dayChange.toPrettyPrecisedString()
            if let change = dayChange, !change.isEmpty {
                dayChange = "\(change)％"
            } else {
                dayChange = "N/A"
            }
            assetsViewData.append(
                PortfolioAssetViewData(
                    currency: data.currency,
                    percentage: "(\(data.percentage.toPrettyPrecisedString())%)",
                    balance: data.balance.toPrettyPrecisedString(),
                    value: "$\(data.value.toPrettyPrecisedString())",
                    dayChange: dayChange!
                )
            )
        }
        return assetsViewData
    }
}

public struct PortfolioApiDataAsset: Decodable, Equatable {
    let value: Double
    let percentage: Double
    let dayChange: Double
    let currency: String
    let balance: Double
}

public struct PortfolioViewData: Equatable {
    let profit: NSAttributedString
    let sum: NSAttributedString
    let assets: [PortfolioAssetViewData]
}

public struct PortfolioAssetViewData: IdentifiableType, Equatable {
    
    public var identity: String { currency }
    
    let currency: String
    let percentage: String
    let balance: String
    let value: String
    let dayChange: String
}

//public enum PortfolioType: String, Equatable {
//    
//    case all = "all"
//    case spot = "spot"              // 現貨
//    case margin = "margin"          // 現貨槓桿
//    case futures = "futures"        // 合約裡的現貨
//    case positions = "positions"    // 合約的持倉
//    case management = "management"  // 理財
////    case lending = "lending"        // 借貸
////    case liquidity = "liquidity"    // 流動性資產
//    
//    static var titleList: [String] {
//        [
//            "所有類別",
//            "portfolio_type_spot".localized(),
//            "portfolio_type_margin".localized(),
//            "portfolio_type_futures".localized(),
//            "portfolio_type_positions".localized(),
//            "portfolio_type_earn".localized()
//        ]
//    }
//    static let typeList = [
//        "all",
//        "spot",
//        "margin",
//        "futures",
//        "positions",
//        "management"
//    ]
//    
//    init?(title: String) {
//        if let typeIndex = Self.titleList.firstIndex(where: { $0 == title }) {
//            self.init(rawValue: Self.typeList[typeIndex])
//        } else {
//            return nil
//        }
//    }
//    
//    init?(index: Int) {
//        self.init(rawValue: Self.typeList[index])
//    }
//    
//    static func map(type: String) -> String {
//        switch type {
//        case "lending", "liquidity":
//            return "portfolio_type_earn".localized()
//        default:
//            if let index = typeList.firstIndex(where: { $0 == type }) {
//                return titleList[index]
//            } else {
//                return type
//            }
//        }
//    }
//}
//
//public enum AssetType: String, Equatable {
//    
//    case all = "all"
//    case spot = "spot"              // 現貨
//    case margin = "margin"          // 現貨槓桿
//    case futures = "futures"        // 合約裡的現貨
//    case positions = "positions"    // 合約的持倉
//    case management = "management"  // 理財
////    case lending = "lending"        // 借貸
////    case liquidity = "liquidity"    // 流動性資產
//    
//    static var titleList: [String] {
//        [
//            "所有類別",
//            "asset_type_spot".localized(),
//            "asset_type_margin".localized(),
//            "asset_type_futures".localized(),
//            "asset_type_positions".localized(),
//            "asset_type_earn".localized()
//        ]
//    }
//    static let typeList = [
//        "all",
//        "spot",
//        "margin",
//        "futures",
//        "positions",
//        "management"
//    ]
//    
//    init?(title: String) {
//        if let typeIndex = Self.titleList.firstIndex(where: { $0 == title }) {
//            self.init(rawValue: Self.typeList[typeIndex])
//        } else {
//            return nil
//        }
//    }
//    
//    static func map(type: String) -> String {
//        switch type {
//        case "lending", "liquidity":
//            return "asset_type_earn".localized()
//        default:
//            if let index = typeList.firstIndex(where: { $0 == type }) {
//                return titleList[index]
//            } else {
//                return type
//            }
//        }
//    }
//}

public enum FilterExchange: String {
    
    case all = "all"
    case Binance = "Binance"
    case FTX = "FTX"
    
    static var titleList = [
        "vc_portfolio_filter_all_exchange".localized(),
        "exchange_type_binance".localized(),
        "exchange_type_ftx".localized()
    ]
    
    static let typeList = [
        "all",
        "Binance",
        "FTX"
    ]
    
    var title: String {
        if let typeIndex = Self.typeList.firstIndex(where: { $0 == self.rawValue }) {
            return Self.titleList[typeIndex]
        } else {
            return "Unknows"
        }
    }
    
    init?(title: String) {
        if let typeIndex = Self.titleList.firstIndex(where: { $0 == title }) {
            self.init(rawValue: Self.typeList[typeIndex])
        } else {
            return nil
        }
    }
    
    init?(index: Int) {
        self.init(rawValue: Self.typeList[index])
    }
}

public enum FilterType: String {
    
    case all = "all"
    case spot = "spot"
    case futures = "futures"
    case others = "others"
    
    static let titleList = [
        "所有類別",
        "asset_type_spot".localized(),
        "asset_type_futures".localized(),
        "asset_type_positions".localized(),
        "asset_type_other".localized()
    ]
    
    static let typeList = [
        "all",
        "spot",
        "futures",
        "others",
        "management"
    ]
    
    init?(title: String) {
        if let typeIndex = Self.titleList.firstIndex(where: { $0 == title }) {
            self.init(rawValue: Self.typeList[typeIndex])
        } else {
            return nil
        }
    }
    
    init?(index: Int) {
        self.init(rawValue: Self.typeList[index])
    }
    
    static func map(type: String) -> String {
        if let index = typeList.firstIndex(where: { $0 == type }) {
            return titleList[index]
        } else {
            return type
        }
    }
}
