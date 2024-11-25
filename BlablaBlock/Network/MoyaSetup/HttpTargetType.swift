//
//  HttpTargetType.swift
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
    case custom(String)
}

public protocol HttpTargetType: Moya.TargetType, AccessTokenAuthorizable {
    associatedtype SuccessType: Decodable
    associatedtype FailureType: Decodable
    
    var tokenType: TokenType { get }
}

public extension HttpTargetType {
    
    var baseURL: URL { HttpApiConfig.baseURL }
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
    
    func subscribe(
        onSuccess: ((HttpResponse<SuccessType, FailureType>) -> Void)? = nil,
        onFailure: ((Error) -> Void)? = nil,
        onDisposed: (() -> Void)? = nil
    ) -> Disposable {
        return request().subscribe(onSuccess: onSuccess, onFailure: onFailure, onDisposed: onDisposed)
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
            let status = (try decoder.decode(ResponseSuccess.self, from: response.data)).status
            switch status {
            case "success":
                let successBody = try decoder.decode(S.self, from: response.data)
                return Result.success(HttpResponse.success(successBody))
                
            case "error":
                let errorBody = try decoder.decode(F.self, from: response.data)
                return Result.success(HttpResponse.failure(errorBody))
                
            default:
                let failureBody = try? decoder.decode(F.self, from: response.data)
                if let failureBody = failureBody {
                    return Result.success(HttpResponse.failure(failureBody))
                } else {
                    return Result.failure(
                        HttpError(
                            code: response.statusCode,
                            message: "Parse error, empty",
                            body: response.data
                        )
                    )
                }
            }
//            if status.code == 200 {
//                let successBody = try decoder.decode(S.self, from: response.data)
//                return Result.success(HttpResponse.success(successBody))
//            } else {
//                let failureBody = try? decoder.decode(F.self, from: response.data)
//                if let failureBody = failureBody {
//                    return Result.success(HttpResponse.failure(failureBody))
//                } else {
//                    return Result.failure(
//                        HttpError(
//                            code: response.statusCode,
//                            message: "Parse error, empty",
//                            body: response.data
//                        )
//                    )
//                }
//            }
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
        if self is AuthService.resetPassword {
            completion(NSError(domain: "Token expired", code: 20003, userInfo: nil))
            return
        }
        if let email = keychainUser[.userEmail] {
            if let password = keychainUser[.userPassword] {
                ApiProvider.createProvider(
                    tokenType: .normal,
                    callbackQueue: ApiProvider.refreshTokenQueue
                ).request(AuthService.login(email: email, password: password)) { moyaResult in
                    let error: Error?
                    switch moyaResult {
                        case let .success(response):
                            let httpReponseResult: Result<HttpResponse<LoginApi, ResponseFailure>, Error> = parseHttpResponse(response)
                            switch httpReponseResult {
                                case let .success(httpReponse):
                                    switch httpReponse {
                                    case let .success(login):
                                        if login.status == "success" {
                                            keychainUser[.userToken] = login.data.token
                                            error = nil
                                        } else {
                                            error = NSError.create(domain: "Unknown code", code: -1)
                                        }
//                                        if login.code == 200 {
//                                            keychainUser[.userToken] = login.data.apiToken
//                                            error = nil
//                                        } else {
//                                            error = NSError.create(domain: "Unknown code", code: login.code)
//                                        }
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
        label: "com.wuchi.blablablock.request_queue",
        qos: .background,
        attributes: .concurrent
    )
    
    static let refreshTokenQueue = DispatchQueue(
        label: "com.wuchi.blablablock.refresh_token_queue",
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
            switch tokenType {
            case .normal:
                return HttpApiConfig.normalToken
            case .user:
                return keychainUser[.userToken] ?? ""
            case .custom(let token):
                return token
            }
        })

        return MoyaProvider<MultiTarget>(callbackQueue: callbackQueue, plugins: pluginList)
    }
}
