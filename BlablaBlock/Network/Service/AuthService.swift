//
//  AuthService.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/11.
//

import Moya

struct AuthService {
    
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
        
        let email: String
        let password: String
    }
    
    struct Registration: BlablaBlockApiTargetType {
        
        var method: Method { .post }
        var path: String { "registration" }
        var headers: [String : String]? { ["Authorization" : "Bearer wrkef63GXqLH9zMypXXK7Qtt"] }
        var task: Task {
            .requestParameters(parameters: [
                "email" : email,
                "password" : password
            ], encoding: JSONEncoding.default)
        }
        typealias ResponseType = ResponseSuccess
        
        let email: String
        let password: String
    }
    
}
