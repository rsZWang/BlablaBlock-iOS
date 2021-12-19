//
//  ResponseError.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/19.
//

import Foundation

struct ResponseError: Decodable {
    
    let code: Int
    let msg: String
    
}
