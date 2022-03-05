//
//  Registration.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/27.
//

public struct RegistrationModel: Decodable {
    
    let code: Int
    let data: RegistrationModelData
    
}

public struct RegistrationModelData: Decodable {
    
    let apiToken: String
    let id: Int
    let email: String
    let name: String
    
}
