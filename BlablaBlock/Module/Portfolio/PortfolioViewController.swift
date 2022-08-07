//
//  PortfolioViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/23.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture
import RxDataSources

final public class PortfolioViewController: BaseViewController {
    
    private weak var parentCoordinator: MainCoordinator!
    private let viewModel: PortfolioViewModelType
    private let followViewModel: FollowViewModelType
    private let user: UserApiData?
    
    init(
        parentCoordinator: MainCoordinator?,
        viewModel: PortfolioViewModelType,
        followViewModel: FollowViewModelType,
        user: UserApiData?
    ) {
        self.parentCoordinator = parentCoordinator
        self.viewModel = viewModel
        self.followViewModel = followViewModel
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupUser()
        setupLayout()
        setupBinding()
        viewModel.inputs.user.accept(user)
        viewModel.inputs.viewDidLoad.accept(())
        followViewModel.inputs.user.accept(user)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        followViewModel.inputs.viewWillAppear.accept(())
    }

    private func setupUser() {
        if let user = user {
//            userNameView.text = user.name
            userNameView.setCertification(userId: user.userId)
        } else {
            userNameView.text = keychainUser[.userName] ?? keychainUser[.userEmail]
            userNameView.setCertification(userId: Int(keychainUser[.userId]!)!)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .grayE5E5E5
        
        if user != nil {
            navigationSectionView.delegate = self
            actionButton.setTitle("vc_portfolio_follow".localized(), for: .normal)
            actionButton.setTitle("vc_portfolio_following".localized(), for: .selected)
            actionButton.font = .boldSystemFont(ofSize: 12)
        }
        
        avatarImageView.image = "ic_profile_avatar_placeholder".image()
        avatarImageView.makeCircle(base: 74)
        avatarImageView.contentMode = .scaleAspectFit
        
        userNameView.textColor = .black2D2D2D
        userNameView.font = .boldSystemFont(ofSize: 18)
        
        assetSumLabel.textColor = .black2D2D2D
        assetSumLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        
        assetSumTitleLabel.text = "vc_portfolio_total_asset".localized()
        assetSumTitleLabel.textColor = .black2D2D2D
        assetSumTitleLabel.font = .systemFont(ofSize: 10, weight: .medium)
        
        assetDayChangeLabel.font = .boldSystemFont(ofSize: 10)
        assetDayChangeLabel.textAlignment = .center
        assetDayChangeLabel.layer.masksToBounds = true
        assetDayChangeLabel.layer.cornerRadius = 2
        
        basicInfoSectionSeparatorView.backgroundColor = .gray2D2D2D_40
        
        followerLabel.textColor = .black2D2D2D
        followerLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        
        followerTitleLabel.text = "vc_portfolio_follower".localized()
        followerTitleLabel.textColor = .black2D2D2D
        followerTitleLabel.font = .systemFont(ofSize: 10, weight: .medium)
        
//        followingLabel.textColor = .black2D2D2D
//        followingLabel.font = .systemFont(ofSize: 20, weight: .semibold)
//
//        followingTitleLabel.text = "vc_portfolio_following".localized()
//        followingTitleLabel.textColor = .black2D2D2D
//        followingTitleLabel.font = .systemFont(ofSize: 10, weight: .medium)
        
        radioGroup.delegate = self
        radioGroup.add(portfolioTabButton)
        radioGroup.add(pnlTabButton)
//        radioGroup.add(followingPortfolioTabButton)
        
        portfolioTabButton.isSelected = true
        portfolioTabButton.setTitle("vc_portfolio_positions".localized(), for: .normal)
        
        tabButtonSeparatorView.backgroundColor = .white
        pnlTabButton.setTitle("vc_portfolio_pnl".localized(), for: .normal)
        
//        tabButtonSeparatorViewRight.backgroundColor = .white
//        followingPortfolioTabButton.setTitle("vc_portfolio_following_portfolio".localized(), for: .normal)
        
        assetSumLabel.text = " "
        followerLabel.text = " "
//        followingLabel.text = " "

        pagerBackgroundView.backgroundColor = .white
        pagedView.setPages(
            pages: [
                portfolioSectionView,
                pnlSectionView
            ]
        )
    }
    
    private func setupAssetDayChange(dayChange: Double) {
        let sign: String
        if dayChange >= 0 {
            sign = "+"
            assetDayChangeLabel.textColor = .green76B128
            assetDayChangeLabel.backgroundColor = .green9DCB6080
        } else {
            sign = ""
            assetDayChangeLabel.textColor = .redE82020
            assetDayChangeLabel.backgroundColor = .redFFA8A8
        }
        assetDayChangeLabel.text = "\(sign)\(dayChange.toPrettyPrecisedString())%"
    }
    
    private func setupLayout() {
        view.addSubview(statusBarSection)
        statusBarSection.snp.makeConstraints { make in
            make.height.equalTo(Utils.statusBarHeight)
            make.leading.top.trailing.equalToSuperview()
        }
        
        if user != nil {
            view.addSubview(navigationSectionView)
            navigationSectionView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(statusBarSection.snp.bottom)
            }
            
            view.addSubview(basicInfoSectionView)
            basicInfoSectionView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
                make.top.equalTo(navigationSectionView.snp.bottom)
            }
        } else {
            view.addSubview(basicInfoSectionView)
            basicInfoSectionView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
                make.top.equalTo(statusBarSection.snp.bottom).offset(16)
            }
        }
        
        basicInfoSectionView.addSubview(basicInfoTopSectionView)
        basicInfoTopSectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        basicInfoTopSectionView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(74)
            make.leading.top.bottom.equalToSuperview()
        }
        
        basicInfoTopSectionView.addSubview(basicAssetInfoSectionView)
        basicAssetInfoSectionView.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(32)
            make.trailing.equalToSuperview()
        }

        basicAssetInfoSectionView.addSubview(userNameView)
        userNameView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.top.trailing.equalToSuperview()
        }

        basicAssetInfoSectionView.addSubview(assetSumLabel)
        assetSumLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(userNameView.snp.bottom).offset(12)
        }

        basicAssetInfoSectionView.addSubview(assetSumTitleLabel)
        assetSumTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalToSuperview()
            make.top.equalTo(assetSumLabel.snp.bottom).offset(2)
            make.bottom.equalToSuperview()
        }

        basicAssetInfoSectionView.addSubview(assetDayChangeLabel)
        assetDayChangeLabel.snp.makeConstraints { make in
            make.width.equalTo(49)
            make.leading.equalTo(assetSumTitleLabel.snp.trailing).offset(8)
            make.centerY.equalTo(assetSumTitleLabel)
        }

        basicInfoSectionView.addSubview(basicInfoSectionSeparatorView)
        basicInfoSectionSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(basicInfoTopSectionView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        basicInfoSectionView.addSubview(basicInfoBottomSectionView)
        basicInfoBottomSectionView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(basicInfoSectionSeparatorView.snp.bottom).offset(8)
        }
        
        if user != nil {
            basicInfoBottomSectionView.addSubview(actionButton)
            actionButton.snp.makeConstraints { make in
                make.width.equalTo(70)
                make.height.equalTo(22)
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        }
        
        basicInfoBottomSectionView.addSubview(followSectionView)
        followSectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(102)
            make.top.trailing.bottom.equalToSuperview()
        }

        followSectionView.addSubview(followerSectionView)
        followerSectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.leading.top.bottom.equalToSuperview()
        }

        followerSectionView.addSubview(followerLabel)
        followerLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }

        followerSectionView.addSubview(followerTitleLabel)
        followerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(followerLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

//        followSectionView.addSubview(followingSectionView)
//        followingSectionView.snp.makeConstraints { make in
//            make.width.equalToSuperview().multipliedBy(0.5)
//            make.leading.equalTo(followerSectionView.snp.trailing)
//            make.top.bottom.trailing.equalToSuperview()
//        }
//
//        followingSectionView.addSubview(followingLabel)
//        followingLabel.snp.makeConstraints { make in
//            make.leading.top.trailing.equalToSuperview()
//        }
//
//        followingSectionView.addSubview(followingTitleLabel)
//        followingTitleLabel.snp.makeConstraints { make in
//            make.top.equalTo(followingLabel.snp.bottom)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
        
        view.addSubview(tabButtonSectionView)
        tabButtonSectionView.snp.makeConstraints { make in
            make.top.equalTo(basicInfoSectionView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.height.equalTo(50)
        }
        
        // 4 + 6 + 6 + + 1 + 6 + 6 + 1 + 6 + 6 + 4
//        let allPadding = 46
//        let screenWidth = UIScreen.main.bounds.width
//        let tabButtonWidth = (screenWidth - CGFloat(allPadding)) / 3
        
        tabButtonSectionView.addSubview(tabButtonSeparatorView)
        tabButtonSeparatorView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().offset(-13)
        }

        tabButtonSectionView.addSubview(portfolioTabButton)
        portfolioTabButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalTo(tabButtonSeparatorView.snp.leading).offset(-6)
            make.top.bottom.equalToSuperview()
        }
        
        tabButtonSectionView.addSubview(pnlTabButton)
        pnlTabButton.snp.makeConstraints { make in
            make.leading.equalTo(tabButtonSeparatorView.snp.trailing).offset(6)
            make.trailing.equalToSuperview().offset(-6)
            make.top.bottom.equalToSuperview()
        }
        
