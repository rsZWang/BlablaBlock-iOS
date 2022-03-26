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
    var refresh: PublishRelay<()> { get }
    var followBtnTap: PublishRelay<Int> { get }
}

public protocol HomeViewModelOutputs: NSObject {
    var isRefreshing: Signal<Bool> { get }
    var notifications: Driver<[NotificationApiData]> { get }
    var isNotEmpty: Signal<Bool> { get }
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
    var refresh: PublishRelay<()>
    var followBtnTap: PublishRelay<Int>
    
    // MARK: - Outputs
    
    var isRefreshing: Signal<Bool>
    var notifications: Driver<[NotificationApiData]>
    var isNotEmpty: Signal<Bool>
    
    var inputs: HomeViewModelInputs { self }
    var outputs: HomeViewModelOutputs { self }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let refresh = PublishRelay<()>()
        let followBtnTap = PublishRelay<Int>()
        
        let isRefreshing = PublishRelay<Bool>()
        let notifications = BehaviorRelay<[NotificationApiData]>(value: [])
        let isNotEmpty = PublishRelay<Bool>()
        
        self.viewDidLoad = viewDidLoad
        self.refresh = refresh
        self.followBtnTap = followBtnTap
        
        self.isRefreshing = isRefreshing.asSignal()
        self.notifications = notifications.asDriver()
        self.isNotEmpty = isNotEmpty.asSignal()
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: { [weak self] in
                isRefreshing.accept(true)
                self?.loadNotifications(
                    isRefreshing: isRefreshing,
                    notifications: notifications,
                    isNotEmpty: isNotEmpty
                )
            })
            .disposed(by: disposeBag)
        
        refresh
            .bind(to: viewDidLoad)
            .disposed(by: disposeBag)
        
        followBtnTap
            .subscribe(onNext: { [weak self] userId in
                self?.follow(notifications: notifications, userId: userId)
            })
            .disposed(by: disposeBag)
    }
}

private extension HomeViewModel {
    
    private func loadNotifications(
        isRefreshing: PublishRelay<Bool>,
        notifications: BehaviorRelay<[NotificationApiData]>,
        isNotEmpty: PublishRelay<Bool>
    ) {
        UserService.getNotifications()
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    isRefreshing.accept(false)
                    switch response {
                    case let .success(historyApiResponse):
                        notifications.accept(
                            historyApiResponse.data
                                .sorted(by: { $0.timestamp > $1.timestamp })
                        )
                        isNotEmpty.accept(historyApiResponse.data.isNotEmpty)
                    case let .failure(responseFailure):
                        self?.errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
                    }
                },
                onFailure: { [weak self] error in
                    isRefreshing.accept(false)
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func follow(
        notifications: BehaviorRelay<[NotificationApiData]>,
        userId: Int
    ) {
        if notifications.value.first(where: { $0.userId == userId })?.isFollow == true {
            FollowService.unfollow(userId: userId)
                .request()
                .subscribe(
                    onSuccess: { [weak self] response in
                        switch response {
                        case .success(_):
                            self?.update(notifications: notifications, userId: userId, isFollow: false)
                        case let .failure(responseFailure):
                            self?.errorCodeHandler(responseFailure)
                        }
                    },
                    onFailure: { [weak self] error in
                        self?.errorHandler(error: error)
                    }
                )
                .disposed(by: disposeBag)
        } else {
            FollowService.follow(userId: userId)
                .request()
                .subscribe(
                    onSuccess: { [weak self] response in
                        switch response {
                        case .success(_):
                            self?.update(notifications: notifications, userId: userId, isFollow: true)
                        case let .failure(responseFailure):
                            self?.errorCodeHandler(responseFailure)
                        }
                    },
                    onFailure: { [weak self] error in
                        self?.errorHandler(error: error)
                    }
                )
                .disposed(by: disposeBag)
        }
    }
    
    private func update(notifications: BehaviorRelay<[NotificationApiData]>, userId: Int, isFollow: Bool) {
        notifications.accept(
            notifications.value
                .map({ (notification) -> NotificationApiData in
                    var new = notification
                    if new.userId == userId {
                        new.isFollow = isFollow
                    }
                    return new
                })
                .sorted(by: { $0.timestamp > $1.timestamp })
        )
    }
}
