//
//  HttpResponseTargetType.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/11.
//

import Moya
import RxSwift
import KeychainAccess

public enum HttpApiError: Error {
    case toeknExpired
    case timeout
}

public enum HttpResponse<SuccessBody: Decodable, FailureBody: Decodable> {
    case success(SuccessBody)
    case failure(FailureBody)
}

public enum TokenType {
    case normal
    case user
}

public protocol HttpResponseTargetType: Moya.TargetType, AccessTokenAuthorizable {
    associatedtype SuccessType: Decodable
    associatedtype FailureType: Decodable
    
    var tokenType: TokenType { get }
}

public extension HttpResponseTargetType {
    
    var baseURL: URL { URL(string: "\(HttpApiConfig.domain)/\(HttpApiConfig.apiVersion)")! }
    var headers: [String : String]? { nil }
    var sampleData: Data { Data() }
    var authorizationType: AuthorizationType? { .bearer }
    
    var decoder: JSONDecoder {
        ApiProvider.decoder
    }
    
    func request() -> Single<HttpResponse<SuccessType, FailureType>> {
        Single<HttpResponse<SuccessType, FailureType>>.create { single in
            perform {
                single($0)
            }
            return Disposables.create {}
        }
    }
    
    private func perform(completion: @escaping (Result<HttpResponse<SuccessType, FailureType>, Error>) -> Void) {
        ApiProvider.createProvider(tokenType: tokenType, callbackQueue: ApiProvider.requestQueue).request(self) { reuslt in
            switch reuslt {
            case let .success(response):
                if response.statusCode == 401 {
                    ApiProvider.requestQueue.suspend()
                    refreshToken { error in
                        ApiProvider.requestQueue.resume()
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            perform(completion: completion)
                        }
                    }
                } else {
                    completion(parseHttpResponse(response))
                }
            case let .failure(moyaError):
                completion(.failure(moyaError))
            }
        }
    }
    
    private func parseHttpResponse<S: Decodable, F: Decodable>(_ response: Response) -> Result<HttpResponse<S, F>, Error> {
        do {
            let successBody = try decoder.decode(S.self, from: response.data)
            return Result.success(HttpResponse.success(successBody))
        } catch {
            Timber.e(error)
            let failureBody = try? decoder.decode(F.self, from: response.data)
            if let failureBody = failureBody {
                return Result.success(HttpResponse.failure(failureBody))
            } else {
                return Result.failure(
                    HttpError(
                        code: response.statusCode,
                        message: error.localizedDescription,
                        body: response.data
                    )
                )
            }
        }
    }
    
    private func refreshToken(_ completion: @escaping (Error?) -> Void) {
        if let email = keychainUser[.userEmail] {
            if let password = keychainUser[.userPassword] {
                ApiProvider.createProvider(
                    tokenType: .normal,
                    callbackQueue: ApiProvider.refreshTokenQueue
                ).request(AuthService.login(email: email, password: password)) { moyaResult in
                    let error: Error?
                    switch moyaResult {
                        case let .success(response):
                            let httpReponseResult: Result<HttpResponse<Login, ResponseFailure>, Error> = parseHttpResponse(response)
                            switch httpReponseResult {
                                case let .success(httpReponse):
                                    switch httpReponse {
                                    case let .success(login):
                                        if login.code == 200 {
                                            keychainUser[.userToken] = login.data.apiToken
                                            error = nil
                                        } else {
                                            error = NSError.create(domain: "Unknown code", code: login.code)
                                        }
                                    case let .failure(responseFailure):
                                        error = NSError.create(responseFailure)
                                    }
                                case let .failure(parseError):
                                    error = parseError
                            }
                        case let .failure(moyaError):
                            error = moyaError
                    }
                    completion(error)
                }
            } else {
                completion(NSError(domain: "lack of password", code: 20001, userInfo: nil))
            }
        } else {
            completion(NSError(domain: "lack of email", code: 20002, userInfo: nil))
        }
    }
}

fileprivate final class ApiProvider {
    
    static let requestQueue = DispatchQueue(
        label: "com.wuchi.request_queue",
        qos: .background,
        attributes: .concurrent
    )
    
    static let refreshTokenQueue = DispatchQueue(
        label: "com.wuchi.refresh_token_queue",
        qos: .background
    )
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    static func createProvider<MultiTarget>(
        tokenType: TokenType,
        callbackQueue: DispatchQueue
    ) -> MoyaProvider<MultiTarget> {
        var pluginList = [PluginType]()
        #if DEBUG
        pluginList.append(MoyaLoggerPlugin())
        #endif
        pluginList.append(AccessTokenPlugin { _ in
            tokenType == .normal ? HttpApiConfig.normalToken : keychainUser[.userToken] ?? ""
        })
        return MoyaProvider<MultiTarget>(callbackQueue: callbackQueue, plugins: pluginList)
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
