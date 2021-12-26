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
    
    @Injected var exchangeApiService: ExchangeApiService
    
    let exhangesObservable = PublishRelay<[ExchangeData]>()
    
    func getExchanges() {
        ExchangeApiService.getLinked()
            .request()
            .subscribe(
                onSuccess: { [unowned self] response in
                    switch response {
                    case let .Success(exchange):
                        if exchange.code == 200 {
                            exhangesObservable.accept(exchange.data)
                        }
                    case let .Failure(responseFailure):
                        errorCodeHandler(responseFailure)
                    }
                },
                onFailure: { [unowned self] error in
                    errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    
    
    
    
}
