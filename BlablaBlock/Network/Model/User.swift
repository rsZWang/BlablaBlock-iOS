//
//  User.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import RxDataSources

public struct UserApi: Decodable {
    let code: Int
    let data: [UserApiData]
}

public struct UserApiData: Decodable, IdentifiableType, Equatable, Hashable {
    
    public var identity: UserApiData {
        return self
    }
    
    let userId: Int
    let name: String?
    let totalValue: Double
    let roi: Double?
    let roiAnnual: Double?
    let mdd: Double?
    let dailyWinRate: Double?
    let sharpeRatio: Double?
    var isFollow: Bool
}
