//
//  FollowingPortfolio.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/21.
//

import RxDataSources

public struct FollowingPortfolioApi: Decodable {

    let code: Int
    let assets: [PortfolioApiDataAsset]
    
    func getAssetsViewData() -> [PortfolioAssetViewData] {
        var assetsViewData = [PortfolioAssetViewData]()
        var sortedAssets = assets
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
