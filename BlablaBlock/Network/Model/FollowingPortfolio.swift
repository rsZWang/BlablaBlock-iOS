//
//  FollowingPortfolio.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/21.
//

public struct FollowingPortfolioApi: Decodable {

    let code: Int
    let data: [PortfolioApiDataAsset]
    
    func getAssetsViewData() -> [PortfolioAssetViewData] {
        var assetsViewData = [PortfolioAssetViewData]()
        var sortedAssets = data
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
