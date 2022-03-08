//
//  UserService.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import Moya

struct UserService {
    
    struct getUsers: HttpResponseTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "users" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = UserApi
        typealias FailureType = ResponseFailure
        
        let name: String
    }
    
    struct getPortfolioByID: HttpResponseTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "portfolio/\(userId)" }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange
            ], encoding: URLEncoding.queryString)
        }
        typealias SuccessType = PortfolioApi
        typealias FailureType = ResponseFailure
        
        let userId: String
        let exchange: String
    }
    
    struct getPNLByID: HttpResponseTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "pnl/\(userId)" }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange,
                "period" : period
            ], encoding: URLEncoding.queryString)
        }
        typealias SuccessType = PNLApi
        typealias FailureType = ResponseFailure
        
        let userId: String
        let exchange: String
        let period: String
    }
    
}
