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
        typealias SuccessType = FollowApi
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
        
        let userId: Int
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
        
        let userId: Int
    }
}
