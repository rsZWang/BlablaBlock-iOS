//
//  PortfolioViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/23.
//

import UIKit
import Resolver
import RxCocoa
import RxSwift
import RxGesture
import RxDataSources

final class PortfolioViewController: BaseViewController {
    
    private var user: UserApiData?
    private var viewModel: PortfolioViewModelType
    
    init(user: UserApiData?, viewModel: PortfolioViewModelType) {
        self.user = user
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
        setupLayout()
        setupBinding()
//        viewModel.outputs.user.accept(user)
//        followViewModel.inputs.user.accept(user)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.makeCircle(base: 70)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        followViewModel.inputs.viewWillAppear.accept(())
    }
    
    private func setupUI() {
        view.backgroundColor = .grayE5E5E5
        avatarImageView.image = "ic_profile_avatar_placeholder".image()
        avatarImageView.contentMode = .scaleAspectFit
        userNameLabel.textColor = .black2D2D2D
        userNameLabel.font = .boldSystemFont(ofSize: 18)
        assetSumLabel.textColor = .black2D2D2D
        assetSumLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        assetSumTitleLabel.text = "總資產"
        assetSumTitleLabel.textColor = .black2D2D2D
        assetSumTitleLabel.font = .systemFont(ofSize: 10, weight: .medium)
        basicInfoSectionSeparatorView.backgroundColor = .gray2D2D2D_40
        followerLabel.textColor = .black2D2D2D
        followerLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        followerTitleLabel.text = "粉絲"
        followerTitleLabel.textColor = .black2D2D2D
        followerTitleLabel.font = .systemFont(ofSize: 10, weight: .medium)
        followingLabel.textColor = .black2D2D2D
        followingLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        followingTitleLabel.text = "追蹤中"
        followingTitleLabel.textColor = .black2D2D2D
        followingTitleLabel.font = .systemFont(ofSize: 10, weight: .medium)
        portfolioTabButton.setTitle("投資組合", for: .normal)
        tabButtonSeparatorViewLeft.backgroundColor = .white
        tradingPerformanceTabButton.setTitle("交易績效", for: .normal)
        tabButtonSeparatorViewRight.backgroundColor = .white
        followingPortfolioTabButton.setTitle("追蹤中組合", for: .normal)
        
        userNameLabel.text = "交易大神"
        assetSumLabel.text = "10000000.00"
        followerLabel.text = "1000"
        followingLabel.text = "1000"
        
        portfolioTabButton.isSelected = true
        followingPortfolioTabButton.isSelected = true
        
        pagerView.backgroundColor = .white
//        portfolioView.delegate = self
//        pnlView.delegate = self
//        followingPortfolioView.delegate = self
//        radioGroup.delegate = self
//        radioGroup.add(protfolioButton)
//        radioGroup.add(pnlButton)
//        radioGroup.add(followingButton)
//        if user == nil {
//            shareButton.isHidden = true
//            backButton.isHidden = true
//        } else {
//            shareButton.isHidden = false
//            shareButton.rx
//                .tap
//                .bind(to: followViewModel.inputs.followBtnTap)
//                .disposed(by: disposeBag)
//
//            backButton.isHidden = false
//            backButton.rx
//                .tap
//                .asSignal()
//                .map { PortfolioViewUiEvent.back }
//                .emit(to: viewModel.outputs.uiEvent)
//                .disposed(by: disposeBag)
//        }
    }
    
    private func setupUser(user: UserApiData?) {
//        if let user = user {
//            nameLabel.text = user.name
//            if user.isFollow {
//                shareButton.setTitle("追蹤中", for: .normal)
//                shareButton.isSelected = true
//            } else {
//                shareButton.setTitle("追蹤", for: .normal)
//                shareButton.isSelected = false
//            }
//        } else {
//            nameLabel.text = keychainUser[.userName]
//        }
    }
    
    private func setupLayout() {
        view.addSubview(statusBarSection)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        statusBarSection.snp.makeConstraints { make in
            make.height.equalTo(statusBarHeight)
            make.leading.top.trailing.equalToSuperview()
        }
        
        view.addSubview(basicInfoSectionView)
        basicInfoSectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(statusBarSection.snp.bottom)
        }
        
