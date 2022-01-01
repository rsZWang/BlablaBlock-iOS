//
//  AuthViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/10.
//

import Resolver
import RxCocoa
import RxSwift
import KeychainAccess

class AuthViewModel: BaseViewModel {
    
    let successObservable = PublishSubject<Bool>()
    
    func signIn(email: String, password: String) {
        AuthService.login(email: email, password: password)
            .request()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] login in
                    self?.signInHandler(
                        userEmail: email,
                        userPassword: password,
                        login: login
                    )
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func signUp(userName: String, email: String, password: String) {
        AuthService.register(userName: userName, email: email, password: password)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(registrationModel):
                        self?.signIn(
                            userEmail: email,
                            userPassword: password,
                            userToken: registrationModel.data.apiToken,
                            userName: registrationModel.data.name
                        )
                    case let .failure(responseFailure):
                        self?.errorCodeHandler(responseFailure)
                    }
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func forgetPassword(email: String) -> Single<HttpResponse<Login, ResponseFailure>> {
        AuthService.forgetPassword(email: email)
            .request()
    }
    
    func signOut() {
        AuthService.logout()
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
//                    switch response {
//                    case .success:
//                        self?.doSignOut()
//                    case let .failure(responseFailure):
//                        self?.errorCodeHandler(responseFailure)
//                    }
                    self?.doSignOut()
                },
                onFailure: { [weak self] error in
//                    self?.errorHandler(error: error)
                    self?.doSignOut()
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func signInHandler(
        userEmail: String,
        userPassword: String,
        login: HttpResponse<Login, ResponseFailure>
    ) {
        switch login {
        case let .success(login):
            signIn(
                userEmail: userEmail,
                userPassword: userPassword,
                userToken: login.data.apiToken,
                userName: login.data.name ?? login.data.email
            )
        case let .failure(responseFailure):
            errorCodeHandler(responseFailure)
        }
    }
    
    private func signIn(
        userEmail: String,
        userPassword: String,
        userToken: String,
        userName: String
    ) {
        keychainUser[.userEmail] = userEmail
        keychainUser[.userPassword] = userPassword
        keychainUser[.userToken] = userToken
        keychainUser[.userName] = userName
        successObservable.onNext(true)
    }
    
    private func doSignOut() {
        do {
            try keychainUser.removeAll()
        } catch {
            Timber.e("Sign out error: \(error)")
        }
        successObservable.onNext(true)
    }
    
}
