//
//  HttpResponseTargetType.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/11.
//

import Moya
import RxSwift
import KeychainAccess

enum HttpApiError: Error {
    case toeknExpired
    case timeout
}

enum HttpResponse<Body: Decodable, FailureBody: Decodable> {
    case Success(Body)
    case Failure(FailureBody)
}

protocol HttpResponseTargetType: Moya.TargetType {
    associatedtype SuccessType: Decodable
    associatedtype FailureType: Decodable
}

extension HttpResponseTargetType {
    
    var baseURL: URL { URL(string: "\(HttpApiConfig.domain)/\(HttpApiConfig.apiVersion)")! }
    var headers: [String : String]? { nil }
    var sampleData: Data { Data() }
    
    func request(onQueue: DispatchQueue = ApiProvider.requestQueue) -> Single<HttpResponse<SuccessType, FailureType>> {
        ApiProvider.request(self, onQueue: onQueue)
            .retry(2)
    }
    
}

fileprivate final class ApiProvider {
    
    #if DEBUG
    private static let provider = MoyaProvider<MultiTarget>(plugins: [MoyaLoggerPlugin()])
    #else
    private static let provider = MoyaProvider<MultiTarget>()
    #endif
    
    static let requestQueue = DispatchQueue(
        label: "com.wuchi.request_queue",
        qos: .background,
        attributes: .concurrent
    )
    private static let refreshTokenQueue = DispatchQueue(
        label: "com.wuchi.refresh_token_queue",
        qos: .background
    )
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private static var disposeBag: DisposeBag! = DisposeBag()

    static func request<Request: HttpResponseTargetType, SuccessType, FailureType>(
        _ request: Request,
        onQueue: DispatchQueue
    ) -> Single<HttpResponse<SuccessType, FailureType>> {
        Single<HttpResponse<SuccessType, FailureType>>.create { single in
            provider.request(MultiTarget.init(request), callbackQueue: onQueue, completion: { result in
                switch result {
                case let .success(moyaResponse):
                    if moyaResponse.response?.statusCode == 401 {
                        requestQueue.suspend()
                        single(.failure(HttpApiError.toeknExpired))
                        refreshToken { error in
                            requestQueue.resume()
                            if let error = error {
                                single(.failure(error))
                            } else {
                                provider.request(
                                    MultiTarget.init(request),
                                    callbackQueue: onQueue,
                                    completion: { _ in }
                                )
//                                single(.failure(NSError(domain: "Testing", code: -1, userInfo: nil)))
                            }
                            disposeBag = nil
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
            })
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: onQueue))
    }
}

fileprivate extension ApiProvider {
    
    private static func refreshToken(_ onComplete: @escaping (Error?) -> Void) {
        if let email = keychainUser[.userEmail] {
            if let password = keychainUser[.userPassword] {
                disposeBag = DisposeBag()
                AuthService.login(email: email, password: password)
                    .request(onQueue: refreshTokenQueue)
                    .subscribe(
                        onSuccess: { response in
                            switch response {
                            case let .Success(login):
                                keychainUser[.userToken] = login.data.apiToken
                                onComplete(nil)
                            case let .Failure(responseFailure):
                                do {
                                    try keychainUser.removeAll()
                                } catch {
                                    Timber.e("Sign out error: \(error)")
                                }
                                onComplete(NSError(domain: "\(responseFailure)", code: 20003, userInfo: nil))
                            }
                        },
                        onFailure: { error in
                            onComplete(error)
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
