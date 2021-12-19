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
                    apiReponseObservable.onNext("")
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
                    apiReponseObservable.onNext("")
                },
                onFailure: { [unowned self] e in
                    apiReponseObservable.onError(e)
                }
            )
            .disposed(by: disposeBag)
    }
    
}
