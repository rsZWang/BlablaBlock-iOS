//
//  StatisticsService.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Moya

struct StatisticsService {
    
    struct getPortfolio: HttpResponseTargetType {
        
        var method: Method { .get }
        var path: String { "portfolio" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(keychainUser[.userToken]!)"] }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange
            ], encoding: URLEncoding.queryString)
        }
        typealias SuccessType = Portfolio
        typealias FailureType = ResponseFailure
        
        let exchange: String
    }
    
    struct getPNL: HttpResponseTargetType {
        
        var method: Method { .get }
        var path: String { "pnl" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(keychainUser[.userToken]!)"] }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange,
                "period" : period
            ], encoding: URLEncoding.queryString)
        }
        typealias SuccessType = PNL
        typealias FailureType = ResponseFailure
        
        let exchange: String
        let period: String
    }
}
