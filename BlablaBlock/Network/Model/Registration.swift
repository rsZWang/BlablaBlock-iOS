//
//  Registration.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/27.
//

public struct RegistrationApi: Decodable {
    let status: String
    let data: RegistrationApiData
}

public struct RegistrationApiData: Decodable {
    let token: String
    let user: String
}
