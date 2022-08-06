//
//  UserService.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import Moya

struct UserService {
    
    struct getUser: HttpTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "getUser" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = UserApi
        typealias FailureType = ResponseFailure
    }
    
    struct getNotifications: HttpTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "notifications" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = NotificationApi
        typealias FailureType = ResponseFailure
    }
    
    struct getUsers: HttpTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "users" }
        var task: Task {
            .requestParameters(parameters: [
                "name" : name
            ], encoding: URLEncoding.queryString)
        }
        typealias SuccessType = UserApi
        typealias FailureType = ResponseFailure
        
        let name: String
    }
    
    struct getPortfolioByID: HttpTargetType {
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
        
        let userId: Int
        let exchange: String
    }
    
    struct getPNLByID: HttpTargetType {
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
        
        let userId: Int
        let exchange: String
        let period: String
    }
    
    struct getTradeHistoryByID: HttpTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "trade_history/\(userId)" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = HistoryApi
        typealias FailureType = ResponseFailure
        
        let userId: Int
    }
    
    struct getFollowPortfolioByID: HttpTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "follow_portfolio/\(userId)" }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange
            ], encoding: URLEncoding.queryString)
        }
        typealias SuccessType = FollowingPortfolioApi
        typealias FailureType = ResponseFailure
        
        let userId: Int
        let exchange: String
    }
    
    struct getFollowerByID: HttpTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "follower/\(userId)" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = FollowApi
        typealias FailureType = ResponseFailure
        
        let userId: Int
    }
    
    struct getUserPerformance: HttpTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "getPerformance/\(userId)/\(sort)" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = UserPerformanceApi
        typealias FailureType = ResponseFailure
        
        let userId: Int
        let sort: UserPerformanceSort
    }
}
