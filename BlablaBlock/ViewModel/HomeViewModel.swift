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
    var refresh: PublishRelay<()> { get }
    var followBtnTap: PublishRelay<Int> { get }
}

public protocol HomeViewModelOutputs: NSObject {
    var notificationsRefresh: Signal<[NotificationApiData]> { get }
    var notificationsUpdate: Signal<[NotificationApiData]> { get }
    var isNotEmpty: Signal<Bool> { get }
    var isRefreshing: Signal<Bool> { get }
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
    var refresh: PublishRelay<()>
    var followBtnTap: PublishRelay<Int>
    
    // MARK: - Outputs
    
    var notificationsRefresh: Signal<[NotificationApiData]>
    var notificationsUpdate: Signal<[NotificationApiData]>
    var isNotEmpty: Signal<Bool>
    var isRefreshing: Signal<Bool>
    
    // MARK: - internals
    
    private let notificationsCache = BehaviorRelay<[NotificationApiData]>(value: [])
    
    var inputs: HomeViewModelInputs { self }
    var outputs: HomeViewModelOutputs { self }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewWillAppear = PublishRelay<()>()
        let refresh = PublishRelay<()>()
        let followBtnTap = PublishRelay<Int>()
        
        let notificationsRefresh = PublishRelay<[NotificationApiData]>()
        let notificationsUpdate = PublishRelay<[NotificationApiData]>()
        let isNotEmpty = PublishRelay<Bool>()
        let isRefreshing = PublishRelay<Bool>()
        
        self.viewWillAppear = viewWillAppear
        self.refresh = refresh
        self.followBtnTap = followBtnTap
        
        self.notificationsRefresh = notificationsRefresh.asSignal()
        self.notificationsUpdate = notificationsUpdate.asSignal()
        self.isNotEmpty = isNotEmpty.asSignal()
        self.isRefreshing = isRefreshing.asSignal()
        
        super.init()
        
        viewWillAppear
            .subscribe(onNext: { [weak self] in
                if self?.notificationsCache.value.isEmpty == true {
                    isRefreshing.accept(true)
                    self?.loadNotifications(
                        notificationsRefresh: notificationsRefresh,
                        notificationsUpdate: notificationsUpdate,
                        isNotEmpty: isNotEmpty,
                        isRefreshing: isRefreshing
                    )
                }
            })
            .disposed(by: disposeBag)
        
        refresh
            .subscribe(onNext: { [weak self] in
                self?.loadNotifications(
                    notificationsRefresh: notificationsRefresh,
                    notificationsUpdate: notificationsUpdate,
                    isNotEmpty: isNotEmpty,
                    isRefreshing: isRefreshing
                )
            })
            .disposed(by: disposeBag)
        
        followBtnTap
            .subscribe(onNext: { [weak self] userId in
                self?.follow(
                    userId: userId,
                    notificationsRefresh: notificationsRefresh,
                    notificationsUpdate: notificationsUpdate
                )
            })
            .disposed(by: disposeBag)
    }
}

private extension HomeViewModel {
    
    func loadNotifications(
        notificationsRefresh: PublishRelay<[NotificationApiData]>,
        notificationsUpdate: PublishRelay<[NotificationApiData]>,
        isNotEmpty: PublishRelay<Bool>,
        isRefreshing: PublishRelay<Bool>
    ) {
        UserService.getNotifications()
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    isRefreshing.accept(false)
                    switch response {
                    case let .success(historyApiResponse):
                        self?.refreshOrUpdate(
                            newNotifications: historyApiResponse.data,
                            notificationsRefresh: notificationsRefresh,
                            notificationsUpdate: notificationsUpdate
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
        userId: Int,
        notificationsRefresh: PublishRelay<[NotificationApiData]>,
        notificationsUpdate: PublishRelay<[NotificationApiData]>
    ) {
        if notificationsCache.value.first(where: { $0.userId == userId })?.isFollow == true {
            FollowService.unfollow(userId: userId)
                .request()
                .subscribe(
                    onSuccess: { [weak self] response in
                        switch response {
                        case .success(_):
                            if let newNotifications = self?.updateFollow(userId: userId, isFollow: false) {
                                self?.refreshOrUpdate(
                                    newNotifications: newNotifications,
                                    notificationsRefresh: notificationsRefresh,
                                    notificationsUpdate: notificationsUpdate
                                )
                            }
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
                            if let newNotifications = self?.updateFollow(userId: userId, isFollow: true) {
                                self?.refreshOrUpdate(
                                    newNotifications: newNotifications,
                                    notificationsRefresh: notificationsRefresh,
                                    notificationsUpdate: notificationsUpdate
                                )
                            }
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
    
    func updateFollow(
        userId: Int,
        isFollow: Bool
    ) -> [NotificationApiData] {
        notificationsCache.value
            .map({ (notification) -> NotificationApiData in
                var new = notification
                if new.userId == userId {
                    new.isFollow = isFollow
                }
                return new
            })
    }
    
    func refreshOrUpdate(
        newNotifications: [NotificationApiData],
        notificationsRefresh: PublishRelay<[NotificationApiData]>,
        notificationsUpdate: PublishRelay<[NotificationApiData]>
    ) {
        let notifications = newNotifications.sorted(by: { $0.timestamp > $1.timestamp })
        if notifications.count != notificationsCache.value.count {
            notificationsRefresh.accept(notifications)
        } else {
            let cachedNotifications = notificationsCache.value
            var isNotSame = false
            for i in 0 ..< notifications.count {
                if notifications[i].identity != cachedNotifications[i].identity {
                    isNotSame = true
                    break
                }
            }
            if isNotSame {
                notificationsRefresh.accept(notifications)
            } else {
                notificationsUpdate.accept(notifications)
            }
        }
        notificationsCache.accept(notifications)
    }
}
