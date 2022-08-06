//
//  AuthService.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/11.
//

import Moya

public typealias Method = Moya.Method

public struct AuthService {
    
    struct login: HttpTargetType {
        var method: Method { .post }
        var tokenType: TokenType { .normal }
        var path: String { "login" }
        var task: Task {
            .requestParameters(parameters: [
                "email" : email,
                "password" : password
            ], encoding: URLEncoding.default)
        }
        typealias SuccessType = LoginApi
        typealias FailureType = ResponseFailure
        
        let email: String
        let password: String
    }
    
    struct signup: HttpTargetType {
        var method: Method { .post }
        var tokenType: TokenType { .normal }
        var path: String { "signup" }
        var task: Task {
            .requestParameters(parameters: [
                "email" : email,
                "password" : password,
                "passwordConfirm" : password,
                "userName" : userName,
            ], encoding: URLEncoding.default)
        }
        typealias SuccessType = RegistrationApi
        typealias FailureType = ResponseFailure
        
        let userName: String
        let email: String
        let password: String
    }
    
    struct forgetPassword: HttpTargetType {
        var method: Method { .post }
        var tokenType: TokenType { .normal }
        var path: String { "forgotpassword" }
        var task: Task {
            .requestParameters(parameters: [
                "email" : email
            ], encoding: URLEncoding.default)
        }
        var log: Bool { false }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailure
        
        let email: String
    }
    
    struct resetPassword: HttpTargetType {
        var method: Method { .post }
        var tokenType: TokenType { .custom(token) }
        var path: String { "resetpassword" }
        var task: Task {
            .requestParameters(parameters: [
                "password" : password
            ], encoding: URLEncoding.default)
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailure
        
        let token: String
        let password: String
    }
    
    struct logout: HttpTargetType {
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
