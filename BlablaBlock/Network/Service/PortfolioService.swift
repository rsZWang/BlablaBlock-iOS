//
//  PortfolioService.swift
//  BlablaBlock
//
//  Created by Harry on 2022/8/6.
//

import Moya

struct PortfolioService {
    
    struct getPortfolio: HttpTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "getPortfolio/\(filterExchange)/\(filterType)" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = PortfolioApi
        typealias FailureType = ResponseFailure
        
        let filterExchange: FilterExchange
        let filterType: FilterType
    }
    
    struct getPNL: HttpTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "getPnlPercent/\(userId)" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = PNLApi
        typealias FailureType = ResponseFailure
        
        let userId: Int
    }
}
