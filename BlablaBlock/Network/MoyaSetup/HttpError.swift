//
//  HttpError.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/1.
//

import Foundation

final public class HttpError: Error {
    let code: Int
    let message: String
    let body: Data
    
    init(code: Int, message: String, body: Data) {
        self.code = code
        self.message = message
        self.body = body
    }
}
