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
    
    struct Logout: BlablaBlockApiTargetType {
        var method: Method { .post }
        var path: String { "logout" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(userToken!)"] }
        var task: Task {
            .requestPlain
        }
        typealias ResponseType = ResponseSuccess
    }
    
    struct Registration: BlablaBlockApiTargetType {
        var method: Method { .post }
        var path: String { "registration" }
        var headers: [String : String]? { ["Authorization" : "Bearer wrkef63GXqLH9zMypXXK7Qtt"] }
        var task: Task {
            .requestParameters(parameters: [
                "name" : userName,
                "email" : email,
                "password" : password
            ], encoding: JSONEncoding.default)
        }
        typealias ResponseType = ResponseSuccess
        
        let userName: String
        let email: String
        let password: String
    }
    
    struct ForgetPassword: BlablaBlockApiTargetType {
        var method: Method { .post }
        var path: String { "forgotpassword" }
        var headers: [String : String]? { ["Authorization" : "Bearer wrkef63GXqLH9zMypXXK7Qtt"] }
        var task: Task {
            .requestParameters(parameters: [
                "email" : email
            ], encoding: JSONEncoding.default)
        }
        typealias ResponseType = ResponseSuccess
        
        let email: String
        
    }
    
    struct ResetPassword: BlablaBlockApiTargetType {
        var method: Method { .post }
        var path: String { "resetpassword" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(userToken!)"] }
        var task: Task {
            .requestParameters(parameters: [
                "password" : password
            ], encoding: JSONEncoding.default)
        }
        typealias ResponseType = ResponseSuccess
        
        let password: String
    }
}
