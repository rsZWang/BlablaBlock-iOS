//
//  LogIn.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/25.
//

public struct Login: Decodable {
    
    let code: Int
    let data: LoginData
    
}

public struct LoginData: Decodable {
    
    let apiToken: String
    let userId: Int
    let email: String
    let name: String?
    
}

