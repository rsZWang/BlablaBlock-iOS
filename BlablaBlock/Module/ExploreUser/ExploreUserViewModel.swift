//
//  ExploreUserViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import Foundation
import RxCocoa
import RxSwift

public protocol ExploreUserViewModelInputs: AnyObject {
    var viewDidLoad: PublishRelay<()> { get }
    var userName: BehaviorRelay<String> { get }
    var selectedIndexPath: PublishRelay<IndexPath> { get }
    var refresh: PublishRelay<()> { get }
    var filter: BehaviorRelay<ExploreUserFilter> { get }
    var followBtnTap: PublishRelay<Int> { get }
}

public protocol ExploreUserViewModelOutputs: BaseViewModelOutputs {
    var users: Driver<[UserPerformanceApiData]> { get }
    var isNotEmpty: Driver<Bool> { get }
    var selectedUser: Signal<UserPerformanceApiData> { get }
    var refreshControl: Signal<Bool> { get }
}

public protocol ExploreUserViewModelType: AnyObject {
    var inputs: ExploreUserViewModelInputs { get }
    var outputs: ExploreUserViewModelOutputs { get }
}

final class ExploreUserViewModel:
    BaseViewModel,
    ExploreUserViewModelInputs,
    ExploreUserViewModelOutputs,
    ExploreUserViewModelType
{

    // MARK: - inputs

    var viewDidLoad: PublishRelay<()>
    var userName: BehaviorRelay<String>
    var selectedIndexPath: PublishRelay<IndexPath>
    var refresh: PublishRelay<()>
    var filter: BehaviorRelay<ExploreUserFilter>
    var followBtnTap: PublishRelay<Int>
    
    // MARK: - outputs
    
    var users: Driver<[UserPerformanceApiData]>
    var isNotEmpty: Driver<Bool>
    var selectedUser: Signal<UserPerformanceApiData>
    var refreshControl: Signal<Bool>

    var inputs: ExploreUserViewModelInputs { self }
    var outputs: ExploreUserViewModelOutputs { self }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let userName = BehaviorRelay<String>(value: "")
        let selectedIndexPath = PublishRelay<IndexPath>()
        let refresh = PublishRelay<()>()
        let filter = BehaviorRelay<ExploreUserFilter>(value: .random)
        let followBtnTap = PublishRelay<Int>()
        
        let users = BehaviorRelay<[UserPerformanceApiData]>(value: [])
        let isNotEmpty = BehaviorRelay<Bool>(value: true)
        let selectedUser = PublishRelay<UserPerformanceApiData>()
        let refreshControl = PublishRelay<Bool>()
        
        self.refresh = refresh
        self.viewDidLoad = viewDidLoad
        self.userName = userName
        self.selectedIndexPath = selectedIndexPath
        self.filter = filter
        self.followBtnTap = followBtnTap
        
        self.users = users.asDriver()
        self.isNotEmpty = isNotEmpty.asDriver()
        self.selectedUser = selectedUser.asSignal()
        self.refreshControl = refreshControl.asSignal()
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: {

            })
            .disposed(by: disposeBag)
        
        userName
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .observe(on: backgroundScheduler)
            .subscribe(onNext: { [weak self] name in
                EventTracker.Builder()
                    .logEvent(.REFRESH_EXPLORE_PAGE)
                self?.getUserPerformance(
                    name: name,
                    users: users,
                    isNotEmpty: isNotEmpty,
                    refreshControl: refreshControl,
                    filter: filter
                )
            })
            .disposed(by: disposeBag)
        
        selectedIndexPath
            .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .map { users.value[$0.row] }
            .subscribe(onNext: { user in
                EventTracker.Builder()
                    .setProperty(name: .USER_B, value: user.userId)
                    .logEvent(.CHECK_OTHERS_PROFILE)
                selectedUser.accept(user)
            })
            .disposed(by: disposeBag)
        
        refresh
            .withLatestFrom(userName)
            .subscribe(onNext: { [weak self] name in
                EventTracker.Builder()
                    .logEvent(.REFRESH_EXPLORE_PAGE)
                self?.getUserPerformance(
                    name: name,
                    users: users,
                    isNotEmpty: isNotEmpty,
                    refreshControl: refreshControl,
                    filter: filter
                )
            })
            .disposed(by: disposeBag)
        
        filter
            .subscribe(onNext: { [weak self] filter in
                EventTracker.Builder()
                    .setProperty(name: .method, value: filter.rawValue)
                    .logEvent(.SORT_PORFILES_EXPLORE_PAGE)
                self?.doFilter(data: users.value, users: users, filter: filter)
            })
            .disposed(by: disposeBag)
        
        followBtnTap
            .debounce(.milliseconds(300), scheduler: backgroundScheduler)
            .subscribe(onNext: { [weak self] userId in
                self?.follow(users: users, userId: userId)
            })
            .disposed(by: disposeBag)
    }
    
    private func getUserPerformance(
        name: String,
        users: BehaviorRelay<[UserPerformanceApiData]>,
        isNotEmpty: BehaviorRelay<Bool>,
        refreshControl: PublishRelay<Bool>,
        filter: BehaviorRelay<ExploreUserFilter>
    ) {
        UserService.getUserPerformance(userId: Int(keychainUser[.userId]!)!, sort: .totalValue)
            .subscribe(
                onSuccess: { [weak self] response in
                    refreshControl.accept(false)
                    switch response {
                    case let .success(userApiResponse):
                        self?.doFilter(data: userApiResponse.data, users: users, filter: filter.value)
                        if name.isEmpty {
                            isNotEmpty.accept(userApiResponse.data.isNotEmpty)
                        }
                    case let .failure(responseFailure):
                        self?.errorCodeHandler(responseFailure)
                    }
                },
                onFailure: { [weak self] error in
                    refreshControl.accept(false)
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func doFilter(
        data: [UserPerformanceApiData],
        users: BehaviorRelay<[UserPerformanceApiData]>,
        filter: ExploreUserFilter
    ) {
        switch filter {
        case .random:
            users.accept(data.shuffled())
        case .asset:
            users.accept(data.sorted(by: { $0.totalValue > $1.totalValue }))
        case .profit:
            users.accept(data.sorted(by: { $0.roi > $1.roi }))
        case .sharp:
            users.accept(data.sorted(by: { $0.sharpeRatio > $1.sharpeRatio }))
        }
    }
    
    private func follow(
        users: BehaviorRelay<[UserPerformanceApiData]>,
        userId: Int
    ) {
        func refreshUsers(isFollow: Bool) {
            if let index = users.value.firstIndex(where: { $0.userId == userId }) {
                var user = users.value[index]
                user.isFollowing = isFollow
                var newList = users.value
                newList.remove(at: index)
                newList.insert(user, at: index)
                users.accept(newList)
            }
        }
        
        if users.value.first(where: { $0.userId == userId })?.isFollowing == true {
            refreshUsers(isFollow: false)
            FollowService.unfollow(userId: userId)
                .subscribe(
                    onSuccess: { [weak self] response in
                        switch response {
                        case .success(_):
                            break
                        case let .failure(responseFailure):
                            self?.errorCodeHandler(responseFailure)
                            refreshUsers(isFollow: true)
                        }
                    },
                    onFailure: { [weak self] error in
                        self?.errorHandler(error: error)
                        refreshUsers(isFollow: true)
                    }
                )
                .disposed(by: disposeBag)
        } else {
            refreshUsers(isFollow: true)
            FollowService.follow(userId: userId)
                .subscribe(
                    onSuccess: { [weak self] response in
                        switch response {
                        case .success(_):
                            break
                        case let .failure(responseFailure):
                            self?.errorCodeHandler(responseFailure)
                            refreshUsers(isFollow: false)
                        }
                    },
                    onFailure: { [weak self] error in
                        self?.errorHandler(error: error)
                        refreshUsers(isFollow: false)
                    }
                )
                .disposed(by: disposeBag)
        }
    }
}

