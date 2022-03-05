//
//  HomeViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/1.
//

import RxCocoa
import RxSwift

public protocol HomeViewModelInputs: NSObject {
    var viewDidLoad: PublishRelay<()> { get }
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
    
    var viewDidLoad: PublishRelay<()>
    
    // MARK: - Outputs
    
    var notifications: Driver<[NotificationApiData]>
    
    var inputs: HomeViewModelInputs { self }
    var outputs: HomeViewModelOutputs { self }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let notifications = BehaviorRelay<[NotificationApiData]>(value: [])
        
        self.viewDidLoad = viewDidLoad
        self.notifications = notifications.asDriver()
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.loadNotifications(notifications: notifications)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadNotifications(notifications: BehaviorRelay<[NotificationApiData]>) {
//        404
//        FollowService.getNotifications()
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
        
        let data = [
            NotificationApiData(
                userId: 1,
                name: "Name",
                exchange: "binance",
                currency: "ETH",
                type: "spot",
                timestamp: 1637901093,
                side: "BUY",
                price: "2925.2",
                executedQty: "1.2"
            ),
            NotificationApiData(
                userId: 2,
                name: "Name Name",
                exchange: "ftx",
                currency: "ETH",
                type: "spot",
                timestamp: 1637901093,
                side: "SELL",
                price: "2925.2",
                executedQty: "1.2"
            ),
            NotificationApiData(
                userId: 3,
                name: "Name Name Name",
                exchange: "ftx",
                currency: "ETH",
                type: "spot",
                timestamp: 1637901093,
                side: "SELL",
                price: "2925.2",
                executedQty: "1.2"
            ),
            NotificationApiData(
                userId: 4,
                name: "Name Name Name Name",
                exchange: "ftx",
                currency: "ETH",
                type: "spot",
                timestamp: 1637901093,
                side: "SELL",
                price: "2925.2",
                executedQty: "1.2"
            )
        ]
        notifications.accept(data)
    }
    
    
}
