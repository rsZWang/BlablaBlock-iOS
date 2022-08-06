//
//  LogIn.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/25.
//

public struct LoginApi: Decodable {
    let status: String
    let data: LoginApiData
}

public struct LoginApiData: Decodable {
    let token: String
    let user: String
}

