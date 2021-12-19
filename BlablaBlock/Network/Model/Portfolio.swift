//
//  Portfolio.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Foundation

struct Portfolio: Decodable {

    let code: Int
    let data: [PortfolioData]
    
}

struct PortfolioData: Decodable, Equatable {
    
    let exchange: String
    let currency: String
    let type: String
    let balance: Double
    let value: Double
    
//    "exchange": "binance",
//    "currency": "USDT",
//    "type": "spot",
//    "balance": 27.3094816,
//    "value": 27.3094816,
    
}
