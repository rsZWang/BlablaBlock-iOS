//
//  ExchangeApiService.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/19.
//

import Moya
import Defaults

struct ExchangeApiService {
    
    struct getLinked: HttpResponseTargetType {
        
        var method: Method { .get }
        var path: String { "api_settings" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(Defaults[.userToken]!)"] }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = Exchange
        typealias FailureType = ResponseFailure
    }
    
    struct create: HttpResponseTargetType {
        
        var method: Method { .post }
        var path: String { "api_settings" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(Defaults[.userToken]!)"] }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange,
                "api_key" : apiKey,
                "api_secret" : apiSecret
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailure
        
        let exchange: String
        let apiKey: String
        let apiSecret: String
    }
    
    struct edit: HttpResponseTargetType {
        
        var method: Method { .patch }
        var path: String { "api_settings/\(id)" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(Defaults[.userToken]!)"] }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange,
                "api_key" : apiKey,
                "api_secret" : apiSecret,
                "subaccount" : subAccount
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailure
        
        let id: String
        let exchange: String
        let apiKey: String
        let apiSecret: String
        let subAccount: String
    }
    
    struct delete: HttpResponseTargetType {
        
        var method: Method { .delete }
        var path: String { "api_settings/\(id)" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(Defaults[.userToken]!)"] }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailure
        
        let id: String
    }
    
}
