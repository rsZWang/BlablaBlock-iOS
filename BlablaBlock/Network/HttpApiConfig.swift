//
//  HttpApiConfig.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2022/1/1.
//

import Foundation

public struct HttpApiConfig {
    static let apiVersion = "v1"
    static let domain = "https://api.blablablock.com"
    static let baseURL = URL(string: "\(domain)/\(apiVersion)")
    static let normalToken = "wrkef63GXqLH9zMypXXK7Qtt"
}
