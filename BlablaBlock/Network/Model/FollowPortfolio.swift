//
//  FollowPortfolioApi.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/1.
//

public struct FollowPortfolioApi: Decodable {
    let code: Int
    let data: [FollowPortfolioApiData]
}

public struct FollowPortfolioApiData: Decodable {
    let totalValue: String
    let percentage: Double
    let assets: [FollowPortfolioApiDataAsset]
}

public struct FollowPortfolioApiDataAsset: Decodable {
    let exchange: String
    let currency: String
    let type: String
    let balance: String
    let value: String
    let percentage: String
    let entryPrice: String?
    let currentPrice: String?
    let unrealizedProfit: String?
}
