//
//  FollowerApi.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/28.
//

import Foundation

public struct FollowerApi: Decodable {
    let code: Int
    let data: FollowerApiData
}

public struct FollowerApiData: Decodable {
    let followers: [FollowerApiDataUser]
    let followings: [FollowerApiDataUser]
}

public struct FollowerApiDataUser: Decodable {
    let userId: String
    let name: String
    let isFollow: Bool
}
