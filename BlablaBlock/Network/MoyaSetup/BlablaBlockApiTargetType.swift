//
//  BlablaBlockApi.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/11.
//

import Moya

protocol DecodableResponseTargetType: Moya.TargetType {
    associatedtype ResponseType: Decodable
}

protocol BlablaBlockApiTargetType: DecodableResponseTargetType { }

extension BlablaBlockApiTargetType {
    
    var apiVersion: String { "v1/" }
    var baseURL: URL { URL(string: "https://api.blablablock.com/\(apiVersion)")! }
    var headers: [String : String]? { nil }
    var sampleData: Data { Data() }
    
}
