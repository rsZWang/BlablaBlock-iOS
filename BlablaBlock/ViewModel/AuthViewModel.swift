//
//  AuthViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/10.
//

import Resolver
import RxCocoa
import RxSwift

class AuthViewModel: BaseViewModel {
    
    @Injected private var authService: AuthService
    
    var apiReponseObservable = PublishSubject<String>()
    
    func signIn(email: String, password: String) {
        AuthService.Login(email: email, password: password)
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    switch response {
                    case let .Success(logInSuccessModel):
                        userToken = logInSuccessModel.data.apiToken
                        apiReponseObservable.onNext("")
                    case let .Failure(responseFailureModel):
                        apiReponseObservable.onNext("\(responseFailureModel)")
                    }
                },
                onFailure: { [unowned self] e in
                    apiReponseObservable.onError(e)
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
                    case let .Success(logInSuccessModel):
                        userToken = logInSuccessModel.data.apiToken
                        apiReponseObservable.onNext("")
                    case let .Failure(responseFailureModel):
                        apiReponseObservable.onNext("\(responseFailureModel)")
                    }
                },
                onFailure: { [unowned self] e in
                    apiReponseObservable.onError(e)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func forgetPassword(email: String) -> Single<HttpResponse<AuthService.ForgetPassword.SuccessType, AuthService.ForgetPassword.FailureType>> {
        AuthService.ForgetPassword(email: email)
            .request()
    }
    
    func signOut() {
        AuthService.Logout()
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    
                },
                onFailure: { [unowned self] e in
                    
                }
            )
            .disposed(by: disposeBag)
    }
    
}
