//
//  ExchangeApiService.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/19.
//

import Moya

struct ExchangeApiService {
    
    struct getAllApis: HttpResponseTargetType {
        
        var method: Method { .get }
        var path: String { "api_settings" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(userToken!)"] }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailureModel
    }
    
    struct createApi: HttpResponseTargetType {
        
        var method: Method { .post }
        var path: String { "api_settings/new" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(userToken!)"] }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange,
                "api_key" : apiKey,
                "api_secret" : apiSecret,
                "subaccount" : subAccount
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailureModel
        
        let exchange: String
        let apiKey: String
        let apiSecret: String
        let subAccount: String
    }
    
    struct editApi: HttpResponseTargetType {
        
        var method: Method { .patch }
        var path: String { "api_settings/\(id)" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(userToken!)"] }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange,
                "api_key" : apiKey,
                "api_secret" : apiSecret,
                "subaccount" : subAccount
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailureModel
        
        let id: String
        let exchange: String
        let apiKey: String
        let apiSecret: String
        let subAccount: String
    }
    
    struct deleteApi: HttpResponseTargetType {
        
        var method: Method { .delete }
        var path: String { "api_settings/\(id)" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(userToken!)"] }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailureModel
        
        let id: String
    }
    
}
