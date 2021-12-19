//
//  StatisticsService.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Moya

struct StatisticsService {
    
    struct getPortfolio: BlablaBlockApiTargetType {
        
        var method: Method { .get }
        var path: String { "portfolio" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(userToken!)"] }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange
            ], encoding: URLEncoding.queryString)
        }
        typealias ResponseType = Portfolio
        
        let exchange: String
    }
    
    struct getPNL: BlablaBlockApiTargetType {
        
        var method: Method { .get }
        var path: String { "pnl" }
        var headers: [String : String]? { ["Authorization" : "Bearer \(userToken!)"] }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange,
                "period" : period
            ], encoding: URLEncoding.queryString)
        }
        typealias ResponseType = PNL
        
        let exchange: String
        let period: String
    }
    
    
}
