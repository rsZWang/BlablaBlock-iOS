//
//  FollowService.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/28.
//

import Moya

struct FollowService {
    
    struct getFollower: HttpResponseTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "follower" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = FollowerApi
        typealias FailureType = ResponseFailure
    }
    
    struct follow: HttpResponseTargetType {
        var method: Method { .post }
        var tokenType: TokenType { .user }
        var path: String { "follow" }
        var task: Task {
            .requestParameters(parameters: [
                "user_id" : userId
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailure
        
        let userId: String
    }
    
    struct unfollow: HttpResponseTargetType {
        var method: Method { .post }
        var tokenType: TokenType { .user }
        var path: String { "unfollow" }
        var task: Task {
            .requestParameters(parameters: [
                "user_id" : userId
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = ResponseSuccess
        typealias FailureType = ResponseFailure
        
        let userId: String
    }
    
    struct getNotifications: HttpResponseTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "notifications" }
        var task: Task {
            .requestPlain
        }
        typealias SuccessType = NotificationApi
        typealias FailureType = ResponseFailure
    }
    
    struct getFollowPortfolio: HttpResponseTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "follow_portfolio" }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = FollowPortfolioApi
        typealias FailureType = ResponseFailure
        
        let exchange: String
    }
    
    struct getFollowPortfolioByID: HttpResponseTargetType {
        var method: Method { .get }
        var tokenType: TokenType { .user }
        var path: String { "follow_portfolio/\(userId)" }
        var task: Task {
            .requestParameters(parameters: [
                "exchange" : exchange
            ], encoding: JSONEncoding.default)
        }
        typealias SuccessType = FollowPortfolioApi
        typealias FailureType = ResponseFailure
        
        let userId: String
        let exchange: String
    }
}
