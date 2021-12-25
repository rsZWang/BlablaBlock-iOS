//
//  LogInSuccessModel.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/25.
//

struct LogInSuccessModel: Decodable {
    
    let code: Int
    let data: LogInSuccessDataModel
    
}

struct LogInSuccessDataModel: Decodable {
    
    let apiToken: String
    let userId: Int
    let email: String
    
}

