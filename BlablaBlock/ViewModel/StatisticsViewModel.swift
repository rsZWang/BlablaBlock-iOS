//
//  StatisticsViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Resolver
import RxCocoa
import RxSwift

public protocol StatisticsViewModelInputs {
    var viewDidLoad: PublishRelay<()> { get }
    var historyBtnTap: PublishRelay<()> { get }
    var exchangeFilter: BehaviorRelay<ExchangeType> { get }
    var portfolioType: BehaviorRelay<PortfolioType> { get }
    var pnlPeriod: BehaviorRelay<PNLPeriod> { get }
    var followingPortfolioExchangeFilter: BehaviorRelay<ExchangeType> { get }
    var followingPortfolioType: BehaviorRelay<PortfolioType> { get }
    var refresh: PublishRelay<()> { get }
    var followingPortfolioPull: PublishRelay<()> { get }
}

public protocol StatisticsViewModelOutputs {
    var user: BehaviorRelay<UserApiData?> { get }
    var portfolio: Driver<PortfolioViewData> { get }
    var pnl: Signal<PNLApiData> { get }
    var followingPortfolio: Driver<PortfolioViewData> { get }
    var portfolioRefresh: Signal<Bool> { get }
    var pnlRefresh: Signal<Bool> { get }
    var followingPortfolioRefresh: Signal<Bool> { get }
    var uiEvent: PublishRelay<StatisticsViewUiEvent> { get }
}

public protocol StatisticsViewModelType {
    var inputs: StatisticsViewModelInputs { get }
    var outputs: StatisticsViewModelOutputs { get }
}

public enum StatisticsViewUiEvent {
    case back
    case history
}

