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
    case sharp = "sharp"
    
    static let titleList = [
        "vc_explore_filter_sort_random".localized(),
        "vc_explore_filter_sort_total_asset".localized(),
        "vc_explore_filter_sort_roa".localized(),
        "vc_explore_filter_sort_win_rate".localized(),
        "vc_explore_filter_sort_sharpe_ratio".localized()
    ]
    static let typeList = ["random", "asset", "profit", "winRate", "sharp"]
    
    var title: String {
        if let typeIndex = Self.typeList.firstIndex(where: { $0 == self.rawValue }) {
            return Self.titleList[typeIndex]
        } else {
            return "Unknows"
        }
    }
    
    init?(index: Int) {
        self.init(rawValue: Self.typeList[index])
    }
    
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
