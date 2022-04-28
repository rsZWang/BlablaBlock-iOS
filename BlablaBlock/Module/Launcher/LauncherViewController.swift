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
    
    private weak var parentCoordinator: MainCoordinator?
    private let viewModel: LauncherViewModelType
//    private let homePageViewModel: HomePageViewModelType
//    private let exploreUserViewModel: ExploreUserViewModelType
//    private let portfolioViewModel: PortfolioViewModelType
//    private let exchangeViewModel: ExchangeApiViewModel
    
//    init(
//        homePageViewModel: HomePageViewModelType,
//        exploreUserViewModel: ExploreUserViewModelType,
//        portfolioViewModel: PortfolioViewModelType,
//        exchangeViewModel: ExchangeApiViewModel
//    ) {
//        self.homePageViewModel = homePageViewModel
//        self.exploreUserViewModel = exploreUserViewModel
//        self.portfolioViewModel = portfolioViewModel
//        self.exchangeViewModel = exchangeViewModel
//        super.init(nibName: nil, bundle: nil)
//    }
    
    init(
        parentCoordinator: MainCoordinator?,
        viewModel: LauncherViewModelType
    ) {
        self.parentCoordinator = parentCoordinator
        self.viewModel = viewModel
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
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.inputs.viewDidAppear.accept(())
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
    
    private func setupBinding() {
        viewModel.outputs
            .login
            .subscribe(onNext: { [weak self] in
                self?.signIn()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .preload
            .subscribe(onNext: { [weak self] userId in
                self?.preload(userId: userId)
            })
            .disposed(by: disposeBag)
    }
    
    private func signIn() {
        parentCoordinator?.signIn()
    }
    
    private func preload(userId: String) {
        parentCoordinator?.main()
//        mainCoordinator.main(
//            homePageViewModel: homePageViewModel,
//            exploreUserViewModel: exploreUserViewModel,
//            portfolioViewModel: portfolioViewModel,
//            exchangeViewModel: exchangeViewModel
//        )
    }
    
}
