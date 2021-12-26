//
//  SettingViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/24.
//

import UIKit
import RxSwift
import Resolver

class SettingViewController: BaseViewController, LinkCardViewDelegate {
    
    @Injected var mainCoordinator: MainCoordinator
    @Injected var authViewModel: AuthViewModel
    
    private lazy var binanceLinkCard = LinkCardView(
        self,
        image: UIImage(named: "ic_setting_binance")!,
        title: "連結幣安"
    )
    private lazy var ftxLinkCard = LinkCardView(
        self,
        image: UIImage(named: "ic_setting_ftx")!,
        title: "連結FTX"
    )

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var linkCardViewListStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        linkCardViewListStackView.spacing = 20
        linkCardViewListStackView.addArrangedSubview(binanceLinkCard)
        linkCardViewListStackView.addArrangedSubview(ftxLinkCard)
        
        signOutButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.signOutButton.isEnabled = false
                self?.authViewModel.signOut()
            })
            .disposed(by: disposeBag)
        
        authViewModel.successObservable
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.mainCoordinator.popToSignIn()
                }
                self?.signOutButton.isEnabled = true
            })
            .disposed(by: disposeBag)
        
        authViewModel.errorMessageObservable
            .subscribe(onNext: { [weak self] msg in
                self?.signOutButton.isEnabled = true
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.makeCircle()
    }
    
    func onTap() {
        let vc = LinkExchangeViewController()
        present(vc, animated: true)
    }

}
