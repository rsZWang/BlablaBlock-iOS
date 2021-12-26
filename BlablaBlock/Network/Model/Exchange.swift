//
//  Exchange.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/26.
//

struct Exchange: Decodable {
    let code: Int
    let data: [ExchangeData]
}

struct ExchangeData: Decodable {
    let id: Int
    let exchange: String
    let apiKey: String
    let apiSecret: String
    let subaccount: String?
    let userId: Int
    let createdAt: String
    let updatedAt: String
}
