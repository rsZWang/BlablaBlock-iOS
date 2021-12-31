//
//  SignInViewController.swift
//  BlablaBlock
//
//  Created by yhw on 2021/10/20.
//

import UIKit
import Resolver
import RxCocoa
import RxSwift
import RxGesture

class SignInViewController: BaseViewController, Storyboarded {
    
    @Injected private var mainCoordinator: MainCoordinator
    @Injected private var authViewModel: AuthViewModel
    @Injected private var exchangeApiViewModel: ExchangeApiViewModel
    private let signInMode = ReplayRelay<Bool>.create(bufferSize: 1)
    private var hasLinkedDisposable: Disposable?
       
    private let radioButtonGruop = RadioButtonGroup()
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var signInBtn: ColorTextButton!
    @IBOutlet weak var signUpBtn: ColorTextButton!
    @IBOutlet weak var textFieldsStackView: UIStackView!
    @IBOutlet weak var userNameInputView: NormalInputView!
    @IBOutlet weak var emailInputView: NormalInputView!
    @IBOutlet weak var passwordInputView: NormalInputView!
    @IBOutlet weak var passwordConfirmInputView: NormalInputView!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBOutlet weak var nextBtn: ColorButton!
    
    private var userNameTextField: UITextField { userNameInputView.textField }
    private var emailTextField: UITextField { emailInputView.textField }
    private var passwordTextField: UITextField { passwordInputView.textField }
    private var passwordConfirmTextField: UITextField { passwordConfirmInputView.textField }
    private var forgetPasswordInputAlert: InputAlert? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.layer.masksToBounds = false
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        radioButtonGruop.delegate = self
        radioButtonGruop.add(signInBtn)
        radioButtonGruop.add(signUpBtn)
        
        signInBtn.contentHorizontalAlignment = .left
        signUpBtn.contentHorizontalAlignment = .left
        
        userNameTextField.delegate = self
        userNameTextField.tag = 0
        userNameTextField.returnKeyType = .next
        emailTextField.delegate = self
        emailTextField.tag = 1
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        passwordTextField.delegate = self
        passwordTextField.tag = 2
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .done
        passwordConfirmTextField.delegate = self
        passwordConfirmTextField.tag = 3
        passwordConfirmTextField.isSecureTextEntry = true
        passwordConfirmTextField.returnKeyType = .done
        
