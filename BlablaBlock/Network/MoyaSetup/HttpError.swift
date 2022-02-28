//
//  HttpError.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/1.
//

import Foundation

final class HttpError: Error {
    let code: Int
    let body: Data
    
    init(code: Int, body: Data) {
        self.code = code
        self.body = body
    }
}
