//
//  StatisticsViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Resolver
import RxCocoa
import RxSwift

class StatisticsViewModel: BaseViewModel {
        
    let assetProfitObservable = BehaviorRelay<NSAttributedString>(value: PortfolioData.defaultProfitString)
    let assetSumObservable = BehaviorRelay<NSAttributedString>(value: PortfolioData.defaultAssetSumString)
    let portfolioViewDataListObservable = BehaviorRelay<[PortfolioViewData]?>(value: nil)
    let pnlObservable = BehaviorRelay<PNLData?>(value: nil)
//    let timerObservable = PublishRelay<Int>()
//    private var timerDisposable: Disposable?
    
    private let portfolioDataObservable = BehaviorRelay<PortfolioData?>(value: nil)
    private let exchangeFilterObservable = BehaviorRelay<ExchangeType>(value: .all)
    private let portfolioTypeFilterObservable = BehaviorRelay<PortfolioType>(value: .all)
    private var pnlPeriodFilterObservable = BehaviorRelay<PNLPeriod>(value: .all)
    
    deinit {
        Timber.i("StatisticsViewModel")
    }
    
    override init() {
        super.init()
        
        getPortfolio()
        
        Observable.combineLatest(
            portfolioDataObservable,
            exchangeFilterObservable,
            portfolioTypeFilterObservable,
            resultSelector: { (portfolioData: PortfolioData?, exchangeFilter: ExchangeType, portfolioFilter: PortfolioType) -> [PortfolioViewData]? in
                if let portfolioData = portfolioData {
                    var viewDataList: [PortfolioViewData] = portfolioData.getViewData()
                    if exchangeFilter != .all {
                        viewDataList = viewDataList.filter { $0.exchange == exchangeFilter }
                    }
                    if portfolioFilter != .all {
                        viewDataList = viewDataList.filter { $0.type == portfolioFilter }
                    }
                    return viewDataList
                } else {
                    return nil
                }
            }
        )
            .subscribe(on: backgroundScheduler)
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: portfolioViewDataListObservable)
            .disposed(by: disposeBag)
        
        pnlPeriodFilterObservable
            .subscribe(onNext: { [weak self] period in
                self?.getPNL(period: period)
            })
            .disposed(by: disposeBag)
    }
    
    func getPortfolio() {
        StatisticsService.getPortfolio(exchange: "all")
            .request()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(portfolio):
                        self?.assetProfitObservable.accept(portfolio.data.getProfitString())
                        self?.assetSumObservable.accept(portfolio.data.getAssetSumString())
                        self?.portfolioDataObservable.accept(portfolio.data)
                    case let .failure(responseFailure):
                        if responseFailure.code == 1006 {
                            self?.portfolioViewDataListObservable.accept(nil)
                        } else {
                            self?.errorCodeHandler(responseFailure)
                        }
                    }
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func getPNL(period: PNLPeriod) {
        StatisticsService.getPNL(exchange: "all", period: period.rawValue)
            .request()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(pnl):
                        self?.pnlObservable.accept(pnl.data)
                    case let .failure(responseFailure):
                        if responseFailure.code == 1007 {
                            
                        } else {
                            self?.errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
                        }
                    }
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func startFetchData() {
//        timerDisposable?.dispose()
//        timerDisposable = Observable<Int>.timer(
//            RxTimeInterval.seconds(0),
//            period: RxTimeInterval.seconds(30),
//            scheduler: ConcurrentDispatchQueueScheduler(qos: .background)
//        )
//        .subscribe(onNext: { [unowned self] secs in
//            timerObservable.accept(secs)
//            getPortfolio()
//        })
    }
    
}

extension StatisticsViewModel: PortfolioViewDelegate {
    func onExchangeFiltered(exchange: String) {
        exchangeFilterObservable.accept(ExchangeType.init(rawValue: exchange)!)
    }
    
    func onPortfolioTypeFiltered(type: String) {
        portfolioTypeFilterObservable.accept(PortfolioType.init(rawValue: type)!)
    }
}

extension StatisticsViewModel: PNLViewDelegate {
    func onPeriodFiltered(period: String) {
        pnlPeriodFilterObservable.accept(PNLPeriod.init(rawValue: period)!)
    }
}

