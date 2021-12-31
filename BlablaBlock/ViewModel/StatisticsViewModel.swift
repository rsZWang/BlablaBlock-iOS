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
    
    let hasLinkedObservable = BehaviorSubject<Bool?>(value: nil)
    let exhangesObservable = BehaviorRelay<[ExchangeApiData]?>(value: nil)
    let portfolioObservable = BehaviorRelay<Portfolio?>(value: nil)
    let pnlObservable = BehaviorRelay<PNLData?>(value: nil)
    let timerObservable = PublishRelay<Int>()
    private var timerDisposable: Disposable?
    private var portfolioFilter = "all"
    private var pnlPeriodFilter = "all"
    
    func getExchangesStatus() -> Observable<Bool?> {
        ExchangeApiService.getStatus()
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    switch response {
                    case let .Success(exchange):
                        let hasLinked = exchange.hasLinked()
                        if hasLinked && timerDisposable == nil {
                            startFetchData()
                        }
                        exhangesObservable.accept(exchange.data)
                        hasLinkedObservable.onNext(hasLinked)
                    case let .Failure(responseFailure):
                        errorCodeHandler(responseFailure)
                    }
                },
                onFailure: { [unowned self] error in
                    errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
        return hasLinkedObservable
    }
    
    func getPortfolio(exchange: String) {
        if !exchange.isEmpty {
            portfolioFilter = exchange
        }
        StatisticsService.getPortfolio(exchange: portfolioFilter)
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    switch response {
                    case let .Success(portfolio):
                        portfolioObservable.accept(portfolio)
                    case let .Failure(responseFailure):
                        if responseFailure.code == 1006 {
                            portfolioObservable.accept(nil)
                        } else {
                            errorCodeHandler(responseFailure)
                        }
                    }
                },
                onFailure: { [unowned self] error in
                    errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func getPNL(period: String) {
        if !period.isEmpty {
            pnlPeriodFilter = period
        }
        StatisticsService.getPNL(exchange: "all", period: period)
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    switch response {
                    case let .Success(pnl):
                        pnlObservable.accept(pnl.data)
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
