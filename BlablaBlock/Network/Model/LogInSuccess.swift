//
//  LogIn.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/25.
//

struct LogIn: Decodable {
    
    let code: Int
    let data: LogInData
    
}

struct LogInData: Decodable {
    
    let apiToken: String
    let userId: Int
    let email: String
    
}

