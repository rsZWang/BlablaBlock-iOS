//
//  Exchange.ExchangeType.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/27.
//

import Foundation

struct Exchange {
    
    enum ExchangeType: String {
        case Binance = "binance"
        case FTX = "ftx"
    }
    
    static let exchangeTitleList = ["所有交易所", "Binance", "FTX"]
    static let exchangeTypeList = ["all", "binance", "ftx"]
    
    
    
}


