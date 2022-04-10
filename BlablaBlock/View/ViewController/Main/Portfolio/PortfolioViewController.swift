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
import RxDataSources

final class PortfolioViewController: BaseViewController {
    
    @Injected var mainCoordinator: MainCoordinator
    @Injected var viewModel: PortfolioViewModelType
    @Injected var followViewModel: FollowViewModelType
    var user: UserApiData!

    private let radioGroup = RadioButtonGroup()
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var assetProfitLabel: UILabel!
    @IBOutlet weak var assetSumLabel: UILabel!
    @IBOutlet weak var followAndShareSection: UIView!
    @IBOutlet weak var followerSection: UIView!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingSection: UIView!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var shareButton: ColorButton!
    @IBOutlet weak var protfolioButton: ColorButton!
    @IBOutlet weak var pnlButton: ColorButton!
    @IBOutlet weak var followingButton: ColorButton!
    @IBOutlet weak var pagerSectionView: UIView!
    @IBOutlet weak var backButton: ColorButton!
    private lazy var portfolioView = PortfolioView()
    private lazy var portfolioViewCell: PagedViewCell = {
        let cell = PagedViewCell()
        cell.setView(view: portfolioView)
        return cell
    }()
    private lazy var pnlView = PNLView()
    private lazy var pnlViewCell: PagedViewCell = {
        let cell = PagedViewCell()
        cell.setView(view: pnlView)
        return cell
    }()
    private lazy var followingPortfolioView = FollowingPortfolioView()
    private lazy var followingPortfolioViewCell: PagedViewCell = {
        let cell = PagedViewCell()
        cell.setView(view: followingPortfolioView)
        return cell
    }()
    private lazy var pagedView = PagedView(pages: [portfolioViewCell, pnlViewCell, followingPortfolioView])
    
    deinit {
        pnlView.semaphore?.signal()
        Timber.i("\(type(of: self)) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupBinding()
        viewModel.outputs.user.accept(user)
        followViewModel.inputs.user.accept(user)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.makeCircle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        followViewModel.inputs.viewWillAppear.accept(())
    }
    
    private func setupUI() {
        portfolioView.delegate = self
        pnlView.delegate = self
        followingPortfolioView.delegate = self
        radioGroup.delegate = self
        radioGroup.add(protfolioButton)
        radioGroup.add(pnlButton)
        radioGroup.add(followingButton)
        if user == nil {
            shareButton.isHidden = true
            backButton.isHidden = true
        } else {
            shareButton.isHidden = false
            shareButton.rx
                .tap
                .bind(to: followViewModel.inputs.followBtnTap)
                .disposed(by: disposeBag)
            
            backButton.isHidden = false
            backButton.rx
                .tap
                .asSignal()
                .map { PortfolioViewUiEvent.back }
                .emit(to: viewModel.outputs.uiEvent)
                .disposed(by: disposeBag)
        }
    }
    
    private func setupUser(user: UserApiData?) {
        if let user = user {
            nameLabel.text = user.name
            if user.isFollow {
                shareButton.setTitle("追蹤中", for: .normal)
                shareButton.isSelected = true
            } else {
                shareButton.setTitle("追蹤", for: .normal)
                shareButton.isSelected = false
            }
        } else {
            nameLabel.text = keychainUser[.userName]
        }
    }
    
    private func setupLayout() {
        pagerSectionView.addSubview(pagedView)
        pagerSectionView.snp.makeConstraints { make in
            make.edges.equalTo(pagedView)
        }
    }
    
    private func setupBinding() {
        followerSection.rx
            .tapGesture()
            .when(.recognized)
            .map { _ in true }
            .subscribe(onNext: { [weak self] isDefaultPageFollower in
                guard let self = self else { return }
                self.mainCoordinator.showFollow(isDefaultPageFollower: isDefaultPageFollower, followViewModel: self.followViewModel)
            })
            .disposed(by: disposeBag)

        followingSection.rx
            .tapGesture()
            .when(.recognized)
            .map { _ in false }
            .subscribe(onNext: { [weak self] isDefaultPageFollower in
                guard let self = self else { return }
                self.mainCoordinator.showFollow(isDefaultPageFollower: isDefaultPageFollower, followViewModel: self.followViewModel)
            })
            .disposed(by: disposeBag)

        portfolioView.historyButton.rx
            .tap
            .bind(to: viewModel.inputs.historyBtnTap)
            .disposed(by: disposeBag)

        portfolioView.refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.portfolioPull)
            .disposed(by: disposeBag)

        pnlView.refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.pnlPull)
            .disposed(by: disposeBag)
        
