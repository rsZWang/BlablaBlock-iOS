//
//  HomePageViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/1.
//

import RxCocoa
import RxSwift
import Dispatch

public protocol HomePageViewModelInputs: AnyObject {
    var viewDidLoad: PublishRelay<()> { get }
    var viewWillAppear: PublishRelay<()> { get }
    var selectedCurrencyIndex: BehaviorRelay<Int> { get }
    var refresh: PublishRelay<()> { get }
    var followBtnTap: PublishRelay<Int> { get }
}

public protocol HomePageViewModelOutputs: BaseViewModelOutputs {
    var currencyList: Driver<[String]> { get }
    var notifications: Driver<[NotificationApiData]> { get }
    var isNotEmpty: Signal<Bool> { get }
    var refreshControl: Signal<Bool> { get }
}

public protocol HomePageViewModelType: AnyObject {
    var inputs: HomePageViewModelInputs { get }
    var outputs: HomePageViewModelOutputs { get }
}

final class HomePageViewModel:
    BaseViewModel,
    HomePageViewModelInputs,
    HomePageViewModelOutputs,
    HomePageViewModelType
{
    // MARK: - Inputs
    
    var viewDidLoad: PublishRelay<()>
    var viewWillAppear: PublishRelay<()>
    var selectedCurrencyIndex: BehaviorRelay<Int>
    var refresh: PublishRelay<()>
    var followBtnTap: PublishRelay<Int>
    
    // MARK: - Outputs
    
    var currencyList: Driver<[String]>
    var notifications: Driver<[NotificationApiData]>
    var isNotEmpty: Signal<Bool>
    var refreshControl: Signal<Bool>
    
    // MARK: - internals
    
    private let notificationsCache = BehaviorRelay<[NotificationApiData]>(value: [])
    
    var inputs: HomePageViewModelInputs { self }
    var outputs: HomePageViewModelOutputs { self }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let viewWillAppear = PublishRelay<()>()
        let selectedCurrencyIndex = BehaviorRelay<Int>(value: 0)
        let refresh = PublishRelay<()>()
        let followBtnTap = PublishRelay<Int>()
        
        self.viewDidLoad = viewDidLoad
        self.viewWillAppear = viewWillAppear
        self.selectedCurrencyIndex = selectedCurrencyIndex
        self.refresh = refresh
        self.followBtnTap = followBtnTap
        
        
        let currencyList = BehaviorRelay<[String]>(value: [])
        let notifications = PublishRelay<[NotificationApiData]>()
        let isNotEmpty = PublishRelay<Bool>()
        let refreshControl = PublishRelay<Bool>()
        
        self.currencyList = currencyList.asDriver()
        self.notifications = notifications.asDriver(onErrorJustReturn: [])
        self.isNotEmpty = isNotEmpty.asSignal()
        self.refreshControl = refreshControl.asSignal()
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: {
                if let userId = keychainUser[.userId] {
                    EventTracker.setUser(id: userId)
                }
            })
            .disposed(by: disposeBag)
        
        viewWillAppear
            .subscribe(onNext: { [weak self] in
                if self?.notificationsCache.value.isEmpty == true {
                    refreshControl.accept(true)
                    self?.loadNotifications(
                        currencyList: currencyList,
                        selectedCurrencyIndex: selectedCurrencyIndex,
                        isNotEmpty: isNotEmpty,
                        refreshControl: refreshControl
                    )
                }
            })
            .disposed(by: disposeBag)
        
        selectedCurrencyIndex
            .skip(1)
            .withLatestFrom(
                notificationsCache,
                resultSelector: { index, notifications in
                    let currency = currencyList.value[index]
                    if currency == "所有幣別" {
                        return notifications
                    } else {
                        return notifications.filter({ $0.baseCurrency == currency })
                    }
                }
            )
            .bind(to: notifications)
            .disposed(by: disposeBag)
        
        refresh
            .observe(on: backgroundScheduler)
            .subscribe(onNext: { [weak self] in
                EventTracker.Builder()
                    .logEvent(.REFRESH_HOME_PAGE)
                self?.loadNotifications(
                    currencyList: currencyList,
                    selectedCurrencyIndex: selectedCurrencyIndex,
                    isNotEmpty: isNotEmpty,
                    refreshControl: refreshControl
                )
            })
            .disposed(by: disposeBag)
        
        followBtnTap
            .debounce(.milliseconds(300), scheduler: backgroundScheduler)
            .observe(on: backgroundScheduler)
            .subscribe(onNext: { [weak self] userId in
                self?.follow(userId: userId, selectedCurrencyIndex: selectedCurrencyIndex)
            })
            .disposed(by: disposeBag)
    }
}

