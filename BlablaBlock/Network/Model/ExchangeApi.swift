//
//  Exchange.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/26.
//

struct ExchangeApi: Decodable {
    let code: Int
    let data: [ExchangeApiData]
    
    func hasLinked() -> Bool {
        var hasLinked = false
        for exchange in data {
            if exchange.isLinked() {
                hasLinked = true
                break
            }
        }
        return hasLinked
    }
}

struct ExchangeApiData: Decodable {
    
    let id: Int
    let exchange: String
    let apiKey: String
    let apiSecret: String
    let subaccount: String?
    let userId: Int
    
    func isLinked() -> Bool {
        !apiKey.isEmpty && !apiSecret.isEmpty
    }
}