        followingPortfolioView.refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.followingPortfolioPull)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .profit
            .emit(to: assetProfitLabel.rx.attributedText)
            .disposed(by: disposeBag)

        viewModel.outputs
            .sum
            .emit(to: assetSumLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        followViewModel.outputs
            .user
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] user in
                self?.setupUser(user: user)
            })
            .disposed(by: disposeBag)
        
        followViewModel.outputs
            .followerAmount
            .map { String($0) }
            .emit(to: followerLabel.rx.text)
            .disposed(by: disposeBag)
        
        followViewModel.outputs
            .followingAmount
            .map { String($0) }
            .emit(to: followingLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs
            .portfolio
            .map { [AnimatableSectionModel<String, PortfolioAssetViewData>(model: "", items: $0)] }
            .drive(
                portfolioView.tableView.rx.items(
                    dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, PortfolioAssetViewData>>(
                        configureCell: { dataSource, tableView, indexPath, item in
                            let cell = tableView.dequeueReusableCell(
                                withIdentifier: PortfolioAssetTableViewCell.identifier, for: indexPath
                            ) as! PortfolioAssetTableViewCell
                            cell.bind(item)
                            return cell
                        }
                    )
                )
            )
            .disposed(by: disposeBag)

        viewModel.outputs
            .pnl
            .emit(onNext: pnlView.bind)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .followingPortfolio
            .map { [AnimatableSectionModel<String, PortfolioAssetViewData>(model: "", items: $0)] }
            .drive(
                followingPortfolioView.tableView.rx.items(
                    dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, PortfolioAssetViewData>>(
                        configureCell: { dataSource, tableView, indexPath, item in
                            let cell = tableView.dequeueReusableCell(
                                withIdentifier: FollowingPortfolioAssetTableViewCell.identifier, for: indexPath
                            ) as! FollowingPortfolioAssetTableViewCell
                            cell.bind(item)
                            return cell
                        }
                    )
                )
            )
            .disposed(by: disposeBag)

        viewModel.outputs
            .portfolioRefresh
            .emit(onNext: { [unowned self] bool in
                if bool {
                    portfolioView.refreshControl.beginRefreshing(in: portfolioView.tableView)
                } else {
                    portfolioView.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs
            .pnlRefresh
            .emit(to: pnlView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .followingPortfolioRefresh
            .emit(onNext: { [unowned self] bool in
                if bool {
                    followingPortfolioView.refreshControl.beginRefreshing(in: followingPortfolioView.tableView)
                } else {
                    followingPortfolioView.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs
            .uiEvent
            .asSignal()
            .emit(onNext: { [weak self] event in
                self?.handleUiEvent(event)
            })
            .disposed(by: disposeBag)
        
//        statisticsViewModel.errorMessageObservable
//            .observe(on: MainScheduler.asyncInstance)
//            .subscribe(onNext: { [weak self] msg in
//                self?.portfolioView.refreshControl.endRefreshing()
//                self?.promptAlert(message: msg)
//            })
//            .disposed(by: disposeBag)
    }
}

extension PortfolioViewController {
    func handleUiEvent(_ event: PortfolioViewUiEvent) {
        switch event {
        case .history:
            mainCoordinator.showTradeHistoryBy(userId: user?.userId)
        case .back:
            pop()
        }
    }
}

extension PortfolioViewController: PortfolioViewDelegate {
    func portfolioView(_ view: PortfolioView, filteredExchange exchange: String) {
        let exchangeType = ExchangeType.init(rawValue: exchange)!
        viewModel.inputs
            .exchangeFilter
            .accept(exchangeType)
    }
    
    func portfolioView(_ view: PortfolioView, filteredType type: String) {
        let filterType = PortfolioType.init(rawValue: type)!
        viewModel.inputs
            .portfolioType
            .accept(filterType)
    }
    
    func onTapHistory(_ view: PortfolioView) {
        viewModel.inputs
            .historyBtnTap
            .accept(())
    }
}

extension PortfolioViewController: PNLViewDelegate {
    func onPeriodFiltered(period: String) {
        viewModel.inputs.pnlPeriod.accept(PNLPeriod.init(rawValue: period)!)
    }
}

extension PortfolioViewController: FollowingPortfolioViewDelegate {
    func followingPortfolioView(_ view: FollowingPortfolioView, filteredExchange exchange: String) {
        let exchangeType = ExchangeType.init(rawValue: exchange)!
        viewModel.inputs
            .followingPortfolioExchangeFilter
            .accept(exchangeType)
    }
    
    func followingPortfolioView(_ view: FollowingPortfolioView, filteredType type: String) {
        let filterType = PortfolioType.init(rawValue: type)!
        viewModel.inputs
            .followingPortfolioType
            .accept(filterType)
    }
}

extension PortfolioViewController: RadioButtonGroupDelegate {
    func onClicked(radioButton: RadioButton) {
        if radioButton == protfolioButton {
            pagedView.moveToPage(at: 0)
        } else if radioButton == pnlButton {
            if let user = user {
                EventTracker.Builder()
                    .setProperty(name: .USER_B, value: user.userId)
                    .logEvent(.CHECK_OTHERS_PROFILE_PERFORMANCE)
            } else {
                EventTracker.Builder()
                    .logEvent(.CHECK_PERSONAL_PAGE_PERFORMANCE)
            }
            pagedView.moveToPage(at: 1)
        } else {
            if let user = user {
                EventTracker.Builder()
                    .setProperty(name: .USER_B, value: user.userId)
                    .logEvent(.CHECK_OTHERS_PROFILE_FOLLOWED_PORTFOLIO)
            } else {
                EventTracker.Builder()
                    .logEvent(.CHECK_PERSONAL_PAGE_FOLLOWED_PORTFOLIO)
            }
            pagedView.moveToPage(at: 2)
        }
    }
}
