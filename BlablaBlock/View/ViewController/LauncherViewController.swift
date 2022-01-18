//
//  LauncherViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/26.
//

import UIKit
import Resolver
import SnapKit
import RxSwift

class LauncherViewController: BaseViewController {
    
    @Injected var mainCoordinator: MainCoordinator
    @Injected var exchangeApiViewModel: ExchangeApiViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = keychainUser[.userToken] {
            preload()
        } else {
            mainCoordinator.signIn()
        }
    }
    
    private func addLogo() {
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
        }
        
        let appNameLabel = UILabel()
        appNameLabel.text = "BlablaBlock"
        appNameLabel.font = .boldSystemFont(ofSize: 32)
        appNameLabel.textColor = .white
        appNameLabel.textAlignment = .center
        
        containerView.addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(containerView)
        }
        
        let sloganLabel = UILabel()
        sloganLabel.text = "Connect Everything about\nCrypto Trading"
        sloganLabel.font = .systemFont(ofSize: 17)
        sloganLabel.textColor = .white
        sloganLabel.textAlignment = .center
        sloganLabel.numberOfLines = 2
        
        containerView.addSubview(sloganLabel)
        sloganLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(containerView)
            make.top.equalTo(appNameLabel.snp.bottom).offset(20)
        }
    }
    
    private func preload() {
        exchangeApiViewModel.getApiStatus()
            .subscribe(
                onNext: { [weak self] hasLinked in
                    self?.mainCoordinator.main(isSignIn: false, hasLinked: hasLinked)
                },
                onError: { [weak self] error in
                    self?.mainCoordinator.signIn()
                }
            )
            .disposed(by: shortLifecycleOwner)
    }
    
}
