//
//  Registration.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/27.
//

public struct RegistrationApi: Decodable {
    
    let code: Int
    let data: RegistrationApiData
    
}

public struct RegistrationApiData: Decodable {
    
    let apiToken: String
    let id: Int
    let email: String
    let name: String
    
}
