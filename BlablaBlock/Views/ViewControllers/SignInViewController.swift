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
    @IBOutlet weak var nextBtn: ColorButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.layer.masksToBounds = false
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        radioButtonGruop.delegate = self
        radioButtonGruop.add(signUpBtn)
        radioButtonGruop.add(signInBtn)
        
        signUpBtn.contentHorizontalAlignment = .left
        signInBtn.contentHorizontalAlignment = .left
        
        nextBtn.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.toMainPage()
            })
            .disposed(by: disposeBag)
//        nextBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
    }
    
    func onClicked(radioButton: RadioButton) {
        Timber.i("\(radioButton)")
    }
    
    private func toMainPage() {
        let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        mainTabBarController.tabBar.barTintColor = UIColor(named: "bg_gray")!
        mainTabBarController.selectedIndex = 2
        let navigationViewController = UINavigationController(rootViewController: mainTabBarController)
        navigationViewController.modalPresentationStyle = .fullScreen
        navigationViewController.modalTransitionStyle = .crossDissolve
        navigationViewController.navigationBar.isHidden = true
        navigationViewController.navigationBar.barTintColor = .blue
        present(navigationViewController, animated: true)
    }
    
}
