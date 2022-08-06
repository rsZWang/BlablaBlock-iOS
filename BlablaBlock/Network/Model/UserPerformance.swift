//
//  UserPerformance.swift
//  BlablaBlock
//
//  Created by Harry on 2022/8/6.
//

import RxDataSources

public struct UserPerformanceApi: Decodable {
    let status: String
    let data: [UserPerformanceApiData]
}

public struct UserPerformanceApiData: Decodable, IdentifiableType, Equatable, Hashable {
    
    public var identity: UserPerformanceApiData { self }
    
    let userId: Int
    let userName: String
    let totalValue: Double
    let roi: Double
    let roiAnnual: Double
    let mdd: Double
    let sharpeRatio: Double
    var isFollowing: Bool
    var isFollowedByUser: Bool
    let annountFollowers: Int
    let annountFollowings: Int
}

public enum UserPerformanceSort: String {
    
    case totalValue = "totalValue"
    case roi = "roi"
    case mdd = "mdd"
    case sharpeRatio = "sharpeRatio"
    case annountFollowers = "annountFollowers"
}
