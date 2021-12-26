//
//  AuthService.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/11.
//

import Moya
import Defaults

typealias Method = Moya.Method

struct AuthService {
    
    struct Login: HttpResponseTargetType {
        var method: Method { .post }
        var path: String { "login" }
        var headers: [String : String]? { ["Authorization" : "Bearer wrkef63GXqLH9zMypXXK7Qtt"] }
        var task: Task {
            .requestParameters(parameters: [
                "email" : email,
                "password" : password
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = LogIn
        typealias FailureType = ResponseFailure
        
        let email: String
        let password: String
    }
    
    struct Registration: HttpResponseTargetType {
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
        typealias SuccessType = RegistrationModel
        typealias FailureType = ResponseFailure
        
        let userName: String
        let email: String
        let password: String
    }
    
    struct ForgetPassword: HttpResponseTargetType {
        var method: Method { .post }
        var path: String { "forgotpassword" }
        var headers: [String : String]? { ["Authorization" : "Bearer wrkef63GXqLH9zMypXXK7Qtt"] }
        var task: Task {
            .requestParameters(parameters: [
                "email" : email
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = LogIn
        typealias FailureType = ResponseFailure
        
        let email: String
    }
    
    struct ResetPassword: HttpResponseTargetType {
        var method: Method { .post }
        var path: String { "resetpassword" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(Defaults[.userToken]!)"] }
        var task: Task {
            .requestParameters(parameters: [
                "password" : password
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailure
        
        let password: String
    }
    
    struct Logout: HttpResponseTargetType {
        var method: Method { .post }
        var path: String { "logout" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(Defaults[.userToken]!)"] }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailure
    }
}
