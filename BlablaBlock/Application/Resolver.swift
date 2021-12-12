//
//  Resolver.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/12.
//

import Resolver

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
        register { AuthViewModel() }.scope(.shared)
        register { AuthService() }.scope(.shared)
    }
    
}
