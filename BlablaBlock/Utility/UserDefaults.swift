//
//  UserDefaults.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/26.
//

import Defaults

extension Defaults.Keys {
    
    static let userToken = Key<String?>("token", default: nil)
    static let userName = Key<String?>("userName", default: nil)
    
}
