//
//  SignInViewController.swift
//  BlablaBlock
//
//  Created by yhw on 2021/10/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Resolver

class SignInViewController: BaseViewController {
    
    @Injected
    private var authViewModel: AuthViewModel
    private let signInValid = ReplayRelay<Bool>.create(bufferSize: 1)
       
    private let radioButtonGruop = RadioButtonGroup()
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var signUpBtn: ColorTextButton!
    @IBOutlet weak var signInBtn: ColorTextButton!
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

        emailTextField.text = "rex@huijun.org"
        passwordTextField.text = "123456"
        
        bindNextButton()
        
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
        
        authViewModel.apiReponseObservable
            .subscribe(
                onNext: { [weak self] result in
                    self?.toMainPage()
                    self?.nextBtn.isEnabled = true
                },
                onError: { [weak self] error in
                    self?.nextBtn.isEnabled = true
                    self?.promptAlert(message: "\(error)")
                }
            )
            .disposed(by: disposeBag)
        
        signIn()
        
//        nextBtn.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func signIn() {
        authViewModel.signIn(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }
    
    func signUp() {
        authViewModel.signUp(
            userName: userNameTextField.text ?? "",
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
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
                onSuccess: { [unowned self] response in
                    AlertBuilder()
                        .setTitle("重設密碼的信件已寄出")
                        .setMessage("快去信箱收信喔！")
                        .setOkButton()
                        .show(self)
                },
                onFailure: { [unowned self] error in
                    promptAlert(message: "\(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func toMainPage() {
        let mainTabBarController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        mainTabBarController.tabBar.barTintColor = UIColor(named: "gray_tab_bar")!
        mainTabBarController.selectedIndex = 2
        push(vc: mainTabBarController)
    }
    
}

extension SignInViewController {
    
    func bindNextButton() {
        signInValid.accept(true)
        
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
            signInValid,
            userNameValid,
            emailValid,
            passwordValid,
            passwordConfirmValid,
            resultSelector: { ($0 || ($1 && $4)) && $2 && $3 }
        )
        .share(replay: 1)
        .bind(to: nextBtn.rx.isEnabled)
        .disposed(by: disposeBag)
    }
    
}

extension SignInViewController: RadioButtonGroupDelegate {
    
    func onClicked(radioButton: RadioButton) {
        let shouldHidden = radioButton == signInBtn
        if shouldHidden {
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
            signInValid.accept(true)
        } else {
            userNameInputView.isHidden = false
            passwordConfirmInputView.isHidden = false
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
            signInValid.accept(false)
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Timber.i("textFieldShouldReturn: \(textField.tag)")
        let nextTag = textField.tag + 1
        if let nextResponder = view?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
