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
    
    let exhangeListObservable = PublishSubject<[ExchangeData]>()
    let exchangeUpdatedObservable = PublishSubject<ExchangeData>()
    let completeObservable = PublishSubject<Bool>()
    
    func getStatus() {
        ExchangeApiService.getStatus()
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    newExchangeHandler(response: response)
                },
                onFailure: { [unowned self] error in
                    errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func create(exchange: String, apiKey: String, apiSecret: String) {
        ExchangeApiService.create(exchange: exchange, apiKey: apiKey, apiSecret: apiSecret)
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    newExchangeHandler(response: response)
                },
                onFailure: { [unowned self] error in
                    errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func edit(id: Int, exchange: String, apiKey: String, apiSecret: String, subaccount: String) {
        ExchangeApiService.edit(id: id, exchange: exchange, apiKey: apiKey, apiSecret: apiKey, subAccount: subaccount)
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    newExchangeHandler(response: response)
                },
                onFailure: { [unowned self] error in
                    errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func delete(id: Int) {
        ExchangeApiService.delete(id: id)
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    newExchangeHandler(response: response)
                },
                onFailure: { [unowned self] error in
                    errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func newExchangeHandler(response: HttpResponse<Exchange, ResponseFailure>) {
        switch response {
        case let .Success(exchange):
            exhangeListObservable.onNext(exchange.data)
            completeObservable.onNext(true)
        case let .Failure(responseFailure):
            errorCodeHandler(responseFailure)
        }
    }
}
