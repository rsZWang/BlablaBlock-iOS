//
//  SignInViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/10.
//

import RxCocoa
import RxSwift
import KeychainAccess

public enum SignInUiEvent {
    case success
    case resetPassword
    case passwordReset
}

public protocol SignInViewModelInputs: AnyObject {
    var signIn: PublishRelay<(String, String)> { get }
    var signUp: PublishRelay<(String, String, String)> { get }
    var forgetPassword: PublishRelay<String> { get }
    var resetPassword: PublishRelay<(String, String)> { get }
}

public protocol SignInViewModelOutputs: BaseViewModelOutputs {
    var uiEvent: Signal<SignInUiEvent> { get }
}

public protocol SignInViewModelType: AnyObject {
    var inputs: SignInViewModelInputs { get }
    var outputs: SignInViewModelOutputs { get }
}

final public class SignInViewModel:
    BaseViewModel,
    SignInViewModelInputs,
    SignInViewModelOutputs,
    SignInViewModelType
{
    
    // MARK: - inputs
    
    public var signIn: PublishRelay<(String, String)>
    public var signUp: PublishRelay<(String, String, String)>
    public var forgetPassword: PublishRelay<String>
    public var resetPassword: PublishRelay<(String, String)>
    
    // MARK: - outputs
    public var uiEvent: Signal<SignInUiEvent>
    
    public var inputs: SignInViewModelInputs { self }
    public var outputs: SignInViewModelOutputs { self }
    
    override init() {
        let signIn = PublishRelay<(String, String)>()
        let signUp = PublishRelay<(String, String, String)>()
        let forgetPassword = PublishRelay<String>()
        let resetPassword = PublishRelay<(String, String)>()
        
        self.signIn = signIn
        self.signUp = signUp
        self.forgetPassword = forgetPassword
        self.resetPassword = resetPassword
        
        let uiEvent = PublishRelay<SignInUiEvent>()
        
        self.uiEvent = uiEvent.asSignal()
        
        super.init()
        
        signIn
            .subscribe(onNext: { [weak self] (email, password) in
                self?.signIn(email: email, password: password, uiEvent: uiEvent)
            })
            .disposed(by: disposeBag)
        
        signUp
            .subscribe(onNext: { [weak self] (userName, email, password) in
                self?.signUp(userName: userName, email: email, password: password, uiEvent: uiEvent)
            })
            .disposed(by: disposeBag)
        
        forgetPassword
            .subscribe(onNext: { [weak self] email in
                self?.forgetPassword(email: email, uiEvent: uiEvent)
            })
            .disposed(by: disposeBag)
        
        resetPassword
            .subscribe(onNext: { [weak self] (token, password) in
                self?.resetPassword(token: token, password: password, uiEvent: uiEvent)
            })
            .disposed(by: disposeBag)
    }
    
    private func signIn(
        email: String,
        password: String,
        uiEvent: PublishRelay<SignInUiEvent>
    ) {
        AuthService.login(email: email, password: password)
            .subscribe(
                onSuccess: { [weak self] login in
                    switch login {
                    case let .success(authData):
                        self?.getUser(
                            password: password,
                            token: authData.data.token,
                            uiEvent: uiEvent
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
    
    private func signUp(
        userName: String,
        email: String,
        password: String,
        uiEvent: PublishRelay<SignInUiEvent>
    ) {
        AuthService.signup(userName: userName, email: email, password: password)
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(authData):
                        EventTracker.Builder()
                            .logEvent(.SIGN_UP)

                        self?.getUser(
                            password: password,
                            token: authData.data.token,
                            uiEvent: uiEvent
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
    
    private func getUser(
        password: String,
        token: String,
        uiEvent: PublishRelay<SignInUiEvent>
    ) {
        keychainUser[.userPassword] = password
        keychainUser[.userToken] = token
        UserService.getUser()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(userData):
                        let user = userData.data
                        keychainUser[.userEmail] = user.email
                        keychainUser[.userName] =  user.userName
                        keychainUser[.userId] = String(user.userId)
                        
                        uiEvent.accept(.success)
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
    
    private func forgetPassword(
        email: String,
        uiEvent: PublishRelay<SignInUiEvent>
    ) {
        AuthService.forgetPassword(email: email)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case .success(_):
                        uiEvent.accept(.resetPassword)
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
    
    private func resetPassword(
        token: String,
        password: String,
        uiEvent: PublishRelay<SignInUiEvent>
    ) {
        AuthService.resetPassword(token: token, password: password)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case .success(_):
                        uiEvent.accept(.passwordReset)
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
}
