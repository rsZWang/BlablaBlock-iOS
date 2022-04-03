//
//  Resolver.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/12.
//

import Resolver

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
        
        register { NewMainCoordinator() }.scope(.application)
//        register { MainCoordinator() }.scope(.application)
        
        // Launcher
        register { LauncherViewModel() as LauncherViewModelType }.scope(.unique)
        
        // Auth
        register { AuthViewModel() }.scope(.shared)
        
//        // Home
//        register { HomeViewModel() as HomeViewModelType }.scope(.unique)
//
//        // Search
//        register { UserViewModel() as ExploreViewModelType }.scope(.unique)
//
//        // Portfolio
//        register { PortfolioViewModel() as PortfolioViewModelType }.scope(.unique)
//
//        // Follow
//        register { FollowViewModel() as FollowViewModelType }.scope(.unique)
//
//        // TradeHistory
//        register { TradeHistoryViewModel() }.scope(.unique)
//
//        // Exchange Setting
//        register { ExchangeApiViewModel() }.scope(.shared)
    }
    
}
