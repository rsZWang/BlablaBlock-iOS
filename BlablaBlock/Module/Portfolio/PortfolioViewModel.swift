//
//  PortfolioViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Resolver
import RxCocoa
import RxSwift

public protocol PortfolioViewModelInputs: AnyObject {
    var user: BehaviorRelay<UserApiData?> { get }
    var viewWillAppear: PublishRelay<()> { get }
    var historyBtnTap: PublishRelay<()> { get }
    var portfolioExchangeFilter: BehaviorRelay<ExchangeType> { get }
    var portfolioTypeFilter: BehaviorRelay<PortfolioType> { get }
    var portfolioPull: PublishRelay<()> { get }
    var pnlPeriodFilter: BehaviorRelay<PNLPeriod> { get }
    var pnlPull: PublishRelay<()> { get }
    var followingPortfolioExchangeFilter: BehaviorRelay<ExchangeType> { get }
    var followingPortfolioTypeFilter: BehaviorRelay<PortfolioType> { get }
    var followingPortfolioPull: PublishRelay<()> { get }
}

public protocol PortfolioViewModelOutputs: AnyObject {
    var sum: Signal<NSAttributedString> { get }
    var profit: Signal<Double> { get }
    var portfolio: Driver<[PortfolioAssetViewData]> { get }
    var portfolioRefresh: Signal<Bool> { get }
    var pnl: Signal<PNLApiData> { get }
    var pnlRefresh: Signal<Bool> { get }
    var followingPortfolio: Driver<[PortfolioAssetViewData]> { get }
    var followingPortfolioRefresh: Signal<Bool> { get }
    var uiEvent: PublishRelay<PortfolioViewUiEvent> { get }
}

public protocol PortfolioViewModelType: AnyObject {
    var inputs: PortfolioViewModelInputs { get }
    var outputs: PortfolioViewModelOutputs { get }
}

public enum PortfolioViewUiEvent {
    case back
    case history(Int)
}

