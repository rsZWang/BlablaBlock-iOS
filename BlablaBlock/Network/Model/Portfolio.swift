//
//  Portfolio.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Foundation

struct Portfolio: Decodable {

    let code: Int
    let data: PortfolioData
    
    func getAssetSum() -> Double {
        let sum = data.assets.map { Double($0.value)! }.reduce(0, +)
        return sum
    }
    
    func getAssetSumString() -> String {
        "\(getAssetSum().toPrecisionString(percision: 4))"
    }
    
    func getViewData() -> [PortfolioViewData] {
        let valueSum = getAssetSum()
        var viewDataList = [PortfolioViewData]()
        for data in data.assets {
            let valueWeight = (Double(data.value)!/valueSum).toPrecisionString()
            let unrealizedProfit: String
            if let profit = data.unrealizedProfit {
                let doubleValue = Double(profit)!
                let roundedValue = round(100 * doubleValue) / 100
                unrealizedProfit = roundedValue.toPrecisionString()
            } else {
                unrealizedProfit = "NA"
            }
            viewDataList.append(
                PortfolioViewData(
                    currency: data.currency,
                    valueWeight: valueWeight,
                    balance: Double(data.balance)!.toPrecisionString(),
                    value: Double(data.value)!.toPrecisionString(),
                    unrealizedProfit: unrealizedProfit
                )
            )
        }
        return viewDataList
    }
    
}

struct PortfolioData: Decodable {
    
    let totalValue: String
    let assets: [PortfolioAsset]
    
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
    
}

struct PortfolioViewData: Decodable, Equatable {
    
    let currency: String
    let valueWeight: String
    let balance: String
    let value: String
    let unrealizedProfit: String
    
}
