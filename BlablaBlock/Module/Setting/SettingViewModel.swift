//
//  SettingViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Resolver
import RxCocoa
import RxSwift

protocol SettingViewModelInputs: AnyObject {
    
}

protocol SettingViewModelOutputs: AnyObject {
    
}

protocol SettingViewModelType: AnyObject {
    var inputs: SettingViewModelInputs { get }
    var outputs: SettingViewModelOutputs { get }
}

final class SettingViewModel:
    BaseViewModel,
    SettingViewModelInputs,
    SettingViewModelOutputs,
    SettingViewModelType
{
    var inputs: SettingViewModelInputs { self }
    var outputs: SettingViewModelOutputs { self }
    
    
//    let exhangeListObservable = BehaviorRelay<[ExchangeApiData]>(value: [])
//    let exchangeUpdatedObservable = PublishSubject<ExchangeApiData>()
//    let completeObservable = PublishSubject<Bool>()
//
//    func getApiStatus() -> Observable<Bool> {
//        let hasLinkedObservable = PublishSubject<Bool>()
//        ExchangeApiService.getStatus()
//            .request()
//            .subscribe(
//                onSuccess: { [weak self] response in
//                    switch response {
//                    case let .success(exchange):
//                        let hasLinked = exchange.hasLinked()
////                        if hasLinked && timerDisposable == nil {
////                            startFetchData()
////                        }
//                        self?.exhangeListObservable.accept(exchange.data)
//                        hasLinkedObservable.onNext(hasLinked)
//                    case let .failure(responseFailure):
//                        self?.errorCodeHandler(responseFailure)
//                    }
//                },
//                onFailure: { [weak self] error in
//                    self?.errorHandler(error: error)
//                    hasLinkedObservable.onError(error)
//                }
//            )
//            .disposed(by: disposeBag)
//        return hasLinkedObservable.observe(on: MainScheduler.asyncInstance)
//    }
//
//    func create(exchange: String, apiKey: String, apiSecret: String) {
//        ExchangeApiService.create(exchange: exchange, apiKey: apiKey, apiSecret: apiSecret)
//            .request()
//            .subscribe(
//                onSuccess: { [weak self] response in
//                    self?.newExchangeHandler(response: response)
//                },
//                onFailure: { [weak self] error in
//                    self?.errorHandler(error: error)
//                }
//            )
//            .disposed(by: disposeBag)
//    }
//
//    func edit(id: Int, exchange: String, apiKey: String, apiSecret: String, subaccount: String) {
//        ExchangeApiService.edit(id: id, exchange: exchange, apiKey: apiKey, apiSecret: apiKey, subAccount: subaccount)
//            .request()
//            .subscribe(
//                onSuccess: { [weak self] response in
//                    self?.newExchangeHandler(response: response)
//                },
//                onFailure: { [weak self] error in
//                    self?.errorHandler(error: error)
//                }
//            )
//            .disposed(by: disposeBag)
//    }
//
//    func delete(id: Int) {
//        ExchangeApiService.delete(id: id)
//            .request()
//            .subscribe(
//                onSuccess: { [weak self] response in
//                    self?.newExchangeHandler(response: response)
//                },
//                onFailure: { [weak self] error in
//                    self?.errorHandler(error: error)
//                }
//            )
//            .disposed(by: disposeBag)
//    }
//
//    func getIcons() {
//        ExchangeApiService.getCurrency()
//            .request()
//            .subscribe(
//                onSuccess: { response in
////                    self?.newExchangeHandler(response: response)
//                    Timber.i("response: \(response)")
//                },
//                onFailure: { [weak self] error in
//                    self?.errorHandler(error: error)
//                }
//            )
//            .disposed(by: disposeBag)
//    }
//
//    private func newExchangeHandler(response: HttpResponse<ExchangeApi, ResponseFailure>) {
//        switch response {
//        case let .success(exchange):
//            exhangeListObservable.accept(exchange.data)
//            completeObservable.onNext(true)
//        case let .failure(responseFailure):
//            errorCodeHandler(responseFailure)
//        }
//    }
}
