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
}

public protocol UserViewModelOutputs {
    var users: Driver<[UserApiData]> { get }
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
    
    // MARK: - outputs
    
    var users: Driver<[UserApiData]>
    var selectedUser: Signal<UserApiData>
    var finishLoading: Signal<Bool>

    var inputs: UserViewModelInputs { self }
    var outputs: UserViewModelOutputs { self }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let userName = BehaviorRelay<String>(value: "")
        let selectedIndexPath = PublishRelay<IndexPath>()
        let refresh = PublishRelay<()>()
        
        let users = BehaviorRelay<[UserApiData]>(value: [])
        let selectedUser = PublishRelay<UserApiData>()
        let finishLoading = PublishRelay<Bool>()
        
        self.refresh = refresh
        self.viewDidLoad = viewDidLoad
        self.userName = userName
        self.selectedIndexPath = selectedIndexPath
        
        self.users = users.asDriver()
        self.selectedUser = selectedUser.asSignal()
        self.finishLoading = finishLoading.asSignal()
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: {
//                userName.accept("")
            })
            .disposed(by: disposeBag)
        
        userName
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] name in
                self?.getAllUsers(name: name, users: users, finishLoading: finishLoading)
            })
            .disposed(by: disposeBag)
        
        selectedIndexPath
            .map { indexPath in
                users.value[indexPath.row]
            }
            .bind(to: selectedUser)
            .disposed(by: disposeBag)
        
        refresh
            .subscribe(onNext: { 
                userName.accept(userName.value)
            })
            .disposed(by: disposeBag)
    }
    
    private func getAllUsers(
        name: String,
        users: BehaviorRelay<[UserApiData]>,
        finishLoading: PublishRelay<Bool>
    ) {
        UserService.getUsers(name: name)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    finishLoading.accept(false)
                    switch response {
                    case let .success(userApiResponse):
                        users.accept(userApiResponse.data)
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
        
//        let mockUsers = [
//            UserApiData(
//                userId: "001",
//                name: "Harry",
//                roi: 60.11111,
//                roiAnnual: 60.22222,
//                mdd: 60.33333,
//                dailyWinRate: 60.44444,
//                sharpeRatio: 60.55555
//            ),
//            UserApiData(
//                userId: "002",
//                name: "Stacey",
//                roi: 50.11111,
//                roiAnnual: 50.22222,
//                mdd: 50.33333,
//                dailyWinRate: 50.44444,
//                sharpeRatio: 50.55555
//            ),
//            UserApiData(
//                userId: "003",
//                name: "Angel",
//                roi: 40.11111,
//                roiAnnual: 40.22222,
//                mdd: 40.33333,
//                dailyWinRate: 40.44444,
//                sharpeRatio: 40.55555
//            )
//        ]
//        users.accept(mockUsers)
    }
}

