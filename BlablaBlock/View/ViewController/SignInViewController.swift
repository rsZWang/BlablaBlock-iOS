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

class SignInViewController: BaseViewController, RadioButtonGroupDelegate {
    
    @Injected
    private var authViewModel: AuthViewModel
       
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
//            .subscribe(onNext: { [weak self] in
//                Timber.i("IS CLICKABLE: \($0)")
//                self?.nextBtn.isEnabled = $0
//            })
//            .disposed(by: disposeBag)
        
        emailTextField.textField.text = "rex@huijun.org"
        passwordTextField.textField.text = "123456"
        
        nextBtn.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
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
        authViewModel.signIn(
            email: emailTextField.textField.text ?? "",
            password: passwordTextField.textField.text ?? ""
        )
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.toMainPage()
                },
                onFailure: { [weak self] e in
                    self?.promptAlert(message: "帳號或密碼錯誤")
                }
            )
            .disposed(by: disposeBag)
    }
    
    func signUp() {
        authViewModel.signUp(
            email: emailTextField.textField.text ?? "",
            password: passwordTextField.textField.text ?? ""
        )
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.toMainPage()
                },
                onFailure: { [weak self] e in
                    self?.promptAlert(message: "\(e)")
                }
            )
            .disposed(by: disposeBag)
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