final class StatisticsViewModel:
    BaseViewModel,
    StatisticsViewModelInputs,
    StatisticsViewModelOutputs,
    StatisticsViewModelType
{
    // MARK: - inputs
    var viewDidLoad: PublishRelay<()>
    var historyBtnTap: PublishRelay<()>
    var exchangeFilter: BehaviorRelay<ExchangeType>
    var portfolioType: BehaviorRelay<PortfolioType>
    var pnlPeriod: BehaviorRelay<PNLPeriod>
    var followingPortfolioExchangeFilter: BehaviorRelay<ExchangeType>
    var followingPortfolioType: BehaviorRelay<PortfolioType>
    var refresh: PublishRelay<()>
    var followingPortfolioPull: PublishRelay<()>
    
    // MARK: - outpus
    var user: BehaviorRelay<UserApiData?>
    var portfolio: Driver<PortfolioViewData>
    var pnl: Signal<PNLApiData>
    var followingPortfolio: Driver<PortfolioViewData>
    var portfolioRefresh: Signal<Bool>
    var pnlRefresh: Signal<Bool>
    var followingPortfolioRefresh: Signal<Bool>
    var uiEvent: PublishRelay<StatisticsViewUiEvent>
    
    var inputs: StatisticsViewModelInputs { self }
    var outputs: StatisticsViewModelOutputs { self }
    
    // MARK: - internals
    private let portfolioViewDataCache = BehaviorRelay<PortfolioApiData?>(value: nil)
    private let followingPortfolioViewDataCache = BehaviorRelay<PortfolioApiData?>(value: nil)
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let historyBtnTap = PublishRelay<()>()
        let exchangeFilter = BehaviorRelay<ExchangeType>(value: .all)
        let portfolioType = BehaviorRelay<PortfolioType>(value: .all)
        let pnlPeriod = BehaviorRelay<PNLPeriod>(value: .all)
        let followingPortfolioExchangeFilter = BehaviorRelay<ExchangeType>(value: .all)
        let followingPortfolioType = BehaviorRelay<PortfolioType>(value: .all)
        let refresh = PublishRelay<()>()
        let followingPortfolioPull = PublishRelay<()>()
        
        let user = BehaviorRelay<UserApiData?>(value: nil)
        let portfolio = PublishRelay<PortfolioViewData>()
        let pnl = PublishRelay<PNLApiData>()
        let followingPortfolio = PublishRelay<PortfolioViewData>()
        let portfolioRefresh = PublishRelay<Bool>()
        let pnlRefresh = PublishRelay<Bool>()
        let followingPortfolioRefresh = PublishRelay<Bool>()
        let uiEvent = PublishRelay<StatisticsViewUiEvent>()
        
        self.viewDidLoad = viewDidLoad
        self.historyBtnTap = historyBtnTap
        self.exchangeFilter = exchangeFilter
        self.portfolioType = portfolioType
        self.pnlPeriod = pnlPeriod
        self.followingPortfolioExchangeFilter = followingPortfolioExchangeFilter
        self.followingPortfolioType = followingPortfolioType
        self.refresh = refresh
        self.followingPortfolioPull = followingPortfolioPull
        
        self.user = user
        self.portfolio = portfolio.asDriver(onErrorJustReturn: PortfolioViewData(
                                                profit: PortfolioApiData.defaultProfitString,
                                                sum: PortfolioApiData.defaultAssetSumString,
                                                assets: []))
        self.pnl = pnl.asSignal()
        self.followingPortfolio = followingPortfolio.asDriver(onErrorJustReturn: PortfolioViewData(
                                                                profit: PortfolioApiData.defaultProfitString,
                                                                sum: PortfolioApiData.defaultAssetSumString,
                                                                assets: []))
        self.portfolioRefresh = portfolioRefresh.asSignal()
        self.pnlRefresh = pnlRefresh.asSignal()
        self.followingPortfolioRefresh = followingPortfolioRefresh.asSignal()
        self.uiEvent = uiEvent
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: {
                refresh.accept(())
                followingPortfolioPull.accept(())
            })
            .disposed(by: disposeBag)
        
        refresh
            .map { true }
            .bind(to: portfolioRefresh, pnlRefresh)
            .disposed(by: disposeBag)
        
        followingPortfolioPull
            .map { true }
            .bind(to: followingPortfolioRefresh)
            .disposed(by: disposeBag)
        
        portfolioRefresh
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.getPortfolio(portfolioRefresh: portfolioRefresh)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            pnlRefresh.filter { $0 },
            pnlPeriod,
            resultSelector: { (_, period: PNLPeriod) in
                period.rawValue
            }
        )
        .subscribe(onNext: { [weak self] period in
            self?.getPNL(period: period, pnl: pnl, pnlRefresh: pnlRefresh)
        })
        .disposed(by: disposeBag)
        
        followingPortfolioRefresh
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.getFollowingPortfolio(followingPortfolioRefresh: followingPortfolioRefresh)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            exchangeFilter,
            portfolioType,
            portfolioViewDataCache,
            resultSelector: portfolioHandler
        )
        .bind(to: portfolio)
        .disposed(by: disposeBag)
        
        Observable.combineLatest(
            followingPortfolioExchangeFilter,
            followingPortfolioType,
            followingPortfolioViewDataCache,
            resultSelector: portfolioHandler
        )
        .bind(to: followingPortfolio)
        .disposed(by: disposeBag)
    }
    
    private let portfolioHandler: ((ExchangeType, PortfolioType, PortfolioApiData?) -> PortfolioViewData) = { (exchangeFilter, portfolioFilter, portfolioData) in
        if let portfolioData = portfolioData {
            var assetsViewData: [PortfolioAssetViewData] = portfolioData.getAssetsViewData()
            if exchangeFilter != .all {
                assetsViewData = assetsViewData.filter { $0.exchange == exchangeFilter }
            }
            if portfolioFilter != .all {
                assetsViewData = assetsViewData.filter { $0.type == portfolioFilter }
            }
            return PortfolioViewData(
                profit: portfolioData.getProfitString(),
                sum: portfolioData.getAssetSumString(),
                assets: assetsViewData
            )
        } else {
            return PortfolioViewData(
                profit: PortfolioApiData.defaultProfitString,
                sum: PortfolioApiData.defaultAssetSumString,
                assets: []
            )
        }
    }
}

private extension StatisticsViewModel {    
    func getPortfolio(portfolioRefresh: PublishRelay<Bool>) {
        let request: Single<HttpResponse<PortfolioApi, ResponseFailure>>
        if let userId = user.value?.userId {
            request = UserService.getPortfolioByID(userId: userId, exchange: "all")
                .request()
        } else {
            request = StatisticsService.getPortfolio(exchange: "all")
                .request()
        }
        request.subscribe(
            onSuccess: { [weak self] response in
                switch response {
                case let .success(portfolio):
                    self?.portfolioViewDataCache.accept(portfolio.data)
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
        let request: Single<HttpResponse<PNLApi, ResponseFailure>>
        if let userId = user.value?.userId {
            request = UserService.getPNLByID(userId: userId, exchange: "all", period: period)
                .request()
        } else {
            request = StatisticsService.getPNL(exchange: "all", period: period)
                .request()
        }
        request.subscribe(
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
    
    func getFollowingPortfolio(followingPortfolioRefresh: PublishRelay<Bool>) {
        let userId: Int
        if let id = user.value?.userId {
            userId = id
        } else {
            userId = Int(keychainUser[.userId]!)!
        }
        UserService.getFollowPortfolioByID(userId: userId, exchange: "all")
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(portfolio):
                        self?.followingPortfolioViewDataCache.accept(portfolio.data)
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