private extension HomePageViewModel {
    
    func loadNotifications(
        currencyList: BehaviorRelay<[String]>,
        selectedCurrencyIndex: BehaviorRelay<Int>,
        isNotEmpty: PublishRelay<Bool>,
        refreshControl: PublishRelay<Bool>
    ) {
        UserService.getNotifications()
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    refreshControl.accept(false)
                    switch response {
                    case let .success(historyApiResponse):
                        isNotEmpty.accept(historyApiResponse.data.isNotEmpty)
                        self?.updateNotifications(
                            currencyList: currencyList,
                            selectedCurrencyIndex: selectedCurrencyIndex,
                            newNotifications: historyApiResponse.data
                        )
                        refreshControl.accept(false)
                        
                    case let .failure(responseFailure):
                        refreshControl.accept(false)
                        self?.errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
                    }
                },
                onFailure: { [weak self] error in
                    refreshControl.accept(false)
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func updateNotifications(
        currencyList: BehaviorRelay<[String]>,
        selectedCurrencyIndex: BehaviorRelay<Int>,
        newNotifications: [NotificationApiData]
    ) {
        notificationsCache.accept(newNotifications)
        var newCurrencyList = Array(Set(newNotifications.map { $0.baseCurrency })).sorted(by: { $0 < $1 })
        newCurrencyList.insert("所有幣別", at: 0)
        if currencyList.value != newCurrencyList {
            currencyList.accept(newCurrencyList)
            selectedCurrencyIndex.accept(0)
        } else {
            selectedCurrencyIndex.accept(selectedCurrencyIndex.value)
        }
    }
    
    func follow(
        userId: Int,
        selectedCurrencyIndex: BehaviorRelay<Int>
    ) {
        func refreshNotifications(isFollow: Bool) {
            let newNotifications = updateFollow(userId: userId, isFollow: isFollow)
            notificationsCache.accept(newNotifications)
            selectedCurrencyIndex.accept(selectedCurrencyIndex.value)
        }
        
        if notificationsCache.value.first(where: { $0.userId == userId })?.isFollow == true {
            refreshNotifications(isFollow: false)
            FollowService.unfollow(userId: userId)
                .request()
                .subscribe(
                    onSuccess: { [weak self] response in
                        switch response {
                        case .success(_):
                            break
                        case let .failure(responseFailure):
                            self?.errorCodeHandler(responseFailure)
                            refreshNotifications(isFollow: true)
                        }
                    },
                    onFailure: { [weak self] error in
                        self?.errorHandler(error: error)
                        refreshNotifications(isFollow: true)
                    }
                )
                .disposed(by: disposeBag)
        } else {
            refreshNotifications(isFollow: true)
            FollowService.follow(userId: userId)
                .request()
                .subscribe(
                    onSuccess: { [weak self] response in
                        switch response {
                        case .success(_):
                            break
                        case let .failure(responseFailure):
                            self?.errorCodeHandler(responseFailure)
                            refreshNotifications(isFollow: false)
                        }
                    },
                    onFailure: { [weak self] error in
                        self?.errorHandler(error: error)
                        refreshNotifications(isFollow: false)
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
}
