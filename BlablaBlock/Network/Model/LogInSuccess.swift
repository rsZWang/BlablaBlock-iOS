//
//  LogInSuccess.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/25.
//

struct LogInSuccess: Decodable {
    
    let code: Int
    let data: LogInSuccessData
    
}

struct LogInSuccessData: Decodable {
    
    let apiToken: String
    let userId: Int
    let email: String
    
}

