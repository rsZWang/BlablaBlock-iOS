//
//  AuthService.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/11.
//

import Moya

public typealias Method = Moya.Method

struct AuthService {
    
    struct login: HttpResponseTargetType {
        var method: Method { .post }
        var tokenType: TokenType { .normal }
        var path: String { "login" }
        var task: Task {
            .requestParameters(parameters: [
                "email" : email,
                "password" : password
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = LoginApi
        typealias FailureType = ResponseFailure
        
        let email: String
        let password: String
    }
    
    struct register: HttpResponseTargetType {
        var method: Method { .post }
        var tokenType: TokenType { .normal }
        var path: String { "registration" }
        var task: Task {
            .requestParameters(parameters: [
                "name" : userName,
                "email" : email,
                "password" : password
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = RegistrationApi
        typealias FailureType = ResponseFailure
        
        let userName: String
        let email: String
        let password: String
    }
    
    struct forgetPassword: HttpResponseTargetType {
        var method: Method { .post }
        var tokenType: TokenType { .normal }
        var path: String { "forgotpassword" }
        var task: Task {
            .requestParameters(parameters: [
                "email" : email
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailure
        
        let email: String
    }
    
    struct resetPassword: HttpResponseTargetType {
        var method: Method { .post }
        var tokenType: TokenType { .user }
        var path: String { "resetpassword" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(token)"] }
        var task: Task {
            .requestParameters(parameters: [
                "password" : password
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailure
        
        let token: String
        let password: String
    }
    
    struct logout: HttpResponseTargetType {
        var method: Method { .post }
        var tokenType: TokenType { .user }
        var path: String { "logout" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailure
    }
}
