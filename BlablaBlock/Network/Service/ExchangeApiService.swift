//
//  ExchangeApiService.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/19.
//

import Moya

struct ExchangeApiService {
    
    struct getStatus: HttpTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "api_settings" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = ExchangeApi
        typealias FailureType = ResponseFailure
    }
    
    struct create: HttpTargetType {
        var method: Method { .post }
        var tokenType: TokenType { .user }
        var path: String { "api_settings" }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange,
                "api_key" : apiKey,
                "api_secret" : apiSecret
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = ExchangeApi
        typealias FailureType = ResponseFailure
        
        let exchange: String
        let apiKey: String
        let apiSecret: String
    }
    
    struct edit: HttpTargetType {
        var method: Method { .patch }
        var tokenType: TokenType { .user }
        var path: String { "api_settings/\(id)" }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange,
                "api_key" : apiKey,
                "api_secret" : apiSecret,
                "subaccount" : subAccount
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = ExchangeApi
        typealias FailureType = ResponseFailure
        
        let id: Int
        let exchange: String
        let apiKey: String
        let apiSecret: String
        let subAccount: String
    }
    
    struct delete: HttpTargetType {
        var method: Method { .delete }
        var tokenType: TokenType { .user }
        var path: String { "api_settings/\(id)" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = ExchangeApi
        typealias FailureType = ResponseFailure
        
        let id: Int
    }
    
    struct getCurrency: HttpTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .normal }
        var path: String { "currency" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = CurrencyIconApi
        typealias FailureType = ResponseFailure
    }
}
