//
//  AuthService.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/11.
//

import Moya

enum AuthService {
    
    struct Login: BlablaBlockApiTargetType {
        
        var method: Method { .post }
        var path: String { "login" }
        var headers: [String : String]? { ["Authorization" : "Bearer wrkef63GXqLH9zMypXXK7Qtt"] }
        var task: Task {
            .requestParameters(parameters: [
                "email" : email,
                "password" : password
            ], encoding: JSONEncoding.default)
        }
        typealias ResponseType = ResponseSuccess
        
        let token: String = "wrkef63GXqLH9zMypXXK7Qtg"
        let email: String
        let password: String
        
    }
    
}
