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
    var viewWillAppear: PublishRelay<()> { get }
    var historyBtnTap: PublishRelay<()> { get }
    var exchangeFilter: BehaviorRelay<ExchangeType> { get }
    var portfolioType: BehaviorRelay<PortfolioType> { get }
    var portfolioPull: PublishRelay<()> { get }
    var pnlPeriod: BehaviorRelay<PNLPeriod> { get }
    var pnlPull: PublishRelay<()> { get }
    var followingPortfolioExchangeFilter: BehaviorRelay<ExchangeType> { get }
    var followingPortfolioType: BehaviorRelay<PortfolioType> { get }
    var followingPortfolioPull: PublishRelay<()> { get }
}

public protocol PortfolioViewModelOutputs: AnyObject {
    var user: BehaviorRelay<UserApiData?> { get }
    var profit: Signal<NSAttributedString> { get }
    var sum: Signal<NSAttributedString> { get }
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
    case history
}

final class PortfolioViewModel:
    BaseViewModel,
    PortfolioViewModelInputs,
    PortfolioViewModelOutputs,
    PortfolioViewModelType
{
    // MARK: - inputs
    var viewWillAppear: PublishRelay<()>
    var historyBtnTap: PublishRelay<()>
    var exchangeFilter: BehaviorRelay<ExchangeType>
    var portfolioType: BehaviorRelay<PortfolioType>
    var portfolioPull: PublishRelay<()>
    var pnlPeriod: BehaviorRelay<PNLPeriod>
    var pnlPull: PublishRelay<()>
    var followingPortfolioExchangeFilter: BehaviorRelay<ExchangeType>
    var followingPortfolioType: BehaviorRelay<PortfolioType>
    var followingPortfolioPull: PublishRelay<()>
    
    // MARK: - outpus
    var user: BehaviorRelay<UserApiData?>
    var profit: Signal<NSAttributedString>
    var sum: Signal<NSAttributedString>
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
        let viewWillAppear = PublishRelay<()>()
        let historyBtnTap = PublishRelay<()>()
        let exchangeFilter = BehaviorRelay<ExchangeType>(value: .all)
        let portfolioType = BehaviorRelay<PortfolioType>(value: .all)
        let pnlPeriod = BehaviorRelay<PNLPeriod>(value: .all)
        let followingPortfolioExchangeFilter = BehaviorRelay<ExchangeType>(value: .all)
        let followingPortfolioType = BehaviorRelay<PortfolioType>(value: .all)
        let portfolioPull = PublishRelay<()>()
        let pnlPull = PublishRelay<()>()
        let followingPortfolioPull = PublishRelay<()>()
        
        let user = BehaviorRelay<UserApiData?>(value: nil)
        let sum = PublishRelay<NSAttributedString>()
        let profit = PublishRelay<NSAttributedString>()
        let portfolio = PublishRelay<[PortfolioAssetViewData]>()
        let portfolioRefresh = PublishRelay<Bool>()
        let pnl = PublishRelay<PNLApiData>()
        let pnlRefresh = PublishRelay<Bool>()
        let followingPortfolio = PublishRelay<[PortfolioAssetViewData]>()
        let followingPortfolioRefresh = PublishRelay<Bool>()
        let uiEvent = PublishRelay<PortfolioViewUiEvent>()
        
        let refreshPortfolioAndPNL = PublishRelay<()>()
        
        self.viewWillAppear = viewWillAppear
        self.historyBtnTap = historyBtnTap
        self.exchangeFilter = exchangeFilter
        self.portfolioType = portfolioType
        self.pnlPeriod = pnlPeriod
        self.followingPortfolioExchangeFilter = followingPortfolioExchangeFilter
        self.followingPortfolioType = followingPortfolioType
        self.portfolioPull = portfolioPull
        self.pnlPull = pnlPull
        self.followingPortfolioPull = followingPortfolioPull
        
        self.user = user
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
        
//        user
//            .subscribe(onNext: { [weak self] _ in
//                
//            })
//            .disposed(by: disposeBag)
        
        viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                portfolioRefresh.accept(true)
                pnlRefresh.accept(true)
                followingPortfolioRefresh.accept(true)
                
                
//                followingPortfolioRefresh.accept(true)
//                refreshPortfolioAndPNL.accept(())
//                self?.getFollowingPortfolio(
//                    followingProtfolioExchange: followingPortfolioExchangeFilter.value.rawValue,
//                    followingProtfolio: followingPortfolio,
//                    followingPortfolioRefresh: followingPortfolioRefresh
//                )
            })
            .disposed(by: disposeBag)
        
        historyBtnTap
            .subscribe(onNext: {
                if let user = user.value {
                    EventTracker.Builder()
                        .setProperty(name: .USER_B, value: user.userId)
                        .logEvent(.CHECK_OTHERS_PROFILE_TRADE_RECORD)
                } else {
                    EventTracker.Builder()
                        .logEvent(.CHECK_PERSONAL_PAGE_TRADE_RECORD)
                }
                uiEvent.accept(.history)
            })
            .disposed(by: disposeBag)
        
        exchangeFilter
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
        
        pnlPeriod
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
                    exchange: exchangeFilter.value.rawValue,
                    profit: profit,
                    sum: sum,
                    protfolio: portfolio,
                    portfolioRefresh: portfolioRefresh
                )
                self?.getPNL(
                    period: pnlPeriod.value.rawValue,
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
        profit: PublishRelay<NSAttributedString>,
        sum: PublishRelay<NSAttributedString>,
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
                        profit.accept(portfolio.data.getAssetProfitString())
                        sum.accept(portfolio.data.getAssetSumString())
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
