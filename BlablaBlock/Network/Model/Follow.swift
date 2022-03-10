//
//  Follow.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/28.
//

import Foundation

public struct FollowApi: Decodable {
    let code: Int
    let data: FollowApiData
}

public struct FollowApiData: Decodable {
    let followers: FollowApiDataFollow
    let followings: FollowApiDataFollow
}

public struct FollowApiDataFollow: Decodable {
    let count: Int
    let list: [FollowApiDataFollowUser]
}

public struct FollowApiDataFollowUser: Decodable {
    let userId: Int
    let name: String
    let isFollow: Bool
}
