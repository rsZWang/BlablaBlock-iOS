//
//  UserStatisticsViewModel.swift
//  BlablaBlock
//
//  Created by Harry@rooit on 2022/3/9.
//

import Resolver
import RxCocoa
import RxSwift

//final class UserStatisticsViewModel:
//    BaseViewModel,
//    StatisticsViewModelInputs,
//    StatisticsViewModelOutputs,
//    StatisticsViewModelType
//{
//    
//    // MARK: - inputs
//    var viewDidLoad: PublishRelay<()>
//    var historyBtnTap: PublishRelay<()>
//    var exchangeFilter: BehaviorRelay<ExchangeType>
//    var portfolioType: BehaviorRelay<PortfolioType>
//    var pnlPeriod: BehaviorRelay<PNLPeriod>
//    var refresh: PublishRelay<()>
//    
//    // MARK: - outpus
//    var portfolio: Signal<PortfolioViewData>
//    var pnl: Signal<PNLApiData>
//    var portfolioRefresh: Signal<Bool>
//    var pnlRefresh: Signal<Bool>
//    var uiEvent: PublishRelay<StatisticsViewUiEvent>
//    
//    var inputs: StatisticsViewModelInputs { self }
//    var outputs: StatisticsViewModelOutputs { self }
//    
//    // MARK: - internals
//    private let userId: Int
//    private let portfolioViewDataCache = BehaviorRelay<PortfolioApiData?>(value: nil)
//    
//    deinit {
//        Timber.i("\(type(of: self)) deinit")
//    }
//    
//    init(userId: Int) {
//        let viewDidLoad = PublishRelay<()>()
//        let historyBtnTap = PublishRelay<()>()
//        let exchangeFilter = BehaviorRelay<ExchangeType>(value: .all)
//        let portfolioType = BehaviorRelay<PortfolioType>(value: .all)
//        let portfolio = PublishRelay<PortfolioViewData>()
//        let refresh = PublishRelay<()>()
//        let portfolioRefresh = PublishRelay<Bool>()
//        let pnlRefresh = PublishRelay<Bool>()
//        let pnlPeriod = BehaviorRelay<PNLPeriod>(value: .all)
//        let pnl = PublishRelay<PNLApiData>()
//        let uiEvent = PublishRelay<StatisticsViewUiEvent>()
//        
//        self.userId = userId
//        self.viewDidLoad = viewDidLoad
//        self.historyBtnTap = historyBtnTap
//        self.exchangeFilter = exchangeFilter
//        self.portfolioType = portfolioType
//        self.refresh = refresh
//        self.portfolioRefresh = portfolioRefresh.asSignal()
//        self.pnlRefresh = pnlRefresh.asSignal()
//        self.portfolio = portfolio.asSignal()
//        self.pnlPeriod = pnlPeriod
//        self.pnl = pnl.asSignal()
//        self.uiEvent = uiEvent
//        
//        super.init()
//        
//        viewDidLoad
//            .subscribe(onNext: {
//                refresh.accept(())
//            })
//            .disposed(by: disposeBag)
//        
//        refresh
//            .map { true }
//            .bind(to: portfolioRefresh, pnlRefresh)
//            .disposed(by: disposeBag)
//        
//        portfolioRefresh
//            .filter { $0 }
//            .subscribe(onNext: { [weak self] _ in
//                self?.getPortfolio(portfolioRefresh: portfolioRefresh)
//            })
//            .disposed(by: disposeBag)
//        
//        Observable.combineLatest(
//            pnlRefresh.filter { $0 },
//            pnlPeriod,
//            resultSelector: { (_, period: PNLPeriod) in
//                period.rawValue
//            }
//        )
//        .subscribe(onNext: { [weak self] period in
//            self?.getPNL(period: period, pnl: pnl, pnlRefresh: pnlRefresh)
//        })
//        .disposed(by: disposeBag)
//        
//        Observable.combineLatest(
//            exchangeFilter,
//            portfolioType,
//            portfolioViewDataCache,
//            resultSelector: { (exchangeFilter: ExchangeType, portfolioFilter: PortfolioType, portfolioData: PortfolioApiData?) -> PortfolioViewData in
//                if let portfolioData = portfolioData {
//                    var assetsViewData: [PortfolioAssetViewData] = portfolioData.getAssetsViewData()
//                    if exchangeFilter != .all {
//                        assetsViewData = assetsViewData.filter { $0.exchange == exchangeFilter }
//                    }
//                    if portfolioFilter != .all {
//                        assetsViewData = assetsViewData.filter { $0.type == portfolioFilter }
//                    }
//                    return PortfolioViewData(
//                        profit: portfolioData.getProfitString(),
//                        sum: portfolioData.getAssetSumString(),
//                        assets: assetsViewData
//                    )
//                } else {
//                    return PortfolioViewData(
//                        profit: PortfolioApiData.defaultProfitString,
//                        sum: PortfolioApiData.defaultAssetSumString,
//                        assets: []
//                    )
//                }
//            }
//        )
//        .bind(to: portfolio)
//        .disposed(by: disposeBag)
//    }
//    
//    
//}
