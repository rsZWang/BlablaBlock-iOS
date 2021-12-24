//
//  PNL.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Foundation

struct PNL: Decodable {
    
    let code: String
    
}

struct PNLData: Decodable {
    
    let code: Int
    let chartData: [PNLCharData]
    let roi: Double
    let roiAnnual: Double
    let mod: Double
    let dailyWinRate: Double
    let sharpeRatio: Double
    
//    "chart_data": [
//        {
//            "value": 100,
//            "timestamp": 1637901093,
//        },
//        {
//            "value": 120,
//            "timestamp": 1637902093,
//        },
//    ],
//    "roi": 0.4820,
//    "roi_annual": 0.4741,
//    "mdd": 0.1287,
//    "daily_win_rate": 0.6125,
//    "sharpe_ratio": 2.09,
    
}

struct PNLCharData: Decodable {
    
    let value: Int
    let timestamp: Int
    
}
