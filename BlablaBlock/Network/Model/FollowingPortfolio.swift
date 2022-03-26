//
//  FollowingPortfolio.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/21.
//

import RxDataSources

public struct FollowingPortfolioApi: Decodable {

    let code: Int
    let assets: [FollowingPortfolioApiAsset]
    
    func getAssetsViewData() -> [FollowingPortfolioAssetViewData] {
        var assetsViewData = [FollowingPortfolioAssetViewData]()
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
                FollowingPortfolioAssetViewData(
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

public struct FollowingPortfolioApiAsset: Decodable, Equatable {

    let currency: String
    let balance: Double
    let value: Double
    let dayChange: Double
    let percentage: Double
}

public struct FollowingPortfolioAssetViewData: IdentifiableType, Equatable {
    
    public var identity: String { balance }
    
    let currency: String
    let balance: String
    let value: String
    let dayChange: String
    let percentage: String
}
