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
    
    let portfolioObservable = BehaviorRelay<[PortfolioData]?>(value: nil)
    let pnlObservable = BehaviorRelay<PNLData?>(value: nil)
    private var isNotAutoSwitch = true
    var isLinked = true
    
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
            if isLinked {
                getPortfolio()
                getPNL()
            }
        })
        .disposed(by: disposeBag)
    }
    
    func getPortfolio() {
        StatisticsService.getPortfolio(exchange: "all")
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    switch response {
                    case let .Success(portfolio):
                        portfolioObservable.accept(portfolio.data)
                    case let .Failure(responseFailure):
                        if responseFailure.code == 1006 {
                            isLinked = false
                            if isNotAutoSwitch {
                                isNotAutoSwitch = false
                            }
                        } else {
                            errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
                        }
                    }
                },
                onFailure: { error in
                    Timber.e("\(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    func getPNL() {
        StatisticsService.getPNL(exchange: "all", period: "all")
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    switch response {
                    case let .Success(pnl):
                        pnlObservable.accept(pnl.data.first)
                    case let .Failure(responseFailure):
                        if responseFailure.code == 1007 {
                            
                        } else {
                            errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
                        }
                    }
                },
                onFailure: { error in
                    Timber.e("\(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
}
