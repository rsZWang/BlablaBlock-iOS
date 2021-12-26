//
//  AuthViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/10.
//

import Resolver
import RxCocoa
import RxSwift
import Defaults

class AuthViewModel: BaseViewModel {
    
    let successObservable = PublishSubject<Bool>()
    
    func signIn(email: String, password: String) {
        AuthService.Login(email: email, password: password)
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    signInHandler(response: response)
                },
                onFailure: { [unowned self] error in
                    errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func signUp(userName: String, email: String, password: String) {
        AuthService.Registration(userName: userName, email: email, password: password)
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    switch response {
                    case let .Success(registration):
                        signIn(userToken: registration.data.apiToken, userName: registration.data.name)
                    case let .Failure(responseFailure):
                        errorCodeHandler(responseFailure)
                    }
                },
                onFailure: { [unowned self] error in
                    errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func forgetPassword(email: String) -> Single<HttpResponse<LogIn, ResponseFailure>> {
        AuthService.ForgetPassword(email: email)
            .request()
    }
    
    func signOut() {
        AuthService.Logout()
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    switch response {
                    case .Success:
                        doSignOut()
                    case let .Failure(responseFailure):
                        errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
                    }
                },
                onFailure: { [unowned self] error in
                    errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func signInHandler(response: HttpResponse<LogIn, ResponseFailure>) {
        switch response {
        case let .Success(loginSuccess):
            signIn(userToken: loginSuccess.data.apiToken, userName: loginSuccess.data.email)
        case let .Failure(responseFailure):
            errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
        }
    }
    
    private func signIn(userToken: String, userName: String) {
        Defaults[.userToken] = userToken
        Defaults[.userName] = userName
        successObservable.onNext(true)
    }
    
    private func doSignOut() {
        Defaults[.userToken] = nil
        Defaults[.userName] = nil
        successObservable.onNext(true)
    }
    
}
