//
//  CurrencyIcon.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/1.
//

public struct CurrencyIconApi: Decodable {
    let code: Int
    let data: [CurrencyIconApiData]
}

public struct CurrencyIconApiData: Decodable {
    let currency: String
    let image: String
}
