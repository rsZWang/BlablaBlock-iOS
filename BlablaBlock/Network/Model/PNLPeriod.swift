//
//  PNLPeriod.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/27.
//

import Foundation

struct PNLPeriod {
    
    enum Period: String {
        case all = "all"
        case _1y = "1y"
        case _1m = "1m"
        case ytd = "ytd"
    }
    
    static let periodTitleList = ["全部", "1Y", "1M", "YTD"]
    static let periodList = ["all", "1y", "1m", "ytd"]
    
}
