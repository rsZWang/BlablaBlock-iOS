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
    
    func getXAxis() -> [Int] {
        let minX = getMinX()
        let maxX = getMaxX()
        let diff = maxX - minX
        let distance = Int(Double(diff)/5)
        
        var values = [Int]()
        for i in stride(from: minX, through: maxX, by: distance) {
            values.append(i)
        }
        if values.count == 5 {
            values.append(maxX + distance)
        }
        return values
    }
    
    func getMinY() -> Double {
        chartData.map { $0.value }.min() ?? 0
    }
    
    func getMaxY() -> Double {
        chartData.map { $0.value }.max() ?? 0
    }
    
    func getYAxis() -> [Double] {
        
        func roundUp(_ value: Double) -> Double {
            if value < 0 {
                return -ceil(-value)
            } else {
                return ceil(value)
            }
        }
        
        let minY = roundUp(getMinY())
        let maxY = roundUp(getMaxY())
        let diff = minY - maxY
        let distance = abs(diff/10)
        
        var values = [Double]()
        for i in stride(from: minY, through: maxY, by: distance) {
            values.append(i)
        }
        if values.count == 10 {
            values.append(maxY + distance)
        }
        return values.map { round($0*100)/100 }
//        return values.map { value in
//            if value < 0 {
//                return -(ceil(abs(value)))
//            } else {
//                return ceil(value)
//            }
//        }
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