        basicInfoSectionView.addSubview(basicInfoTopSectionView)
        basicInfoTopSectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        basicInfoTopSectionView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.leading.top.bottom.equalToSuperview()
        }
        
        basicInfoTopSectionView.addSubview(basicAssetInfoSectionView)
        basicAssetInfoSectionView.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(32)
            make.top.bottom.equalTo(avatarImageView)
            make.trailing.equalToSuperview()
        }

        basicAssetInfoSectionView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }

        basicAssetInfoSectionView.addSubview(assetSumLabel)
        assetSumLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(userNameLabel.snp.bottom).offset(12)
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

        followSectionView.addSubview(followingSectionView)
        followingSectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.leading.equalTo(followerSectionView.snp.trailing)
            make.top.bottom.trailing.equalToSuperview()
        }

        followingSectionView.addSubview(followingLabel)
        followingLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }

        followingSectionView.addSubview(followingTitleLabel)
        followingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(followingLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(tabButtonSectionView)
        tabButtonSectionView.snp.makeConstraints { make in
            make.top.equalTo(basicInfoSectionView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.height.equalTo(50)
        }
        
        // 4 + 6 + 6 + + 1 + 6 + 6 + 1 + 6 + 6 + 4
        let allPadding = 46
        let screenWidth = UIScreen.main.bounds.width
        let tabButtonWidth = (screenWidth - CGFloat(allPadding)) / 3
        
        tabButtonSectionView.addSubview(portfolioTabButton)
        portfolioTabButton.snp.makeConstraints { make in
            make.width.equalTo(tabButtonWidth)
            make.leading.equalToSuperview().offset(6)
            make.top.bottom.equalToSuperview()
        }
        
        tabButtonSectionView.addSubview(tabButtonSeparatorViewLeft)
        tabButtonSeparatorViewLeft.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.leading.equalTo(portfolioTabButton.snp.trailing).offset(6)
            make.top.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().offset(-13)
        }
        
        tabButtonSectionView.addSubview(tradingPerformanceTabButton)
        tradingPerformanceTabButton.snp.makeConstraints { make in
            make.width.equalTo(tabButtonWidth)
            make.leading.equalTo(tabButtonSeparatorViewLeft.snp.trailing).offset(6)
            make.top.bottom.equalToSuperview()
        }
        
        tabButtonSectionView.addSubview(tabButtonSeparatorViewRight)
        tabButtonSeparatorViewRight.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.leading.equalTo(tradingPerformanceTabButton.snp.trailing).offset(6)
            make.top.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().offset(-13)
        }
        
        tabButtonSectionView.addSubview(followingPortfolioTabButton)
        followingPortfolioTabButton.snp.makeConstraints { make in
            make.width.equalTo(tabButtonWidth)
            make.leading.equalTo(tabButtonSeparatorViewRight.snp.trailing).offset(6)
            make.trailing.equalToSuperview().offset(-6)
            make.top.bottom.equalToSuperview()
        }
        
        view.addSubview(pagerView)
        pagerView.snp.makeConstraints { make in
            make.top.equalTo(tabButtonSectionView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        pagerView.addSubview(pnlSectionView)
        pnlSectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func setupBinding() {
//        followerSection.rx
//            .tapGesture()
//            .when(.recognized)
//            .map { _ in true }
//            .subscribe(onNext: { [weak self] isDefaultPageFollower in
//                guard let self = self else { return }
//                self.mainCoordinator.showFollow(isDefaultPageFollower: isDefaultPageFollower, followViewModel: self.followViewModel)
//            })
//            .disposed(by: disposeBag)
//
//        followingSection.rx
//            .tapGesture()
//            .when(.recognized)
//            .map { _ in false }
//            .subscribe(onNext: { [weak self] isDefaultPageFollower in
//                guard let self = self else { return }
//                self.mainCoordinator.showFollow(isDefaultPageFollower: isDefaultPageFollower, followViewModel: self.followViewModel)
//            })
//            .disposed(by: disposeBag)
//
//        portfolioView.historyButton.rx
//            .tap
//            .bind(to: viewModel.inputs.historyBtnTap)
//            .disposed(by: disposeBag)
//
//        portfolioView.refreshControl.rx
//            .controlEvent(.valueChanged)
//            .bind(to: viewModel.inputs.portfolioPull)
//            .disposed(by: disposeBag)
//
//        pnlView.refreshControl.rx
//            .controlEvent(.valueChanged)
//            .bind(to: viewModel.inputs.pnlPull)
//            .disposed(by: disposeBag)
//
//        followingPortfolioView.refreshControl.rx
//            .controlEvent(.valueChanged)
//            .bind(to: viewModel.inputs.followingPortfolioPull)
//            .disposed(by: disposeBag)
//
//        viewModel.outputs
//            .profit
//            .emit(to: assetProfitLabel.rx.attributedText)
//            .disposed(by: disposeBag)
//
//        viewModel.outputs
//            .sum
//            .emit(to: assetSumLabel.rx.attributedText)
//            .disposed(by: disposeBag)
//
//        followViewModel.outputs
//            .user
//            .observe(on: MainScheduler.asyncInstance)
//            .subscribe(onNext: { [weak self] user in
//                self?.setupUser(user: user)
//            })
//            .disposed(by: disposeBag)
//
//        followViewModel.outputs
//            .followerAmount
//            .map { String($0) }
//            .emit(to: followerLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        followViewModel.outputs
//            .followingAmount
//            .map { String($0) }
//            .emit(to: followingLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel.outputs
//            .portfolio
//            .map { [AnimatableSectionModel<String, PortfolioAssetViewData>(model: "", items: $0)] }
//            .drive(
//                portfolioView.tableView.rx.items(
//                    dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, PortfolioAssetViewData>>(
//                        configureCell: { dataSource, tableView, indexPath, item in
//                            let cell = tableView.dequeueReusableCell(
//                                withIdentifier: PortfolioAssetTableViewCell.identifier, for: indexPath
//                            ) as! PortfolioAssetTableViewCell
//                            cell.bind(item)
//                            return cell
//                        }
//                    )
//                )
//            )
//            .disposed(by: disposeBag)
//
//        viewModel.outputs
//            .pnl
//            .emit(onNext: pnlView.bind)
//            .disposed(by: disposeBag)
//
//        viewModel.outputs
//            .followingPortfolio
//            .map { [AnimatableSectionModel<String, PortfolioAssetViewData>(model: "", items: $0)] }
//            .drive(
//                followingPortfolioView.tableView.rx.items(
//                    dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, PortfolioAssetViewData>>(
//                        configureCell: { dataSource, tableView, indexPath, item in
//                            let cell = tableView.dequeueReusableCell(
//                                withIdentifier: FollowingPortfolioAssetTableViewCell.identifier, for: indexPath
//                            ) as! FollowingPortfolioAssetTableViewCell
//                            cell.bind(item)
//                            return cell
//                        }
//                    )
//                )
//            )
//            .disposed(by: disposeBag)
//
//        viewModel.outputs
//            .portfolioRefresh
//            .emit(onNext: { [unowned self] bool in
//                if bool {
//                    portfolioView.refreshControl.beginRefreshing(in: portfolioView.tableView)
//                } else {
//                    portfolioView.refreshControl.endRefreshing()
//                }
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs
//            .pnlRefresh
//            .emit(to: pnlView.refreshControl.rx.isRefreshing)
//            .disposed(by: disposeBag)
//
//        viewModel.outputs
//            .followingPortfolioRefresh
//            .emit(onNext: { [unowned self] bool in
//                if bool {
//                    followingPortfolioView.refreshControl.beginRefreshing(in: followingPortfolioView.tableView)
//                } else {
//                    followingPortfolioView.refreshControl.endRefreshing()
//                }
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs
//            .uiEvent
//            .asSignal()
//            .emit(onNext: { [weak self] event in
//                self?.handleUiEvent(event)
//            })
//            .disposed(by: disposeBag)
        
//        statisticsViewModel.errorMessageObservable
//            .observe(on: MainScheduler.asyncInstance)
//            .subscribe(onNext: { [weak self] msg in
//                self?.portfolioView.refreshControl.endRefreshing()
//                self?.promptAlert(message: msg)
//            })
//            .disposed(by: disposeBag)
    }
    
    private let statusBarSection = UIView()
    private let basicInfoSectionView = UIView()
    private let basicInfoTopSectionView = UIView()
    private let avatarImageView = UIImageView()
    private let basicAssetInfoSectionView = UIView()
    private let userNameLabel = UILabel()
    private let assetSumLabel = UILabel()
    private let assetSumTitleLabel = UILabel()
    private let assetDayChangeLabel = UILabel()
    private let basicInfoSectionSeparatorView = UIView()
    private let basicInfoBottomSectionView = UIView()
    private let followSectionView = UIView()
    private let followerSectionView = UIView()
    private let followerLabel = UILabel()
    private let followerTitleLabel = UILabel()
    private let followingSectionView = UIView()
    private let followingLabel = UILabel()
    private let followingTitleLabel = UILabel()
    private let tabButtonSectionView = UIView()
    private let portfolioTabButton = PortfolioTabButton()
    private let tabButtonSeparatorViewLeft = UIView()
    private let tradingPerformanceTabButton = PortfolioTabButton()
    private let tabButtonSeparatorViewRight = UIView()
    private let followingPortfolioTabButton = PortfolioTabButton()
    
    private let pagerView = UIView()
//    private let portfolioView = PortfolioSectionView()
    private let pnlSectionView = PNLSectionView()
    

//    private let radioGroup = RadioButtonGroup()
//    private lazy var portfolioView = PortfolioView()
//    private lazy var portfolioViewCell: PagedViewCell = {
//        let cell = PagedViewCell()
//        cell.setView(view: portfolioView)
//        return cell
//    }()
//    private lazy var pnlView = PNLView()
//    private lazy var pnlViewCell: PagedViewCell = {
//        let cell = PagedViewCell()
//        cell.setView(view: pnlView)
//        return cell
//    }()
//    private lazy var followingPortfolioView = FollowingPortfolioView()
//    private lazy var followingPortfolioViewCell: PagedViewCell = {
//        let cell = PagedViewCell()
//        cell.setView(view: followingPortfolioView)
//        return cell
//    }()
//    private lazy var pagedView = PagedView(pages: [portfolioViewCell, pnlViewCell, followingPortfolioView])
}

//extension PortfolioViewController {
//    func handleUiEvent(_ event: PortfolioViewUiEvent) {
//        switch event {
//        case .history:
//            break
////            mainCoordinator.showTradeHistoryBy(userId: user?.userId)
//        case .back:
//            pop()
//        }
//    }
//}
//
//extension PortfolioViewController: PortfolioViewDelegate {
//    func portfolioView(_ view: PortfolioView, filteredExchange exchange: String) {
//        let exchangeType = ExchangeType.init(rawValue: exchange)!
//        viewModel.inputs
//            .exchangeFilter
//            .accept(exchangeType)
//    }
//    
//    func portfolioView(_ view: PortfolioView, filteredType type: String) {
//        let filterType = PortfolioType.init(rawValue: type)!
//        viewModel.inputs
//            .portfolioType
//            .accept(filterType)
//    }
//    
//    func onTapHistory(_ view: PortfolioView) {
//        viewModel.inputs
//            .historyBtnTap
//            .accept(())
//    }
//}
//
//extension PortfolioViewController: PNLViewDelegate {
//    func onPeriodFiltered(period: String) {
//        viewModel.inputs.pnlPeriod.accept(PNLPeriod.init(rawValue: period)!)
//    }
//}
//
//extension PortfolioViewController: FollowingPortfolioViewDelegate {
//    func followingPortfolioView(_ view: FollowingPortfolioView, filteredExchange exchange: String) {
//        let exchangeType = ExchangeType.init(rawValue: exchange)!
//        viewModel.inputs
//            .followingPortfolioExchangeFilter
//            .accept(exchangeType)
//    }
//    
//    func followingPortfolioView(_ view: FollowingPortfolioView, filteredType type: String) {
//        let filterType = PortfolioType.init(rawValue: type)!
//        viewModel.inputs
//            .followingPortfolioType
//            .accept(filterType)
//    }
//}
//
//extension PortfolioViewController: RadioButtonGroupDelegate {
//    func onClicked(radioButton: RadioButton) {
////        if radioButton == protfolioButton {
////            pagedView.moveToPage(at: 0)
////        } else if radioButton == pnlButton {
////            if let user = user {
////                EventTracker.Builder()
////                    .setProperty(name: .USER_B, value: user.userId)
////                    .logEvent(.CHECK_OTHERS_PROFILE_PERFORMANCE)
////            } else {
////                EventTracker.Builder()
////                    .logEvent(.CHECK_PERSONAL_PAGE_PERFORMANCE)
////            }
////            pagedView.moveToPage(at: 1)
////        } else {
////            if let user = user {
////                EventTracker.Builder()
////                    .setProperty(name: .USER_B, value: user.userId)
////                    .logEvent(.CHECK_OTHERS_PROFILE_FOLLOWED_PORTFOLIO)
////            } else {
////                EventTracker.Builder()
////                    .logEvent(.CHECK_PERSONAL_PAGE_FOLLOWED_PORTFOLIO)
////            }
////            pagedView.moveToPage(at: 2)
////        }
//    }
//}
