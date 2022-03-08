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
        var tokenType: TokenType { .user }
        var path: String { "portfolio" }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange
            ], encoding: URLEncoding.queryString)
        }
        typealias SuccessType = PortfolioApi
        typealias FailureType = ResponseFailure
        
        let exchange: String
    }
    
    struct getPNL: HttpResponseTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "pnl" }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange,
                "period" : period
            ], encoding: URLEncoding.queryString)
        }
        typealias SuccessType = PNLApi
        typealias FailureType = ResponseFailure
        
        let exchange: String
        let period: String
    }
    
    struct getTradeHistory: HttpResponseTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "trade_history" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = HistoryApi
        typealias FailureType = ResponseFailure
    }
}
