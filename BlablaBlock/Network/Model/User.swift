//
//  User.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import RxDataSources

public struct UserApi: Decodable {
    let status: String
    let data: UserApiData
}

public struct UserApiData: Decodable, IdentifiableType, Equatable, Hashable {
    
    public var identity: UserApiData { self }
    
    let userId: Int
    let userName: String
    let email: String
    let address: String?
}
