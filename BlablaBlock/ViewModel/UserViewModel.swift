//
//  UserViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import Foundation
import RxCocoa

public protocol UserViewModelInputs {
    var viewDidLoad: PublishRelay<()> { get }
    var userName: BehaviorRelay<String> { get }
    var selectedIndexPath: PublishRelay<IndexPath> { get }
    var refresh: PublishRelay<()> { get }
    var filter: BehaviorRelay<SearchUserFilter> { get }
}

public protocol UserViewModelOutputs {
    var users: Driver<[UserApiData]> { get }
    var isNotEmpty: Driver<Bool> { get }
    var selectedUser: Signal<UserApiData> { get }
    var finishLoading: Signal<Bool> { get }
}

public protocol UserViewModelType {
    var inputs: UserViewModelInputs { get }
    var outputs: UserViewModelOutputs { get }
}

final class UserViewModel:
    BaseViewModel,
    UserViewModelInputs,
    UserViewModelOutputs,
    UserViewModelType
{

    // MARK: - inputs

    var viewDidLoad: PublishRelay<()>
    var userName: BehaviorRelay<String>
    var selectedIndexPath: PublishRelay<IndexPath>
    var refresh: PublishRelay<()>
    var filter: BehaviorRelay<SearchUserFilter>
    
    // MARK: - outputs
    
    var users: Driver<[UserApiData]>
    var isNotEmpty: Driver<Bool>
    var selectedUser: Signal<UserApiData>
    var finishLoading: Signal<Bool>

    var inputs: UserViewModelInputs { self }
    var outputs: UserViewModelOutputs { self }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let userName = BehaviorRelay<String>(value: "")
        let selectedIndexPath = PublishRelay<IndexPath>()
        let refresh = PublishRelay<()>()
        let filter = BehaviorRelay<SearchUserFilter>(value: .random)
        
        let users = BehaviorRelay<[UserApiData]>(value: [])
        let isNotEmpty = BehaviorRelay<Bool>(value: true)
        let selectedUser = PublishRelay<UserApiData>()
        let finishLoading = PublishRelay<Bool>()
        
        self.refresh = refresh
        self.viewDidLoad = viewDidLoad
        self.userName = userName
        self.selectedIndexPath = selectedIndexPath
        self.filter = filter
        
        self.users = users.asDriver()
        self.isNotEmpty = isNotEmpty.asDriver()
        self.selectedUser = selectedUser.asSignal()
        self.finishLoading = finishLoading.asSignal()
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: {

            })
            .disposed(by: disposeBag)
        
        userName
            .skip(1)
            .subscribe(onNext: { [weak self] name in
                EventTracker.Builder()
                    .logEvent(.REFRESH_EXPLORE_PAGE)
                self?.getAllUsers(
                    name: name,
                    users: users,
                    isNotEmpty: isNotEmpty,
                    finishLoading: finishLoading,
                    filter: filter
                )
            })
            .disposed(by: disposeBag)
        
        selectedIndexPath
            .map { users.value[$0.row] }
            .subscribe(onNext: { user in
                EventTracker.Builder()
                    .setProperty(name: .USER_B, value: user.userId)
                    .logEvent(.CHECK_OTHERS_PROFILE)
                selectedUser.accept(user)
            })
            .disposed(by: disposeBag)
        
        refresh
            .subscribe(onNext: { 
                userName.accept(userName.value)
            })
            .disposed(by: disposeBag)
        
        filter
            .subscribe(onNext: { [weak self] filter in
                EventTracker.Builder()
                    .logEvent(.SORT_PORFILES_EXPLORE_PAGE)
                self?.doFilter(data: users.value, users: users, filter: filter)
            })
            .disposed(by: disposeBag)
    }
    
    private func getAllUsers(
        name: String,
        users: BehaviorRelay<[UserApiData]>,
        isNotEmpty: BehaviorRelay<Bool>,
        finishLoading: PublishRelay<Bool>,
        filter: BehaviorRelay<SearchUserFilter>
    ) {
        UserService.getUsers(name: name)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    finishLoading.accept(false)
                    switch response {
                    case let .success(userApiResponse):
                        self?.doFilter(data: userApiResponse.data, users: users, filter: filter.value)
                        isNotEmpty.accept(userApiResponse.data.isNotEmpty)
                    case let .failure(responseFailure):
                        self?.errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
                    }
                },
                onFailure: { [weak self] error in
                    finishLoading.accept(false)
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func doFilter(
        data: [UserApiData],
        users: BehaviorRelay<[UserApiData]>,
        filter: SearchUserFilter
    ) {
        switch filter {
        case .random:
            users.accept(data.shuffled())
        case .asset:
            users.accept(data.sorted(by: { $0.totalValue > $1.totalValue }))
        case .profit:
            users.accept(data.sorted(by: { $0.roi ?? 0 > $1.roi ?? 0 }))
        case .winRate:
            users.accept(data.sorted(by: { $0.dailyWinRate ?? 0 > $1.dailyWinRate ?? 0 }))
        case .sharp:
            users.accept(data.sorted(by: { $0.sharpeRatio ?? 0 > $1.sharpeRatio ?? 0 }))
        }
    }
}

