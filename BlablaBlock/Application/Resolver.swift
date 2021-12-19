//
//  Resolver.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/12.
//

import Resolver

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
        
        // Auth
        register { AuthService() }.scope(.shared)
        register { AuthViewModel() }.scope(.shared)
        
        // Statistics
        register { StatisticsService() }
        register { StatisticsViewModel() }
        
        // Exchange Setting
        register { ExchangeApiService() }
        register {  }
    }
    
}