final class PortfolioViewModel:
    BaseViewModel,
    PortfolioViewModelInputs,
    PortfolioViewModelOutputs,
    PortfolioViewModelType
{
    // MARK: - inputs
    var user: BehaviorRelay<UserApiData?>
    var viewWillAppear: PublishRelay<()>
    var historyBtnTap: PublishRelay<()>
    var portfolioExchangeFilter: BehaviorRelay<ExchangeType>
    var portfolioTypeFilter: BehaviorRelay<PortfolioType>
    var portfolioPull: PublishRelay<()>
    var pnlPeriodFilter: BehaviorRelay<PNLPeriod>
    var pnlPull: PublishRelay<()>
    var followingPortfolioExchangeFilter: BehaviorRelay<ExchangeType>
    var followingPortfolioTypeFilter: BehaviorRelay<PortfolioType>
    var followingPortfolioPull: PublishRelay<()>
    
    // MARK: - outpus
    var sum: Signal<NSAttributedString>
    var profit: Signal<Double>
    var portfolio: Driver<[PortfolioAssetViewData]>
    var portfolioRefresh: Signal<Bool>
    var pnl: Signal<PNLApiData>
    var pnlRefresh: Signal<Bool>
    var followingPortfolio: Driver<[PortfolioAssetViewData]>
    var followingPortfolioRefresh: Signal<Bool>
    var uiEvent: PublishRelay<PortfolioViewUiEvent>
    
    var inputs: PortfolioViewModelInputs { self }
    var outputs: PortfolioViewModelOutputs { self }
    
    // MARK: - internals
//    private let portfolioViewDataCache = BehaviorRelay<PortfolioApiData?>(value: nil)
//    private let pnlCache = BehaviorRelay<PNLApiData?>(value: nil)
//    private let followingPortfolioViewDataCache = BehaviorRelay<FollowingPortfolioApi?>(value: nil)
    private lazy var isSelf: Bool = { user.value == nil }()
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let user = BehaviorRelay<UserApiData?>(value: nil)
        let viewWillAppear = PublishRelay<()>()
        let historyBtnTap = PublishRelay<()>()
        let portfolioExchangeFilter = BehaviorRelay<ExchangeType>(value: .all)
        let portfolioTypeFilter = BehaviorRelay<PortfolioType>(value: .all)
        let pnlPeriodFilter = BehaviorRelay<PNLPeriod>(value: .all)
        let followingPortfolioExchangeFilter = BehaviorRelay<ExchangeType>(value: .all)
        let followingPortfolioTypeFilter = BehaviorRelay<PortfolioType>(value: .all)
        let portfolioPull = PublishRelay<()>()
        let pnlPull = PublishRelay<()>()
        let followingPortfolioPull = PublishRelay<()>()
        
        let sum = PublishRelay<NSAttributedString>()
        let profit = PublishRelay<Double>()
        let portfolio = PublishRelay<[PortfolioAssetViewData]>()
        let portfolioRefresh = PublishRelay<Bool>()
        let pnl = PublishRelay<PNLApiData>()
        let pnlRefresh = PublishRelay<Bool>()
        let followingPortfolio = PublishRelay<[PortfolioAssetViewData]>()
        let followingPortfolioRefresh = PublishRelay<Bool>()
        let uiEvent = PublishRelay<PortfolioViewUiEvent>()
        
        self.user = user
        self.viewWillAppear = viewWillAppear
        self.historyBtnTap = historyBtnTap
        self.portfolioExchangeFilter = portfolioExchangeFilter
        self.portfolioTypeFilter = portfolioTypeFilter
        self.pnlPeriodFilter = pnlPeriodFilter
        self.followingPortfolioExchangeFilter = followingPortfolioExchangeFilter
        self.followingPortfolioTypeFilter = followingPortfolioTypeFilter
        self.portfolioPull = portfolioPull
        self.pnlPull = pnlPull
        self.followingPortfolioPull = followingPortfolioPull
        
        self.sum = sum.asSignal()
        self.profit = profit.asSignal()
        self.portfolio = portfolio.asDriver(onErrorJustReturn: [])
        self.portfolioRefresh = portfolioRefresh.asSignal()
        self.pnl = pnl.asSignal()
        self.pnlRefresh = pnlRefresh.asSignal()
        self.followingPortfolio = followingPortfolio.asDriver(onErrorJustReturn: [])
        self.followingPortfolioRefresh = followingPortfolioRefresh.asSignal()
        self.uiEvent = uiEvent
        
        super.init()

        let refreshPortfolioAndPNL = PublishRelay<()>()
        
        viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                portfolioRefresh.accept(true)
                pnlRefresh.accept(true)
                followingPortfolioRefresh.accept(true)
                refreshPortfolioAndPNL.accept(())
                self?.getFollowingPortfolio(
                    followingProtfolioExchange: followingPortfolioExchangeFilter.value.rawValue,
                    followingProtfolio: followingPortfolio,
                    followingPortfolioRefresh: followingPortfolioRefresh
                )
            })
            .disposed(by: disposeBag)
        
        historyBtnTap
            .subscribe(onNext: {
                Timber.i("onHistoryTap")
                let userId: Int
                if let user = user.value {
                    userId = user.userId
                    EventTracker.Builder()
                        .setProperty(name: .USER_B, value: userId)
                        .logEvent(.CHECK_OTHERS_PROFILE_TRADE_RECORD)
                } else {
                    userId = Int(keychainUser[.userId]!)!
                    EventTracker.Builder()
                        .logEvent(.CHECK_PERSONAL_PAGE_TRADE_RECORD)
                }
                uiEvent.accept(.history(userId))
            })
            .disposed(by: disposeBag)
        
        portfolioExchangeFilter
            .skip(1)
            .map { _ in () }
            .bind(to: portfolioPull)
            .disposed(by: disposeBag)
        
        portfolioPull
            .subscribe(onNext: {
                EventTracker.Builder()
                    .logEvent(.REFRESH_PERSONAL_PAGE_PORTFOLIO)
                refreshPortfolioAndPNL.accept(())
            })
            .disposed(by: disposeBag)
        
        pnlPeriodFilter
            .skip(1)
            .map { _ in () }
            .bind(to: pnlPull)
            .disposed(by: disposeBag)
        
        pnlPull
            .subscribe(onNext: {
                EventTracker.Builder()
                    .logEvent(.REFRESH_PERSONAL_PAGE_PERFORMANCE)
                refreshPortfolioAndPNL.accept(())
            })
            .disposed(by: disposeBag)
        
        refreshPortfolioAndPNL
            .subscribe(onNext: { [weak self] in
                self?.getPortfolio(
                    exchange: portfolioExchangeFilter.value.rawValue,
                    sum: sum,
                    profit: profit,
                    protfolio: portfolio,
                    portfolioRefresh: portfolioRefresh
                )
                self?.getPNL(
                    period: pnlPeriodFilter.value.rawValue,
                    pnl: pnl,
                    pnlRefresh: pnlRefresh
                )
            })
            .disposed(by: disposeBag)
        
        // MARK: - following
        
        followingPortfolioPull
            .subscribe(onNext: { [weak self] in
                EventTracker.Builder()
                    .logEvent(.REFRESH_PERSONAL_PAGE_FOLLOWED_PORTFOLIO)
                self?.getFollowingPortfolio(
                    followingProtfolioExchange: followingPortfolioExchangeFilter.value.rawValue,
                    followingProtfolio: followingPortfolio,
                    followingPortfolioRefresh: followingPortfolioRefresh
                )
            })
            .disposed(by: disposeBag)
        
        followingPortfolioExchangeFilter
            .skip(1)
            .map { _ in () }
            .bind(to: followingPortfolioPull)
            .disposed(by: disposeBag)
    }
}

