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

final class AuthViewModel: BaseViewModel {
    
    let successObservable = PublishSubject<Bool>()
    let resetPasswordSent = PublishRelay<()>()
    
    func signIn(email: String, password: String) {
        AuthService.login(email: email, password: password)
            .request()
            .observe(on: MainScheduler.asyncInstance)
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
                    case let .success(registrationApi):
                        self?.signIn(
                            userEmail: email,
                            userPassword: password,
                            userToken: registrationApi.data.apiToken,
                            userName: registrationApi.data.name,
                            userId: registrationApi.data.id
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
    
    func forgetPassword(email: String) {
        AuthService.forgetPassword(email: email)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case .success(_):
                        self?.resetPasswordSent.accept(())
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
        login: HttpResponse<LoginApi, ResponseFailure>
    ) {
        switch login {
        case let .success(login):
            signIn(
                userEmail: userEmail,
                userPassword: userPassword,
                userToken: login.data.apiToken,
                userName: login.data.name ?? login.data.email,
                userId: login.data.userId
            )
        case let .failure(responseFailure):
            errorCodeHandler(responseFailure)
        }
    }
    
    private func signIn(
        userEmail: String,
        userPassword: String,
        userToken: String,
        userName: String,
        userId: Int
    ) {
        keychainUser[.userEmail] = userEmail
        keychainUser[.userPassword] = userPassword
        keychainUser[.userToken] = userToken
        keychainUser[.userName] = userName
        keychainUser[.userId] = String(userId)
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
