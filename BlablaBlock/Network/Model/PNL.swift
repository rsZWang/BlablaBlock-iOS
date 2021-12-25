//
//  PNL.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Foundation

struct PNL: Decodable {
    
    let code: Int
    let data: [PNLData]
    
}

struct PNLData: Decodable {
    
    let chartData: [PNLCharRawData]
    let roi: Double
    let roiAnnual: Double
    let mdd: Double
    let dailyWinRate: Double
    let sharpeRatio: Double
    
    func getChartDataList() -> [PNLCharData] {
        var list = [PNLCharData]()
        for data in chartData {
            list.append(PNLCharData(value: Double(data.value)!, timestamp: Int(data.timestamp)!))
        }
        return list
    }
    
    func getChartMaxY() -> Double {
        chartData.map { Double($0.value)! }.max()!
    }
    
    func getChartMinY() -> Double {
        chartData.map { Double($0.value)! }.min()!
    }
    
    func getYAxisLabel() -> [Int] {
        var list = chartData.map { Int(Double($0.value)!) }
//        list.insert(Int(getChartMinY() * 0.9), at: 0)
//        list.append(Int(getChartMaxY() * 0.9))
        return list
    }
    
}

struct PNLCharRawData: Decodable {
    
    let value: String
    let timestamp: String
    
}


struct PNLCharData {
    
    let value: Double
    let timestamp: Int
    
}