private extension PortfolioViewModel {    
    func getPortfolio(
        exchange: String,
        sum: PublishRelay<NSAttributedString>,
        profit: PublishRelay<Double>,
        protfolio: PublishRelay<[PortfolioAssetViewData]>,
        portfolioRefresh: PublishRelay<Bool>
    ) {
        let userId = user.value?.userId ?? Int(keychainUser[.userId]!)!
        UserService.getPortfolioByID(userId: userId, exchange: exchange)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(portfolio):
                        sum.accept(portfolio.data.getAssetSumString())
                        profit.accept(portfolio.data.percentage ?? 0)
                        protfolio.accept(portfolio.data.getAssetsViewData())
                    case let .failure(responseFailure):
                        if responseFailure.code == 1006 {
                            
                        } else {
                            self?.errorCodeHandler(responseFailure)
                        }
                    }
                    portfolioRefresh.accept(false)
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                    portfolioRefresh.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func getPNL(
        period: String,
        pnl: PublishRelay<PNLApiData>,
        pnlRefresh: PublishRelay<Bool>
    ) {
        let userId = user.value?.userId ?? Int(keychainUser[.userId]!)!
        UserService.getPNLByID(userId: userId, exchange: "all", period: period)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(pnlData):
                        pnl.accept(pnlData.data)
                    case let .failure(responseFailure):
                        if responseFailure.code == 1007 {

                        } else {
                            self?.errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
                        }
                    }
                    pnlRefresh.accept(false)
                }, onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                    pnlRefresh.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func getFollowingPortfolio(
        followingProtfolioExchange: String,
        followingProtfolio: PublishRelay<[PortfolioAssetViewData]>,
        followingPortfolioRefresh: PublishRelay<Bool>
    ) {
        if let userId = user.value?.userId ?? Int(keychainUser[.userId] ?? "") {
            UserService.getFollowPortfolioByID(userId: userId, exchange: followingProtfolioExchange)
                .request()
                .subscribe(
                    onSuccess: { [weak self] response in
                        switch response {
                        case let .success(portfolio):
                            followingProtfolio.accept(portfolio.getAssetsViewData())
                        case let .failure(responseFailure):
                            if responseFailure.code == 1006 {
                                
                            } else {
                                self?.errorCodeHandler(responseFailure)
                            }
                        }
                        followingPortfolioRefresh.accept(false)
                    },
                    onFailure: { [weak self] error in
                        self?.errorHandler(error: error)
                        followingPortfolioRefresh.accept(false)
                    }
                )
                .disposed(by: disposeBag)
        }
    }
}
