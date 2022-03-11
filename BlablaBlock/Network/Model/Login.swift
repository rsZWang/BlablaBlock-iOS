//
//  LogIn.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/25.
//

public struct LoginApi: Decodable {
    
    let code: Int
    let data: LoginApiData
    
}

public struct LoginApiData: Decodable {
    
    let apiToken: String
    let userId: Int
    let email: String
    let name: String?
    
}

