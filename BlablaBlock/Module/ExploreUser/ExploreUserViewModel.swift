//
//  ExploreUserViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import Foundation
import RxCocoa

public protocol ExploreUserViewModelInputs {
    var viewDidLoad: PublishRelay<()> { get }
    var userName: BehaviorRelay<String> { get }
    var selectedIndexPath: PublishRelay<IndexPath> { get }
    var refresh: PublishRelay<()> { get }
}

public protocol ExploreUserViewModelOutputs {
    var users: Driver<[UserApiData]> { get }
    var isNotEmpty: Driver<Bool> { get }
    var selectedUser: Signal<UserApiData> { get }
    var refreshControl: Signal<Bool> { get }
}

public protocol ExploreUserViewModelType {
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
    
    // MARK: - outputs
    
    var users: Driver<[UserApiData]>
    var isNotEmpty: Driver<Bool>
    var selectedUser: Signal<UserApiData>
    var refreshControl: Signal<Bool>
    
    // MARK: - internals
    private let name: PublishRelay<String>

    var inputs: ExploreUserViewModelInputs { self }
    var outputs: ExploreUserViewModelOutputs { self }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let userName = BehaviorRelay<String>(value: "")
        let selectedIndexPath = PublishRelay<IndexPath>()
        let refresh = PublishRelay<()>()
        
        let users = BehaviorRelay<[UserApiData]>(value: [])
        let isNotEmpty = BehaviorRelay<Bool>(value: true)
        let selectedUser = PublishRelay<UserApiData>()
        let refreshControl = PublishRelay<Bool>()
        
        let name = PublishRelay<String>()
        
        self.refresh = refresh
        self.viewDidLoad = viewDidLoad
        self.userName = userName
        self.selectedIndexPath = selectedIndexPath
        
        self.users = users.asDriver()
        self.isNotEmpty = isNotEmpty.asDriver()
        self.selectedUser = selectedUser.asSignal()
        self.refreshControl = refreshControl.asSignal()
        
        self.name = name
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: {
                refreshControl.accept(true)
                name.accept("")
            })
            .disposed(by: disposeBag)
        
        userName
            .subscribe(onNext: { userName in
                EventTracker.Builder()
                    .logEvent(.REFRESH_EXPLORE_PAGE)
                name.accept(userName)
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
                Timber.i("refresh refresh refresh")
                EventTracker.Builder()
                    .logEvent(.REFRESH_EXPLORE_PAGE)
                name.accept(userName.value)
            })
            .disposed(by: disposeBag)
        
        name
            .subscribe(onNext: { [weak self] name in
                self?.getAllUsers(
                    name: name,
                    users: users,
                    isNotEmpty: isNotEmpty,
                    refreshControl: refreshControl
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func getAllUsers(
        name: String,
        users: BehaviorRelay<[UserApiData]>,
        isNotEmpty: BehaviorRelay<Bool>,
        refreshControl: PublishRelay<Bool>
    ) {
        UserService.getUsers(name: name)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    refreshControl.accept(false)
                    switch response {
                    case let .success(userApiResponse):
                        users.accept(userApiResponse.data.shuffled())
                        isNotEmpty.accept(userApiResponse.data.isNotEmpty)
                    case let .failure(responseFailure):
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
}

