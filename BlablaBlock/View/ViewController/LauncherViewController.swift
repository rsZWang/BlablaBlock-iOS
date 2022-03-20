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

final class LauncherViewController: BaseViewController {
    
    @Injected var mainCoordinator: NewMainCoordinator
    private let homeViewModel: HomeViewModelType
    private let searchViewModel: SearchViewModelType
    private let portfolioViewModel: PortfolioViewModelType
    private let exchangeViewModel: ExchangeViewModelType
    
    init(
        homeViewModel: HomeViewModelType,
        searchViewModel: SearchViewModelType,
        portfolioViewModel: PortfolioViewModelType,
        exchangeViewModel: ExchangeViewModelType
    ) {
        self.homeViewModel = homeViewModel
        self.searchViewModel = searchViewModel
        self.portfolioViewModel = portfolioViewModel
        self.exchangeViewModel = exchangeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if let _ = keychainUser[.userToken], let _ = keychainUser[.userId] {
//            preload()
//        } else {
//            mainCoordinator.signIn()
//        }
        preload()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
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
        mainCoordinator.main(
            homeViewModel: homeViewModel,
            searchViewModel: searchViewModel,
            portfolioViewModel: portfolioViewModel,
            exchangeViewModel: exchangeViewModel
        )
//        exchangeApiViewModel.getApiStatus()
//            .subscribe(
//                onNext: { [weak self] hasLinked in
//                    self?.mainCoordinator.main(isSignIn: false, hasLinked: hasLinked)
//                },
//                onError: { [weak self] error in
//                    self?.mainCoordinator.signIn()
//                }
//            )
//            .disposed(by: shortLifecycleOwner)
    }
    
}
