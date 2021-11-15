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
import FirebaseAuth
import Resolver

class SignInViewController: UIViewController, RadioButtonGroupDelegate {
    
    private let disposeBag = DisposeBag()
    @Injected private var authViewModel: AuthViewModel
       
    private let radioButtonGruop = RadioButtonGroup()
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var signUpBtn: ColorTextButton!
    @IBOutlet weak var signInBtn: ColorTextButton!
    @IBOutlet weak var textFieldsStackView: UIStackView!
    @IBOutlet weak var userNameTextField: InputTextField!
    @IBOutlet weak var emailTextField: InputTextField!
    @IBOutlet weak var passwordTextField: InputTextField!
    @IBOutlet weak var nextBtn: ColorButton!
    
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
        
        signUpBtn.contentHorizontalAlignment = .left
        signInBtn.contentHorizontalAlignment = .left
        
//        authViewModel.observe(
//            email: userNameTextField.textField.rx.text.orEmpty.asObservable(),
//            password: passwordTextField.textField.rx.text.orEmpty.asObservable()
//        )
//            .subscribe(onNext: { [weak self] in self?.nextBtn.isEnabled = $0 })
//            .disposed(by: disposeBag)
        
        emailTextField.textField.text = "cool890104@gmail.com"
        passwordTextField.textField.text = "aaaa1111"
        
        nextBtn.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                Timber.i("CLICKED")
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func signIn() {
        authViewModel.signIn(email: emailTextField.textField.text!, password: passwordTextField.textField.text!) { [weak self] in
            if let errorCode = $0 {
                switch errorCode {
                    case .operationNotAllowed:
                        self?.promptAlert(message: "信箱或密碼無法使用")
                    case .invalidEmail:
                        self?.promptAlert(message: "信箱規格不符")
                    case .userDisabled:
                        self?.promptAlert(message: "此帳號已被停權")
                    case .wrongPassword:
                            self?.promptAlert(message: "密碼錯誤")
                    default:
                        self?.promptAlert(message: "Unknown error(\(errorCode))")
                }
            } else {
                self?.toMainPage()
            }
        }
    }
    
    func signUp() {
        authViewModel.signUp(email: emailTextField.textField.text!, password: passwordTextField.textField.text!) { [weak self] in
            if let errorCode = $0 {
                switch errorCode {
                    case .invalidEmail:
                        self?.promptAlert(message: "信箱規格不符")
                    case .emailAlreadyInUse:
                        self?.promptAlert(message: "信箱已經被註冊")
                    case .operationNotAllowed:
                        self?.promptAlert(message: "信箱或密碼無法使用")
                    case .weakPassword:
                        self?.promptAlert(message: "密碼強度不足")
                    default:
                        self?.promptAlert(message: "Unknown error(\(errorCode))")
                }
            } else {
                self?.toMainPage()
            }
        }
    }
    
    func promptAlert(message: String) {
        AlertBuilder()
            .setMessage(message)
            .setButton(title: "確定")
            .show(self)
    }
    
    func onClicked(radioButton: RadioButton) {
        let shouldHidden = radioButton == signInBtn
        if shouldHidden {
            userNameTextField.fadeIn { [weak self] in
                self?.userNameTextField.isHidden = true
                UIView.animate(
                    withDuration: 0.2,
                    animations: {
                        self?.textFieldsStackView.layoutIfNeeded()
                        self?.containerView.layoutIfNeeded()
                    }
                )
            }
        } else {
            userNameTextField.isHidden = false
            UIView.animate(
                withDuration: 0.2,
                animations: { [weak self] in
                    self?.textFieldsStackView.layoutIfNeeded()
                    self?.containerView.layoutIfNeeded()
                },
                completion: { [weak self] completed in
                    if completed {
                        self?.userNameTextField.fadeOut()
                    }
                }
            )
        }
    }
    
    private func toMainPage() {
        let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        mainTabBarController.tabBar.barTintColor = UIColor(named: "gray_tab_bar")!
        mainTabBarController.selectedIndex = 2
        let navigationViewController = UINavigationController(rootViewController: mainTabBarController)
        navigationViewController.modalPresentationStyle = .fullScreen
        navigationViewController.modalTransitionStyle = .crossDissolve
        navigationViewController.navigationBar.isHidden = true
        navigationViewController.navigationBar.barTintColor = .blue
        present(navigationViewController, animated: true)
    }
    
}
