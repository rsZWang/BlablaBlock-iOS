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
    var refresh: PublishRelay<()> { get }
}

public protocol StatisticsViewModelOutputs {
    var portfolio: Signal<PortfolioViewData> { get }
    var pnl: Signal<PNLApiData> { get }
    var portfolioRefresh: Signal<Bool> { get }
    var pnlRefresh: Signal<Bool> { get }
}

public protocol StatisticsViewModelType {
    var inputs: StatisticsViewModelInputs { get }
    var outputs: StatisticsViewModelOutputs { get }
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
    var refresh: PublishRelay<()>
    
    // MARK: - outpus
    var portfolio: Signal<PortfolioViewData>
    var pnl: Signal<PNLApiData>
    var portfolioRefresh: Signal<Bool>
    var pnlRefresh: Signal<Bool>
    
    var inputs: StatisticsViewModelInputs { self }
    var outputs: StatisticsViewModelOutputs { self }
    
    // MARK: - internals
    private let portfolioViewDataCache = BehaviorRelay<PortfolioApiData?>(value: nil)
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let historyBtnTap = PublishRelay<()>()
        let exchangeFilter = BehaviorRelay<ExchangeType>(value: .all)
        let portfolioType = BehaviorRelay<PortfolioType>(value: .all)
        let portfolio = PublishRelay<PortfolioViewData>()
        let refresh = PublishRelay<()>()
        let portfolioRefresh = PublishRelay<Bool>()
        let pnlRefresh = PublishRelay<Bool>()
        let pnlPeriod = BehaviorRelay<PNLPeriod>(value: .all)
        let pnl = PublishRelay<PNLApiData>()
        
        self.viewDidLoad = viewDidLoad
        self.historyBtnTap = historyBtnTap
        self.exchangeFilter = exchangeFilter
        self.portfolioType = portfolioType
        self.refresh = refresh
        self.portfolioRefresh = portfolioRefresh.asSignal()
        self.pnlRefresh = pnlRefresh.asSignal()
        self.portfolio = portfolio.asSignal()
        self.pnlPeriod = pnlPeriod
        self.pnl = pnl.asSignal()
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: {
                refresh.accept(())
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
    
    func getPortfolio(portfolioRefresh: PublishRelay<Bool>) {
        StatisticsService.getPortfolio(exchange: "all")
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(portfolio):
                        self?.portfolioViewDataCache.accept(portfolio.data)
                    case let .failure(responseFailure):
                        if responseFailure.code == 1006 {
//                            self?.portfolioViewDataCache.accept(nil)
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
        StatisticsService.getPNL(exchange: "all", period: period)
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
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                    pnlRefresh.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
}

extension StatisticsViewModel: PortfolioViewDelegate {
    func onExchangeFiltered(exchange: String) {
        exchangeFilter.accept(ExchangeType.init(rawValue: exchange)!)
    }
    
    func onPortfolioTypeFiltered(type: String) {
        portfolioType.accept(PortfolioType.init(rawValue: type)!)
    }
    
    func onTapHistory() {
//        historyBtnObservable.accept(())
    }
}

extension StatisticsViewModel: PNLViewDelegate {
    func onPeriodFiltered(period: String) {
        pnlPeriod.accept(PNLPeriod.init(rawValue: period)!)
    }
}

