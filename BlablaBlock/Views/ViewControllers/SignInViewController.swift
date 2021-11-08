//
//  SignInViewController.swift
//  BlablaBlock
//
//  Created by yhw on 2021/10/20.
//

import UIKit
import RxSwift
import RxGesture

class SignInViewController: UIViewController, RadioButtonGroupDelegate {
    
    private let disposeBag = DisposeBag()
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
        
        nextBtn.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                if self?.radioButtonGruop.selectedButton == self?.signUpBtn {
                    self?.signUp()
                } else {
                    self?.signIn()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func signUp() {
        Timber.i("Is signing up")
    }
    
    func signIn() {
        Timber.i("Is signing in")
    }
    
    func onClicked(radioButton: RadioButton) {
        let shouldHidden = radioButton == signInBtn
        if shouldHidden {
            userNameTextField.fadeIn { [weak self] in
                self?.userNameTextField.isHidden = true
                UIView.animate(
                    withDuration: 0.2,
                    animations: { [weak self] in
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
