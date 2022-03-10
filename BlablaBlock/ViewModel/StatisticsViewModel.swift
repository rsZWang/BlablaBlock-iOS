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
    var shareBtnTap: PublishRelay<()> { get }
    var historyBtnTap: PublishRelay<()> { get }
    var exchangeFilter: BehaviorRelay<ExchangeType> { get }
    var portfolioType: BehaviorRelay<PortfolioType> { get }
    var pnlPeriod: BehaviorRelay<PNLPeriod> { get }
    var refresh: PublishRelay<()> { get }
}

public protocol StatisticsViewModelOutputs {
    var user: BehaviorRelay<UserApiData?> { get }
    var portfolio: Signal<PortfolioViewData> { get }
    var pnl: Signal<PNLApiData> { get }
    var portfolioRefresh: Signal<Bool> { get }
    var pnlRefresh: Signal<Bool> { get }
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
    var shareBtnTap: PublishRelay<()>
    var historyBtnTap: PublishRelay<()>
    var exchangeFilter: BehaviorRelay<ExchangeType>
    var portfolioType: BehaviorRelay<PortfolioType>
    var pnlPeriod: BehaviorRelay<PNLPeriod>
    var refresh: PublishRelay<()>
    
    // MARK: - outpus
    var user: BehaviorRelay<UserApiData?>
    var portfolio: Signal<PortfolioViewData>
    var pnl: Signal<PNLApiData>
    var portfolioRefresh: Signal<Bool>
    var pnlRefresh: Signal<Bool>
    var uiEvent: PublishRelay<StatisticsViewUiEvent>
    
    var inputs: StatisticsViewModelInputs { self }
    var outputs: StatisticsViewModelOutputs { self }
    
    // MARK: - internals
    private let portfolioViewDataCache = BehaviorRelay<PortfolioApiData?>(value: nil)
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let shareBtnTap = PublishRelay<()>()
        let historyBtnTap = PublishRelay<()>()
        let exchangeFilter = BehaviorRelay<ExchangeType>(value: .all)
        let portfolioType = BehaviorRelay<PortfolioType>(value: .all)
        let user = BehaviorRelay<UserApiData?>(value: nil)
        let portfolio = PublishRelay<PortfolioViewData>()
        let refresh = PublishRelay<()>()
        let portfolioRefresh = PublishRelay<Bool>()
        let pnlRefresh = PublishRelay<Bool>()
        let pnlPeriod = BehaviorRelay<PNLPeriod>(value: .all)
        let pnl = PublishRelay<PNLApiData>()
        let uiEvent = PublishRelay<StatisticsViewUiEvent>()
        
        self.viewDidLoad = viewDidLoad
        self.shareBtnTap = shareBtnTap
        self.historyBtnTap = historyBtnTap
        self.exchangeFilter = exchangeFilter
        self.portfolioType = portfolioType
        self.refresh = refresh
        self.portfolioRefresh = portfolioRefresh.asSignal()
        self.pnlRefresh = pnlRefresh.asSignal()
        self.user = user
        self.portfolio = portfolio.asSignal()
        self.pnlPeriod = pnlPeriod
        self.pnl = pnl.asSignal()
        self.uiEvent = uiEvent
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: {
                refresh.accept(())
            })
            .disposed(by: disposeBag)
        
        shareBtnTap
            .subscribe(onNext: { [weak self] in
                if let user = self?.user.value {
                    self?.follow(user)
                } else {
                    self?.share()
                }
            })
            .disposed(by: disposeBag)
        
        refresh
            .map { true }
            .bind(to: portfolioRefresh, pnlRefresh)
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
        
        Observable.combineLatest(
            exchangeFilter,
            portfolioType,
            portfolioViewDataCache,
            resultSelector: { (exchangeFilter: ExchangeType, portfolioFilter: PortfolioType, portfolioData: PortfolioApiData?) -> PortfolioViewData in
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
        )
        .bind(to: portfolio)
        .disposed(by: disposeBag)
    }
}

private extension StatisticsViewModel {
    func follow(_ user: UserApiData) {
        if user.isFollow {
            
        } else {
            FollowService.follow(userId: user.userId)
                .request()
                .subscribe(
                    onSuccess: { [weak self] response in
                        switch response {
                        case .success(_):
                            var user = user
                            user.isFollow = true
                            self?.user.accept(user)
                        case let .failure(responseFailure):
                            self?.errorCodeHandler(responseFailure)
                        }
                    },
                    onFailure: { [weak self] error in
                        self?.errorHandler(error: error)
                    }
                )
                .disposed(by: disposeBag)
        }
    }
    
    func share() {
        
    }
    
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
}
