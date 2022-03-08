//
//  User.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

public struct UserApi: Decodable {
    let code: Int
    let data: [UserApiData]
}

public struct UserApiData: Decodable {
    let userId: Int
    let name: String?
    let roi: Double?
    let roiAnnual: Double?
    let mdd: Double?
    let dailyWinRate: Double?
    let sharpeRatio: Double?
}
