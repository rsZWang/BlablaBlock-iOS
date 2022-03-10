//
//  KeychainAccess.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/31.
//

import KeychainAccess

enum KeychainKey: String {
    case userToken = "userToken"
    case userEmail = "userEmail"
    case userPassword = "userPassword"
    case userName = "userName"
    case userId = "userId"
}

let keychainUser = Keychain(server: HttpApiConfig.domain, protocolType: .https)

extension Keychain {
    
    subscript(key: KeychainKey) -> String? {
        get {
            self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue
        }
    }
    
}

