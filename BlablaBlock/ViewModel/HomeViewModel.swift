//
//  HomeViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/1.
//

import RxCocoa
import RxSwift

public protocol HomeViewModelInputs: NSObject {
    var viewWillAppear: PublishRelay<()> { get }
}

public protocol HomeViewModelOutputs: NSObject {
    var notifications: Driver<[NotificationApiData]> { get set }
}

public protocol HomeViewModelType: NSObject {
    var inputs: HomeViewModelInputs { get }
    var outputs: HomeViewModelOutputs { get }
}

final class HomeViewModel:
    BaseViewModel,
    HomeViewModelInputs,
    HomeViewModelOutputs,
    HomeViewModelType
{
    // MARK: - Inputs
    
    var viewWillAppear: PublishRelay<()>
    
    // MARK: - Outputs
    
    var notifications: Driver<[NotificationApiData]>
    
    var inputs: HomeViewModelInputs { self }
    var outputs: HomeViewModelOutputs { self }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewWillAppear = PublishRelay<()>()
        let notifications = BehaviorRelay<[NotificationApiData]>(value: [])
        
        self.viewWillAppear = viewWillAppear
        self.notifications = notifications.asDriver()
        
        super.init()
        
        viewWillAppear
            .subscribe(onNext: { [weak self] in
                self?.loadNotifications(notifications: notifications)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadNotifications(notifications: BehaviorRelay<[NotificationApiData]>) {
//        UserService.getNotifications()
//            .request()
//            .subscribe(
//                onSuccess: { [weak self] response in
//                    switch response {
//                    case let .success(historyApiResponse):
//                        notifications.accept(historyApiResponse.data)
//                    case let .failure(responseFailure):
//                        self?.errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
//                    }
//                },
//                onFailure: { [weak self] error in
//                    self?.errorHandler(error: error)
//                }
//            )
//            .disposed(by: disposeBag)
        
        let mocdNotifications = [
            NotificationApiData(
                userId: 1,
                name: "Harry",
                exchange: "Binance",
                currency: "BTC",
                type: "spot",
                timestamp: 1637901093,
                side: "BUY",
                price: 2925.2,
                executedQty: 1.2,
                isFollow: false
            ),
            NotificationApiData(
                userId: 2,
                name: "Potter",
                exchange: "FTX",
                currency: "ETH",
                type: "spot",
                timestamp: 1647901093,
                side: "BUY",
                price: 2925.2,
                executedQty: 1.2,
                isFollow: true
            )
        ]
        notifications.accept(mocdNotifications)
    }
}
