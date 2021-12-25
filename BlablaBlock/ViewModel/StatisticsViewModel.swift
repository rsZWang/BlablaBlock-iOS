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
    
    @Injected private var statisticsService: StatisticsService
    
    let portfolioObservable = BehaviorRelay<[PortfolioData]?>(value: nil)
    let pnlObservable = BehaviorRelay<PNLData?>(value: nil)
    
    override init() {
        super.init()
        startReadData()
    }
    
    private func startReadData() {
        Observable<Int>.timer(
            RxTimeInterval.seconds(0),
            period: RxTimeInterval.seconds(30),
            scheduler: ConcurrentDispatchQueueScheduler(qos: .background)
        )
        .subscribe(onNext: { [unowned self] _ in
            getPortfolio()
            getPNL()
        })
        .disposed(by: disposeBag)
    }
    
    func getPortfolio() {
        StatisticsService.getPortfolio(exchange: "all")
            .request()
            .subscribe(
                onSuccess: { [unowned self] portfolio in
                    if portfolio.code == 200 {
                        portfolioObservable.accept(portfolio.data)
                    }
                },
                onFailure: { error in
                    Timber.i("\(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    func getPNL() {
        StatisticsService.getPNL(exchange: "all", period: "all")
            .request()
            .subscribe(
                onSuccess: { [unowned self] pnl in
                    if pnl.code == 200 {
                        pnlObservable.accept(pnl.data.first)
                    }
                },
                onFailure: { error in
                    Timber.i("\(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
}
