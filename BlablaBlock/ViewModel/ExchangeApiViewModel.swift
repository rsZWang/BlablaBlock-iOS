//
//  ExchangeApiViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Resolver
import RxCocoa
import RxSwift

class ExchangeApiViewModel: BaseViewModel {
    
    let exhangeListObservable = BehaviorRelay<[ExchangeApiData]>(value: [])
    let exchangeUpdatedObservable = PublishSubject<ExchangeApiData>()
    let completeObservable = PublishSubject<Bool>()
    
    func getApiStatus() -> Observable<Bool> {
        let hasLinkedObservable = PublishSubject<Bool>()
        ExchangeApiService.getStatus()
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .Success(exchange):
                        let hasLinked = exchange.hasLinked()
//                        if hasLinked && timerDisposable == nil {
//                            startFetchData()
//                        }
                        self?.exhangeListObservable.accept(exchange.data)
                        hasLinkedObservable.onNext(hasLinked)
                    case let .Failure(responseFailure):
                        self?.errorCodeHandler(responseFailure)
                    }
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                    hasLinkedObservable.onError(error)
                }
            )
            .disposed(by: disposeBag)
        return hasLinkedObservable
    }
    
    func create(exchange: String, apiKey: String, apiSecret: String) {
        ExchangeApiService.create(exchange: exchange, apiKey: apiKey, apiSecret: apiSecret)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.newExchangeHandler(response: response)
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func edit(id: Int, exchange: String, apiKey: String, apiSecret: String, subaccount: String) {
        ExchangeApiService.edit(id: id, exchange: exchange, apiKey: apiKey, apiSecret: apiKey, subAccount: subaccount)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.newExchangeHandler(response: response)
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func delete(id: Int) {
        ExchangeApiService.delete(id: id)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.newExchangeHandler(response: response)
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func newExchangeHandler(response: HttpResponse<ExchangeApi, ResponseFailure>) {
        switch response {
        case let .Success(exchange):
            exhangeListObservable.accept(exchange.data)
            completeObservable.onNext(true)
        case let .Failure(responseFailure):
            errorCodeHandler(responseFailure)
        }
    }
}
