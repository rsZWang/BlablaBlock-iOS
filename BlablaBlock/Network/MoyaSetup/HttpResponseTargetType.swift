//
//  HttpResponseTargetType.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/11.
//

import Moya
import RxSwift

enum HttpResponse<Body: Decodable, FailureBody: Decodable> {
    case Success(Body)
    case Failure(FailureBody)
}

protocol HttpResponseTargetType: Moya.TargetType {
    associatedtype SuccessType: Decodable
    associatedtype FailureType: Decodable
}

extension HttpResponseTargetType {
    
    var apiVersion: String { "/v1" }
    var baseURL: URL { URL(string: "https://api.blablablock.com\(apiVersion)")! }
    var headers: [String : String]? { nil }
    var sampleData: Data { Data() }
    
    func request() -> Single<HttpResponse<SuccessType, FailureType>> {
        ApiProvider.request(self)
    }
    
}

fileprivate final class ApiProvider {
    
    #if DEBUG
    private static let provider = MoyaProvider<MultiTarget>(plugins: [MoyaLoggerPlugin()])
    #else
    private static let provider = MoyaProvider<MultiTarget>()
    #endif
    
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    static func request<Request: HttpResponseTargetType, SuccessType, FailureType>(_ request: Request) -> Single<HttpResponse<SuccessType, FailureType>> {
        Single<HttpResponse<SuccessType, FailureType>>.create { single in
            provider.request(MultiTarget.init(request)) { result in
                switch result {
                case let .success(moyaResponse):
                    do {
                        let body = try decoder.decode(SuccessType.self, from: moyaResponse.data)
                        single(.success(.Success(body)))
                    } catch {
                        let errorBody = try? decoder.decode(FailureType.self, from: moyaResponse.data)
                        if let errorBody = errorBody {
                            single(.success(.Failure(errorBody)))
                        } else {
                            single(.failure(error))
                        }
                    }
                case let .failure(moyaError):
                    single(.failure(moyaError))
                }
            }
            return Disposables.create {  }
        }
    }
}

//protocol DecodableResponseTargetType: Moya.TargetType {
//    associatedtype ResponseType: Decodable
//}
//
//protocol BlablaBlockApiTargetType: DecodableResponseTargetType {
//
//}
//
//extension BlablaBlockApiTargetType {
//
//    var apiVersion: String { "/v1" }
//    var baseURL: URL { URL(string: "https://api.blablablock.com\(apiVersion)")! }
//    var headers: [String : String]? { nil }
//    var sampleData: Data { Data() }
//
//    func request() -> Single<ResponseType> {
//        ApiProvider.request(self)
//    }
//
//}

//    static func request<Request: DecodableResponseTargetType>(_ request: Request) -> Single<Request.ResponseType> {
//        provider.rx.request(MultiTarget.init(request))
//            .filterSuccessfulStatusCodes()
//            .map(Request.ResponseType.self, using: decoder) // 在此會解析 Response，具體怎麼解析，交由 data model 的 decodable 去處理。
//    }
