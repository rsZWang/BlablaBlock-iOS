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
    let entryPrice: String?
    let currentPrice: String?
    let unrealizedProfit: String?
    let value: String
    let type: String
    let currency: String
    let balance: String
    
}