        forgetPasswordBtn.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.promptForgetPasswordAlert()
            })
            .disposed(by: disposeBag)
    
        nextBtn.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.nextBtn.isEnabled = false
                if self?.radioButtonGruop.selectedButton == self?.signInBtn {
                    self?.signIn()
                } else {
                    self?.signUp()
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        clearPage()
        
//        emailTextField.text = "rex@huijun.org"
        emailTextField.text = "cool890104@gmail.com"
        passwordTextField.text = "123456"
        
        bindNextButton()
        
        authViewModel.successObservable
            .subscribe(onNext: { [weak self] result in
                self?.preload()
            })
            .disposed(by: shortLifeCycleOwner)
        
        authViewModel.errorMessageObservable
            .subscribe(onNext: { [weak self] msg in
                self?.nextBtn.isEnabled = true
                self?.promptAlert(message: msg)
            })
            .disposed(by: shortLifeCycleOwner)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hasLinkedDisposable?.dispose()
        hasLinkedDisposable = nil
    }
    
    func signIn() {
        authViewModel.signIn(
            email: emailTextField.text!,
            password: passwordTextField.text!
        )
    }
    
    func signUp() {
        authViewModel.signUp(
            userName: userNameTextField.text!,
            email: emailTextField.text!,
            password: passwordTextField.text!
        )
    }
    
    private func promptForgetPasswordAlert() {
        if forgetPasswordInputAlert == nil {
            forgetPasswordInputAlert = InputAlert()
                .setTitle("忘記密碼")
                .setMessage("輸入註冊時的信箱，我們將寄送驗證信件給您")
                .addTextField(tag: 1, placeholder: "電子信箱")
                .setConfirmButton(title: "確定") { [weak self] texts in
                    Timber.i("texts: \(texts)")
                    if let email = texts[1], email.isEmail {
                        self?.sendForgetPasswordMail(email)
                    } else {
                        self?.promptAlert(message: "電子信箱似乎輸入錯誤@@")
                    }
                }.build()
        }
        forgetPasswordInputAlert?.show(self)
    }
    
    private func sendForgetPasswordMail(_ email: String) {
        authViewModel.forgetPassword(email: email)
            .subscribe(
                onSuccess: { [unowned self] _ in
                    AlertBuilder()
                        .setTitle("重設密碼的信件已寄出")
                        .setMessage("快去信箱收信喔！")
                        .setOkButton()
                        .show(self)
                },
                onFailure: { [weak self] error in
                    self?.promptAlert(message: "\(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func clearPage() {
        userNameTextField.text = nil
        emailTextField.text = nil
        passwordTextField.text = nil
        passwordConfirmTextField.text = nil
        signInBtn.sendActions(for: .touchUpInside)
    }
    
    private func preload() {
        hasLinkedDisposable = exchangeApiViewModel.getApiStatus()
            .subscribe(
                onNext: { [weak self] hasLinked in
                    self?.mainCoordinator.main(isSignIn: false, hasLinked: hasLinked)
                },
                onError: { [weak self] error in
                    self?.mainCoordinator.signIn()
                }
            )
    }
    
}

extension SignInViewController {
    
    func bindNextButton() {
        
        signInMode.accept(true)
        
        let userNameValid = userNameTextField.rx
            .text.orEmpty
            .map { !$0.isEmpty }
            .share(replay: 1)

        let emailValid = emailTextField.rx
            .text.orEmpty
            .map { $0.isEmail }
            .share(replay: 1)

        let passwordValid = passwordTextField.rx
            .text.orEmpty
            .map { $0.isValidPassword }
            .share(replay: 1)
        
        let passwordConfirmValid = passwordConfirmTextField.rx
            .text.orEmpty
            .map { [weak self] in $0 == self?.passwordTextField.text }
            .share(replay: 1)

        Observable.combineLatest(
            signInMode,
            userNameValid,
            emailValid,
            passwordValid,
            passwordConfirmValid,
            resultSelector: { ($0 || ($1 && $4)) && $2 && $3 }
        )
        .share(replay: 1)
        .bind(to: nextBtn.rx.isEnabled)
        .disposed(by: shortLifeCycleOwner)
    }
    
}

extension SignInViewController: RadioButtonGroupDelegate {
    
    func onClicked(radioButton: RadioButton) {
        let shouldHidden = radioButton == signInBtn
        if shouldHidden {
            passwordTextField.returnKeyType = .done
            passwordConfirmTextField.tag = -1
            userNameInputView.fadeIn { [weak self] in
                self?.userNameInputView.isHidden = true
            }
            passwordConfirmInputView.fadeIn { [weak self] in
                self?.passwordConfirmInputView.isHidden = true
                UIView.animate(
                    withDuration: 0.2,
                    animations: {
                        self?.textFieldsStackView.layoutIfNeeded()
                        self?.containerView.layoutIfNeeded()
                    }
                )
            }
            signInMode.accept(true)
        } else {
            userNameInputView.isHidden = false
            passwordConfirmInputView.isHidden = false
            passwordTextField.returnKeyType = .next
            passwordConfirmTextField.tag = 3
            UIView.animate(
                withDuration: 0.2,
                animations: { [weak self] in
                    self?.textFieldsStackView.layoutIfNeeded()
                    self?.containerView.layoutIfNeeded()
                },
                completion: { [weak self] completed in
                    if completed {
                        self?.userNameInputView.fadeOut()
                        self?.passwordConfirmInputView.fadeOut()
                    }
                }
            )
            signInMode.accept(false)
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = view?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
