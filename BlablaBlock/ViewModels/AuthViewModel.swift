//
//  AuthViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/10.
//

import RxSwift
import FirebaseAuth

class AuthViewModel: NSObject {
    
    var emailValid: Observable<Bool>!
    var passwordValid: Observable<Bool>!
    private var authHandler: AuthStateDidChangeListenerHandle!
    var currentUser: User!
    
    override init() {
        super.init()
        authHandler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user {
                self?.currentUser = user
            } else {
                Timber.w("LOGGED OUT!")
                Timber.w(auth)
            }
        }
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(authHandler!)
    }
    
    func observe(email: Observable<String>, password: Observable<String>) -> Observable<Bool> {
        emailValid = email
            .map { $0.isEmail }
            .share(replay: 1)
        passwordValid = password
            .map { $0.isValidPassword }
            .share(replay: 1)
        return Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
    }
    
    func signIn(email: String, password: String, onResult: @escaping (AuthErrorCode?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] authResult, error in
            if let error = error as NSError? {
                onResult(AuthErrorCode(rawValue: error.code))
            } else if let authResult = authResult {
                currentUser = authResult.user
                onResult(nil)
            }
        }
    }
    
    func signUp(email: String, password: String, onResult: @escaping (AuthErrorCode?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] authResult, error in
            if let error = error as NSError? {
                onResult(AuthErrorCode(rawValue: error.code))
            } else if let authResult = authResult {
                currentUser = authResult.user
                onResult(nil)
            }
        }
    }
    
}
