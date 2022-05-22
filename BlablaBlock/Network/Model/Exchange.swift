//
//  Exchange.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/26.
//

public struct ExchangeApi: Decodable {
    let code: Int
    let data: [ExchangeApiData]
    
    func hasLinked() -> Bool {
        var hasLinked = false
        for exchange in data {
            if exchange.isLinked() {
                hasLinked = true
                break
            }
        }
        return hasLinked
    }
}

public struct ExchangeApiData: Decodable {
    
    let id: Int
    let exchange: String
    let apiKey: String
    let apiSecret: String
    let subaccount: String?
    let userId: Int
    
    func isLinked() -> Bool {
        !apiKey.isEmpty && !apiSecret.isEmpty
    }
}

public enum ExchangeType: String, Equatable {
    
    case all = "all"
    case binance = "binance"
    case ftx = "ftx"
    
    static let titleList = [
        "vc_portfolio_filter_all_exchange".localized(),
        "exchange_type_binance".localized(),
        "exchange_type_ftx".localized()
    ]
    static let typeList = ["all", "binance", "ftx"]
    
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
    
    init?(name: String) {
        if let typeIndex = Self.typeList.firstIndex(where: { $0 == name }) {
            self.init(rawValue: Self.typeList[typeIndex])
        } else {
            return nil
        }
    }
    
    static func map(type: String) -> String? {
        if let index = typeList.firstIndex(where: { $0 == type }) {
            return titleList[index]
        } else {
            return nil
        }
    }
}
