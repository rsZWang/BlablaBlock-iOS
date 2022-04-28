//
//  ExploreUserFilter.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/15.
//

import Foundation

public enum ExploreUserFilter: String {
    
    case random = "random"
    case asset = "asset"
    case profit = "profit"
    case winRate = "winRate"
    case sharp = "sharp"
    
    static let titleList = ["隨機", "總資產", "總報酬", "勝率", "夏普值"]
    static let typeList = ["random", "asset", "profit", "winRate", "sharp"]
    
    static func map(type: String) -> String {
        if let index = typeList.firstIndex(where: { $0 == type }) {
            return titleList[index]
        } else {
            return "Unknown type (\(type))"
        }
    }
    
    static func filter(_ index: Int) -> ExploreUserFilter {
        return ExploreUserFilter(rawValue: ExploreUserFilter.typeList[index])!
    }
}
