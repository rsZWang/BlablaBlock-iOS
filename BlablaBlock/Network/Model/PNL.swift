//
//  PNL.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Foundation

struct PNL: Decodable {
    
    let code: Int
    let data: PNLData
    
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
            list.append(PNLCharData(value: data.value, timestamp: data.timestamp.int))
        }
        return list
    }
    
    func getMinX() -> Int {
        chartData.map { $0.timestamp.int }.min() ?? 0
    }
    
    func getMaxX() -> Int {
        chartData.map { $0.timestamp.int }.max() ?? 0
    }
    
//    func getXAxisPoint() -> [Int] {
//        let min = getMinX()
//        var max = getMaxX()
//        let totalPeriod = max - min
//        let period = totalPeriod / 4
//        if totalPeriod % 4 != 0 {
//            max += period
//        }
//        var list = [Int]()
//        Timber.i("period: \(period)")
//        for timestamp in stride(from: min, through: max, by: totalPeriod) {
//            Timber.i("timestamp: \(timestamp)")
//            list.append(timestamp)
//        }
//        return list
//    }
    
    func getMinY() -> Double {
        chartData.map { $0.value }.min() ?? 0
    }
    
    func getMaxY() -> Double {
        chartData.map { $0.value }.max() ?? 0
    }
    
    func getYAxisLabel() -> [Int] {
        chartData.map { Int($0.value) }
    }
    
}

struct PNLCharRawData: Decodable {
    
    let value: Double
    let timestamp: String
    
}


struct PNLCharData {
    
    let value: Double
    let timestamp: Int
    
}
