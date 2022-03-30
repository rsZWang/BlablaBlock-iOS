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
    var viewWillAppear: PublishRelay<()> { get }
    var currencySelected: BehaviorRelay<String> { get }
    var refresh: PublishRelay<()> { get }
    var followBtnTap: PublishRelay<Int> { get }
}

public protocol HomeViewModelOutputs: NSObject {
    var currencyList: Signal<[String]> { get }
    var selectedCurrency: Signal<String> { get }
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
    
    var viewDidLoad: PublishRelay<()>
    var viewWillAppear: PublishRelay<()>
    var currencySelected: BehaviorRelay<String>
    var refresh: PublishRelay<()>
    var followBtnTap: PublishRelay<Int>
    
    // MARK: - Outputs
    
    var currencyList: Signal<[String]>
    var selectedCurrency: Signal<String>
    var notificationsRefresh: Signal<[NotificationApiData]>
    var notificationsUpdate: Signal<[NotificationApiData]>
    var isNotEmpty: Signal<Bool>
    var isRefreshing: Signal<Bool>
    
    // MARK: - internals
    
    private let notificationsCache = BehaviorRelay<[NotificationApiData]>(value: [])
    private let currencyListCache = BehaviorRelay<[String]>(value: [])
    
    var inputs: HomeViewModelInputs { self }
    var outputs: HomeViewModelOutputs { self }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let viewWillAppear = PublishRelay<()>()
        let currencySelected = BehaviorRelay<String>(value: "所有幣別")
        let refresh = PublishRelay<()>()
        let followBtnTap = PublishRelay<Int>()
        
        let currencyList = PublishRelay<[String]>()
        let selectedCurrency = PublishRelay<String>()
        let notificationsRefresh = PublishRelay<[NotificationApiData]>()
        let notificationsUpdate = PublishRelay<[NotificationApiData]>()
        let isNotEmpty = PublishRelay<Bool>()
        let isRefreshing = PublishRelay<Bool>()
        
        self.viewDidLoad = viewDidLoad
        self.viewWillAppear = viewWillAppear
        self.currencySelected = currencySelected
        self.refresh = refresh
        self.followBtnTap = followBtnTap
        
        self.currencyList = currencyList.asSignal()
        self.selectedCurrency = selectedCurrency.asSignal()
        self.notificationsRefresh = notificationsRefresh.asSignal()
        self.notificationsUpdate = notificationsUpdate.asSignal()
        self.isNotEmpty = isNotEmpty.asSignal()
        self.isRefreshing = isRefreshing.asSignal()
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: {
                if let userId = keychainUser[.userId] {
                    EventTracker.setUser(id: userId)
                }
                selectedCurrency.accept("所有幣別")
            })
            .disposed(by: disposeBag)
        
        viewWillAppear
            .subscribe(onNext: { [weak self] in
                if self?.notificationsCache.value.isEmpty == true {
                    isRefreshing.accept(true)
                    self?.loadNotifications(
                        currencySelected: currencySelected,
                        currencyList: currencyList,
                        selectedCurrency: selectedCurrency,
                        notificationsRefresh: notificationsRefresh,
                        notificationsUpdate: notificationsUpdate,
                        isNotEmpty: isNotEmpty,
                        isRefreshing: isRefreshing
                    )
                }
            })
            .disposed(by: disposeBag)
        
        currencySelected
            .subscribe(onNext: { [weak self] currency in
                selectedCurrency.accept(currency)
                if let notifications = self?.notificationsCache.value {
                    if currency == "所有幣別" {
                        notificationsRefresh.accept(notifications)
                    } else {
                        notificationsRefresh.accept(notifications.filter({ $0.baseCurrency == currency }))
                    }
                }
            })
            .disposed(by: disposeBag)
        
        refresh
            .subscribe(onNext: { [weak self] in
                EventTracker.Builder()
                    .logEvent(.REFRESH_HOME_PAGE)
                self?.loadNotifications(
                    currencySelected: currencySelected,
                    currencyList: currencyList,
                    selectedCurrency: selectedCurrency,
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
                    currencySelected: currencySelected,
                    currencyList: currencyList,
                    selectedCurrency: selectedCurrency,
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
        currencySelected: BehaviorRelay<String>,
        currencyList: PublishRelay<[String]>,
        selectedCurrency: PublishRelay<String>,
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
                            currencySelected: currencySelected,
                            currencyList: currencyList,
                            selectedCurrency: selectedCurrency,
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
        currencySelected: BehaviorRelay<String>,
        currencyList: PublishRelay<[String]>,
        selectedCurrency: PublishRelay<String>,
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
                                    currencySelected: currencySelected,
                                    currencyList: currencyList,
                                    selectedCurrency: selectedCurrency,
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
                                    currencySelected: currencySelected,
                                    currencyList: currencyList,
                                    selectedCurrency: selectedCurrency,
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
        currencySelected: BehaviorRelay<String>,
        currencyList: PublishRelay<[String]>,
        selectedCurrency: PublishRelay<String>,
        newNotifications: [NotificationApiData],
        notificationsRefresh: PublishRelay<[NotificationApiData]>,
        notificationsUpdate: PublishRelay<[NotificationApiData]>
    ) {
        var newCurrencyList = newNotifications.map { $0.baseCurrency }.unique().sorted(by: { $0 < $1 })
        newCurrencyList.insert("所有幣別", at: 0)
        if !newCurrencyList.contains(currencySelected.value) {
            currencySelected.accept("所有幣別")
            selectedCurrency.accept("所有幣別")
        }
        currencyList.accept(newCurrencyList)
        
        let sortedNotifications = newNotifications.sorted(by: { $0.timestamp > $1.timestamp })
        
        let cachedNotifications: [NotificationApiData]
        let notifications: [NotificationApiData]
        if currencySelected.value != "所有幣別" {
            cachedNotifications = notificationsCache.value.filter({ $0.currency == currencySelected.value })
            notifications = sortedNotifications.filter({ $0.currency == currencySelected.value })
        } else {
            cachedNotifications = notificationsCache.value
            notifications = sortedNotifications
        }
        
        if notifications.count != cachedNotifications.count {
            notificationsRefresh.accept(notifications)
        } else {
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
        
        notificationsCache.accept(sortedNotifications)
    }
}
