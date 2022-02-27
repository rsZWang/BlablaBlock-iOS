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
        
        // Statistics
        register { StatisticsViewModel() }.scope(.shared)
        
        // Exchange Setting
        register { ExchangeApiViewModel() }.scope(.shared)
        
        register { TradeHistoryViewModel() }.scope(.unique)
    }
    
}
