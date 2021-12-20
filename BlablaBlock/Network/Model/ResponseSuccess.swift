//
//  Login.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/11.
//

import Foundation

struct ResponseSuccess: Decodable {
    
    let code: Int                  // HTTP status
    let data: ResponseSuccessData?  // User data
    
}

struct ResponseSuccessData: Decodable {
    
    let apiToken: String
    let userId: Int
    let email: String
    
}