//        tabButtonSectionView.addSubview(tabButtonSeparatorViewRight)
//        tabButtonSeparatorViewRight.snp.makeConstraints { make in
//            make.width.equalTo(1)
//            make.leading.equalTo(pnlTabButton.snp.trailing).offset(6)
//            make.top.equalToSuperview().offset(13)
//            make.bottom.equalToSuperview().offset(-13)
//        }
        
//        tabButtonSectionView.addSubview(followingPortfolioTabButton)
//        followingPortfolioTabButton.snp.makeConstraints { make in
//            make.width.equalTo(tabButtonWidth)
//            make.leading.equalTo(tabButtonSeparatorViewRight.snp.trailing).offset(6)
//            make.trailing.equalToSuperview().offset(-6)
//            make.top.bottom.equalToSuperview()
//        }
        
        view.addSubview(pagerBackgroundView)
        pagerBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(tabButtonSectionView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        pagerBackgroundView.addSubview(pagedView)
        pagedView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        if let user = user {
            actionButton.rx
                .tapGesture()
                .when(.recognized)
                .map { _ in user.userId }
                .bind(to: followViewModel.inputs.portfolioFollowBtnTap)
                .disposed(by: disposeBag)
            
            followViewModel.outputs
                .isFollowing
                .asDriver()
                .drive(actionButton.rx.isSelected)
                .disposed(by: disposeBag)
        }
        
        followerSectionView.rx
            .tapGesture()
            .when(.recognized)
            .map { _ in true }
            .subscribe(onNext: { [weak self] isDefaultPageFollower in
                guard let self = self else { return }
                self.parentCoordinator?.toFollow(isDefaultPageFollower: isDefaultPageFollower, viewModel: self.followViewModel)
            })
            .disposed(by: disposeBag)

//        followingSectionView.rx
//            .tapGesture()
//            .when(.recognized)
//            .map { _ in false }
//            .subscribe(onNext: { [weak self] isDefaultPageFollower in
//                guard let self = self else { return }
//                self.parentCoordinator?.toFollow(isDefaultPageFollower: isDefaultPageFollower, viewModel: self.followViewModel)
//            })
//            .disposed(by: disposeBag)

        viewModel.outputs
            .sum
            .emit(to: assetSumLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .profit
            .emit(onNext: { [weak self] dayChange in
                self?.setupAssetDayChange(dayChange: dayChange)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .uiEvent
            .asSignal()
            .emit(onNext: { [weak self] event in
                self?.handleUiEvent(event)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .errorMessage
            .asSignal()
            .emit(onNext: { [weak self] msg in
                self?.promptAlert(message: msg)
            })
            .disposed(by: disposeBag)

        followViewModel.outputs
            .followerAmount
            .map { String($0) }
            .asSignal(onErrorJustReturn: "")
            .emit(to: followerLabel.rx.text)
            .disposed(by: disposeBag)

//        followViewModel.outputs
//            .followingAmount
//            .map { String($0) }
//            .asSignal(onErrorJustReturn: "")
//            .emit(to: followingLabel.rx.text)
//            .disposed(by: disposeBag)
        
        followViewModel.outputs
            .errorMessage
            .asSignal()
            .emit(onNext: { [weak self] msg in
                self?.promptAlert(message: msg)
            })
            .disposed(by: disposeBag)
        
        portfolioSectionView.viewModel = viewModel
        pnlSectionView.viewModel = viewModel
//        followingPortfolioSectionView.viewModel = viewModel
    }
    
    private let statusBarSection = UIView()
    private lazy var navigationSectionView = BlablaBlockNavigationBarView()
    private let basicInfoSectionView = UIView()
    private let basicInfoTopSectionView = UIView()
    private let avatarImageView = UIImageView()
    private let basicAssetInfoSectionView = UIView()
    private let userNameView = BlablablockUserNameLabelView()
    private let assetSumLabel = UILabel()
    private let assetSumTitleLabel = UILabel()
    private let assetDayChangeLabel = UILabel()
    private let basicInfoSectionSeparatorView = UIView()
    private let basicInfoBottomSectionView = UIView()
    private lazy var actionButton = BlablaBlockOrangeButtonView()
    private let followSectionView = UIView()
    private let followerSectionView = UIView()
    private let followerLabel = UILabel()
    private let followerTitleLabel = UILabel()
//    private let followingSectionView = UIView()
//    private let followingLabel = UILabel()
//    private let followingTitleLabel = UILabel()
    private let tabButtonSectionView = UIView()
    private let radioGroup = RadioButtonGroup()
    private let portfolioTabButton = PortfolioTabButton()
    private let tabButtonSeparatorView = UIView()
    private let pnlTabButton = PortfolioTabButton()
//    private let tabButtonSeparatorViewRight = UIView()
//    private let followingPortfolioTabButton = PortfolioTabButton()
    private let pagerBackgroundView = UIView()
    private let pagedView = PagedView()
    private let portfolioSectionView = PortfolioSectionView()
    private let pnlSectionView = PNLSectionView()
//    private let followingPortfolioSectionView = FollowingPortfolioSectionView()
}

private extension PortfolioViewController {
    func handleUiEvent(_ event: PortfolioViewUiEvent) {
        switch event {
        case .history(let userId):
            parentCoordinator?.toTradyHistory(userId: userId)
        case .back:
            pop()
        }
    }
}

extension PortfolioViewController: BlablaBlockNavigationBarViewDelegate {
    public func onBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension PortfolioViewController: RadioButtonGroupDelegate {
    public func onClicked(radioButton: RadioButton) {
        switch radioButton {
        case portfolioTabButton:
            pagedView.moveToPage(at: 0)
            
        case pnlTabButton:
            if let user = user {
                EventTracker.Builder()
                    .setProperty(name: .USER_B, value: user.userId)
                    .logEvent(.CHECK_OTHERS_PROFILE_PERFORMANCE)
            } else {
                EventTracker.Builder()
                    .logEvent(.CHECK_PERSONAL_PAGE_PERFORMANCE)
            }
            pagedView.moveToPage(at: 1)
            
//        case followingPortfolioTabButton:
//            if let user = user {
//                EventTracker.Builder()
//                    .setProperty(name: .USER_B, value: user.userId)
//                    .logEvent(.CHECK_OTHERS_PROFILE_FOLLOWED_PORTFOLIO)
//            } else {
//                EventTracker.Builder()
//                    .logEvent(.CHECK_PERSONAL_PAGE_FOLLOWED_PORTFOLIO)
//            }
//            pagedView.moveToPage(at: 2)
//            
        default:
            break
        }
    }
}
