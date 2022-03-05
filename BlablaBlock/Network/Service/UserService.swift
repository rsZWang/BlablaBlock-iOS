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
    
}
