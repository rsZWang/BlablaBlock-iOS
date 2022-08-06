//
//  PortfolioViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import RxCocoa
import RxSwift

public protocol PortfolioViewModelInputs: AnyObject {
    var user: BehaviorRelay<UserApiData?> { get }
    var viewDidLoad: PublishRelay<()> { get }
    var historyBtnTap: PublishRelay<()> { get }
    var portfolioExchangeFilter: BehaviorRelay<FilterExchange> { get }
    var portfolioTypeFilter: BehaviorRelay<FilterType> { get }
    var portfolioPull: PublishRelay<()> { get }
    var pnlPeriodFilter: BehaviorRelay<PNLPeriod> { get }
    var pnlPull: PublishRelay<()> { get }
}

public protocol PortfolioViewModelOutputs: BaseViewModelOutputs {
    var sum: Signal<NSAttributedString> { get }
    var profit: Signal<Double> { get }
    var portfolio: Driver<[PortfolioAssetViewData]> { get }
    var portfolioRefresh: Signal<Bool> { get }
    var pnl: Signal<PNLApiData> { get }
    var pnlRefresh: Signal<Bool> { get }
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
    var viewDidLoad: PublishRelay<()>
    var historyBtnTap: PublishRelay<()>
    var portfolioExchangeFilter: BehaviorRelay<FilterExchange>
    var portfolioTypeFilter: BehaviorRelay<FilterType>
    var portfolioPull: PublishRelay<()>
    var pnlPeriodFilter: BehaviorRelay<PNLPeriod>
    var pnlPull: PublishRelay<()>
    
    // MARK: - outpus
    var sum: Signal<NSAttributedString>
    var profit: Signal<Double>
    var portfolio: Driver<[PortfolioAssetViewData]>
    var portfolioRefresh: Signal<Bool>
    var pnl: Signal<PNLApiData>
    var pnlRefresh: Signal<Bool>
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
        let viewDidLoad = PublishRelay<()>()
        let historyBtnTap = PublishRelay<()>()
        let portfolioExchangeFilter = BehaviorRelay<FilterExchange>(value: .all)
        let portfolioTypeFilter = BehaviorRelay<FilterType>(value: .all)
        let pnlPeriodFilter = BehaviorRelay<PNLPeriod>(value: .all)
        let portfolioPull = PublishRelay<()>()
        let pnlPull = PublishRelay<()>()
        
        let sum = PublishRelay<NSAttributedString>()
        let profit = PublishRelay<Double>()
        let portfolio = PublishRelay<[PortfolioAssetViewData]>()
        let portfolioRefresh = PublishRelay<Bool>()
        let pnl = PublishRelay<PNLApiData>()
        let pnlRefresh = PublishRelay<Bool>()
        let uiEvent = PublishRelay<PortfolioViewUiEvent>()
        
        self.user = user
        self.viewDidLoad = viewDidLoad
        self.historyBtnTap = historyBtnTap
        self.portfolioExchangeFilter = portfolioExchangeFilter
        self.portfolioTypeFilter = portfolioTypeFilter
        self.pnlPeriodFilter = pnlPeriodFilter
        self.portfolioPull = portfolioPull
        self.pnlPull = pnlPull
        
        self.sum = sum.asSignal()
        self.profit = profit.asSignal()
        self.portfolio = portfolio.asDriver(onErrorJustReturn: [])
        self.portfolioRefresh = portfolioRefresh.asSignal()
        self.pnl = pnl.asSignal()
        self.pnlRefresh = pnlRefresh.asSignal()
        self.uiEvent = uiEvent
        
        super.init()

        let refreshPortfolioAndPNL = PublishRelay<()>()
        
        viewDidLoad
            .subscribe(onNext: {
                portfolioRefresh.accept(true)
                pnlRefresh.accept(true)
                refreshPortfolioAndPNL.accept(())
            })
            .disposed(by: disposeBag)
        
        historyBtnTap
            .subscribe(onNext: {
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
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .utility))
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
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .utility))
            .subscribe(onNext: {
                EventTracker.Builder()
                    .logEvent(.REFRESH_PERSONAL_PAGE_PERFORMANCE)
                refreshPortfolioAndPNL.accept(())
            })
            .disposed(by: disposeBag)
        
        refreshPortfolioAndPNL
            .withLatestFrom(portfolioExchangeFilter) { return $1 }
            .withLatestFrom(portfolioTypeFilter) { return ($0, $1) }
            .subscribe(onNext: { [weak self] exchange, type in
                self?.getPortfolio(
                    exchange: exchange,
                    type: type,
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
        
//        refreshPortfolioAndPNL
//            .withLatestFrom(portfolioExchangeFilter) { return $1 }
//            .withLatestFrom(portfolioTypeFilter) { return ($0, $1) }
//            .subscribe(onNext: { [weak self] exchange, type in
//                self?.getPortfolio(
//                    exchange: exchange,
//                    type: type,
//                    sum: sum,
//                    profit: profit,
//                    protfolio: portfolio,
//                    portfolioRefresh: portfolioRefresh
//                )
//                self?.getPNL(
//                    period: pnlPeriodFilter.value.rawValue,
//                    pnl: pnl,
//                    pnlRefresh: pnlRefresh
//                )
//            })
//            .disposed(by: disposeBag)
    }
}

private extension PortfolioViewModel {    
    func getPortfolio(
        exchange: FilterExchange,
        type: FilterType,
        sum: PublishRelay<NSAttributedString>,
        profit: PublishRelay<Double>,
        protfolio: PublishRelay<[PortfolioAssetViewData]>,
        portfolioRefresh: PublishRelay<Bool>
    ) {
        PortfolioService.getPortfolio(filterExchange: exchange, filterType: type)
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(portfolio):
                        sum.accept(portfolio.data.getAssetSumString())
                        profit.accept(portfolio.data.percentage ?? 0)
                        protfolio.accept(portfolio.data.getAssetsViewData())
                    case let .failure(responseFailure):
                        self?.errorCodeHandler(responseFailure)
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
        PortfolioService.getPNL(userId: userId)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(pnlData):
                        pnl.accept(pnlData.data)
                    case let .failure(responseFailure):
                        self?.errorCodeHandler(responseFailure)
                    }
                    pnlRefresh.accept(false)
                }, onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                    pnlRefresh.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
}
