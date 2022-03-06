//
//  Resolver.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/12.
//

import Resolver

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
        
        register { MainCoordinator() }.scope(.application)
        
        // Auth
        register { AuthViewModel() }.scope(.shared)
        
        // Home
        register { HomeViewModel() }.scope(.unique)
        
        // Search user
        register { UserViewModel() as UserViewModelType }.scope(.unique)
        
        // Follow
        register { FollowViewModel() as FollowViewModelType }.scope(.unique)
        
        // Statistics
        register { StatisticsViewModel() }.scope(.shared)
        
        // Exchange Setting
        register { ExchangeApiViewModel() }.scope(.shared)
        
        // TradeHistory
        register { TradeHistoryViewModel() }.scope(.unique)
    }
    
}
