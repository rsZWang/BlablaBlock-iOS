//
//  BlablaBlockApi.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/11.
//

import Moya
import RxSwift

protocol DecodableResponseTargetType: Moya.TargetType {
    associatedtype ResponseType: Decodable
}

protocol BlablaBlockApiTargetType: DecodableResponseTargetType {

}

extension BlablaBlockApiTargetType {
    
    var apiVersion: String { "/v1" }
    var baseURL: URL { URL(string: "https://api.blablablock.com\(apiVersion)")! }
    var headers: [String : String]? { nil }
    var sampleData: Data { Data() }
    
    func request() -> Single<ResponseType> {
        ApiProvider.request(self)
    }
    
}

fileprivate final class ApiProvider {
    
    //  // Singleton API
    //  public static let shared = API()
    //  // 隱藏 init，不能讓別人在外面 init API 這個 class
    //  private init() { }
    private static let provider = MoyaProvider<MultiTarget>(plugins: [MoyaLoggerPlugin()])
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    // 每當我傳入一個 request 時，我都會檢查他的 response 可不可以被 decode，
    // conform DecodableResponseTargetType 的意義在此，
    // 因為我們已經先定好 ResponseType 是什麼了，
    // 儘管 request 不知道確定是什麼型態，但一定可以被 JSONDecoder 解析。
    static func request<Request: DecodableResponseTargetType>(_ request: Request) -> Single<Request.ResponseType> {
        return provider.rx.request(MultiTarget.init(request))
            .filterSuccessfulStatusCodes()
            .map(Request.ResponseType.self, using: decoder) // 在此會解析 Response，具體怎麼解析，交由 data model 的 decodable 去處理。
    }
}
