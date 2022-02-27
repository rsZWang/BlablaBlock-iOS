//
//  ResponseFailure.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/19.
//

import Foundation

public struct ResponseFailure: Decodable {
    
    let code: Int
    let msg: String
    
}
