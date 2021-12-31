//
//  HttpResponseTargetType.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/11.
//

import Moya
import RxSwift
import Defaults
import KeychainAccess

enum HttpResponse<Body: Decodable, FailureBody: Decodable> {
    case Success(Body)
    case Failure(FailureBody)
}

protocol HttpResponseTargetType: Moya.TargetType {
    associatedtype SuccessType: Decodable
    associatedtype FailureType: Decodable
}

struct ApiConfig {
    
    static let apiVersion = "v1"
    static let domain = "https://api.blablablock.com"
    static let baseURL = URL(string: "\(domain)/\(apiVersion)")
    
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
    
    let requestQueue: DispatchQueue = DispatchQueue(label: "com.wuchi.request_queue")
//    requestQueue.suspend() // 暫停 thread
//    requestQueue.resume()
    
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    static func request<Request: HttpResponseTargetType, SuccessType, FailureType>(_ request: Request) -> Single<HttpResponse<SuccessType, FailureType>> {
        Single<HttpResponse<SuccessType, FailureType>>.create { single in
            let disposeBag = DisposeBag()
            provider.request(MultiTarget.init(request)) { result in
                switch result {
                case let .success(moyaResponse):
                    if moyaResponse.response?.statusCode == 401 {
                        refreshToken(disposeBag: disposeBag) { error in
                            Timber.i("singled")
                            if let error = error {
                                single(.failure(error))
                            } else {
                                single(.failure(NSError()))
                            }
                            
                        }
                    } else {
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
                    }
                case let .failure(moyaError):
                    single(.failure(moyaError))
                }
            }
            return Disposables.create()
        }
        .retry(3)
    }
    
    private static func refreshToken(disposeBag: DisposeBag, _ onComplete: @escaping (Error?) -> Void) {
        if let email = keychainUser[.userEmail] {
            if let password = keychainUser[.userPassword] {
                AuthService.login(email: email, password: password)
                    .request()
                    .subscribe(
                        onSuccess: { response in
                            Timber.i("onSuccess")
                            switch response {
                            case let .Success(login):
                                Defaults[.userToken] = login.data.apiToken
                                onComplete(nil)
                            case let .Failure(responseFailure):
                                onComplete(NSError(domain: "\(responseFailure)", code: 20003, userInfo: nil))
                            }
                        },
                        onFailure: { error in
                            onComplete(error)
                        },
                        onDisposed: {
                            onComplete(nil)
                            Timber.i("onDIsposed onDIsposed onDIsposed")
                        }
                    )
                    .disposed(by: disposeBag)
            } else {
                onComplete(NSError(domain: "lack of password", code: 20001, userInfo: nil))
            }
        } else {
            onComplete(NSError(domain: "lack of email", code: 20002, userInfo: nil))
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
