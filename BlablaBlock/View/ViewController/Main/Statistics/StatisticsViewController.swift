//
//  StatisticsViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/23.
//

import UIKit
import Resolver
import RxCocoa
import RxSwift

final class StatisticsViewController: BaseViewController {
    
    @Injected var mainCoordinator: MainCoordinator
    @Injected var viewModel: StatisticsViewModelType
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
    private lazy var followingPortfolioView = PortfolioView()
    private lazy var followingPortfolioViewCell: PagedViewCell = {
        let cell = PagedViewCell()
        cell.setView(view: followingPortfolioView)
        return cell
    }()
    private lazy var pagedView = PagedView(pages: [portfolioViewCell, pnlViewCell, followingPortfolioView])
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupBinding()
        viewModel.outputs.user.accept(user)
        viewModel.inputs.viewDidLoad.accept(())
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
        followingPortfolioView.historyButton.isHidden = true
        followingPortfolioView.backButton.isHidden = true
        radioGroup.delegate = self
        radioGroup.add(protfolioButton)
        radioGroup.add(pnlButton)
        radioGroup.add(followingButton)
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
            shareButton.isHidden = false
            portfolioView.backButton.isHidden = false
        } else {
            nameLabel.text = keychainUser[.userName]
            shareButton.isHidden = true
            portfolioView.backButton.isHidden = true
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

        shareButton.rx
            .tap
            .bind(to: followViewModel.inputs.followBtnTap)
            .disposed(by: disposeBag)

        portfolioView.historyButton.rx
            .tap
            .bind(to: viewModel.inputs.historyBtnTap)
            .disposed(by: disposeBag)

        portfolioView.refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.refresh)
            .disposed(by: disposeBag)

        pnlView.refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.refresh)
            .disposed(by: disposeBag)
        
        followingPortfolioView.refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.followingPortfolioPull)
            .disposed(by: disposeBag)
        
        viewModel.outputs
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
            .map { $0.profit }
            .emit(to: assetProfitLabel.rx.attributedText)
            .disposed(by: disposeBag)

        viewModel.outputs
            .portfolio
            .map { $0.sum }
            .emit(to: assetSumLabel.rx.attributedText)
            .disposed(by: disposeBag)

        viewModel.outputs
            .portfolio
            .asObservable()
            .map { $0.assets }
            .bind(
                to: portfolioView.tableView.rx.items(
                    cellIdentifier: "ExchangeListTableViewCell",
                    cellType: ExchangeListTableViewCell.self
                ),
                curriedArgument: { (row, element, cell) in
                    cell.bind(element)
                }
            )
            .disposed(by: disposeBag)

        viewModel.outputs
            .pnl
            .emit(onNext: pnlView.bind)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .followingPortfolio
            .asObservable()
            .map { $0.assets }
            .bind(
                to: followingPortfolioView.tableView.rx.items(
                    cellIdentifier: "ExchangeListTableViewCell",
                    cellType: ExchangeListTableViewCell.self
                ),
                curriedArgument: { (row, element, cell) in
                    cell.bind(element)
                }
            )
            .disposed(by: disposeBag)

        viewModel.outputs
            .portfolioRefresh
            .emit(to: portfolioView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel.outputs
            .pnlRefresh
            .emit(to: pnlView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .followingPortfolioRefresh
            .emit(to: followingPortfolioView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel.outputs
            .uiEvent
            .subscribe(onNext: { [weak self] event in
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

extension StatisticsViewController {
    func handleUiEvent(_ event: StatisticsViewUiEvent) {
        switch event {
        case .history:
            mainCoordinator.showTradeHistory(userId: user?.userId)
        case .back:
            pop()
        }
    }
}

extension StatisticsViewController: PortfolioViewDelegate {
    func onExchangeFiltered(_ view: PortfolioView, exchange: String) {
        let exchangeType = ExchangeType.init(rawValue: exchange)!
        if view == portfolioView {
            viewModel.inputs.exchangeFilter.accept(exchangeType)
        } else {
            viewModel.inputs.followingPortfolioExchangeFilter.accept(exchangeType)
        }
    }
    
    func onPortfolioTypeFiltered(_ view: PortfolioView, type: String) {
        let filterType = PortfolioType.init(rawValue: type)!
        if view == portfolioView {
            viewModel.inputs.portfolioType.accept(filterType)
        } else {
            viewModel.inputs.followingPortfolioType.accept(filterType)
        }
    }
    
    func onTapHistory(_ view: PortfolioView) {
        if view == portfolioView {
            viewModel.outputs.uiEvent.accept(.history)
        } else {
            
        }
    }
    
    func onTapBack() {
        viewModel.outputs.uiEvent.accept(.back)
    }
}

extension StatisticsViewController: PNLViewDelegate {
    func onPeriodFiltered(period: String) {
        viewModel.inputs.pnlPeriod.accept(PNLPeriod.init(rawValue: period)!)
    }
}

extension StatisticsViewController: RadioButtonGroupDelegate {
    func onClicked(radioButton: RadioButton) {
        if radioButton == protfolioButton {
            pagedView.moveToPage(at: 0)
        } else if radioButton == pnlButton {
            pagedView.moveToPage(at: 1)
        } else {
            pagedView.moveToPage(at: 2)
        }
    }
}
