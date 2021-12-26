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
    
    @Injected private var authService: AuthService
    
    let successObservable = PublishRelay<Bool>()
    
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
                    signInHandler(response: response)
                },
                onFailure: { [unowned self] error in
                    errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func forgetPassword(email: String) -> Single<HttpResponse<LogInSuccess, ResponseFailure>> {
        AuthService.ForgetPassword(email: email)
            .request()
    }
    
    func signOut() {
        AuthService.Logout()
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    switch response {
                    case let .Success(responseStatus):
                        successObservable.accept(responseStatus.code == 200)
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
    
    private func signInHandler(response: HttpResponse<LogInSuccess, ResponseFailure>) {
        switch response {
        case let .Success(loginSuccess):
            Defaults[.userToken] = loginSuccess.data.apiToken
            successObservable.accept(true)
        case let .Failure(responseFailure):
            errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
        }
    }
    
}
