//
//  AuthViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/10.
//

import Resolver
import RxSwift

class AuthViewModel {
    
    @Injected private var authService: AuthService
    
    var emailValid: Observable<Bool>!
    var passwordValid: Observable<Bool>!
    
    func observe(email: Observable<String>, password: Observable<String>) -> Observable<Bool> {
        emailValid = email
            .map { $0.isEmail }
            .share()
        passwordValid = password
            .map { $0.isValidPassword }
            .share()
        return Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
    }
    
    func signIn(email: String, password: String) -> Single<ResponseSuccess> {
        AuthService.Login(email: email, password: password)
            .request()
    }
    
    func signUp(email: String, password: String) -> Single<ResponseSuccess> {
        AuthService.Registration(email: email, password: password)
            .request()
    }
    
}
