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
    let exhangesObservable = BehaviorRelay<[ExchangeData]?>(value: nil)
    let portfolioObservable = BehaviorRelay<[PortfolioData]?>(value: nil)
    let pnlObservable = BehaviorRelay<PNLData?>(value: nil)
    private var timerDisposable: Disposable?
    
    func getExchangesStatus() -> Observable<Bool?> {
        ExchangeApiService.getStatus()
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    switch response {
                    case let .Success(exchange):
                        if exchange.code == 200 {
                            let hasLinked = exchange.hasLinked()
                            if hasLinked && timerDisposable == nil {
                                startFetchData()
                            }
                            exhangesObservable.accept(exchange.data)
                            hasLinkedObservable.onNext(hasLinked)
                        }
                    case let .Failure(responseFailure):
                        hasLinkedObservable.onError(NSError(
                            domain: responseFailure.msg,
                            code: responseFailure.code,
                            userInfo: nil
                        ))
                    }
                },
                onFailure: { [unowned self] error in
                    errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
        return hasLinkedObservable
    }
    
    private func getPortfolio() {
        StatisticsService.getPortfolio(exchange: "all")
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    switch response {
                    case let .Success(portfolio):
                        portfolioObservable.accept(portfolio.data)
                    case let .Failure(responseFailure):
                        if responseFailure.code == 1006 {
                            
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
    
    private func getPNL() {
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
    
    private func startFetchData() {
        timerDisposable?.dispose()
        timerDisposable = Observable<Int>.timer(
            RxTimeInterval.seconds(0),
            period: RxTimeInterval.seconds(30),
            scheduler: ConcurrentDispatchQueueScheduler(qos: .background)
        )
        .subscribe(onNext: { [unowned self] _ in
            getPortfolio()
            getPNL()
        })
    }
    
}
