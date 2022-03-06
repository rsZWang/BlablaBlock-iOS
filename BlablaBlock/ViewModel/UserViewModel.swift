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
}

public protocol UserViewModelOutputs {
    var users: Driver<[UserApiData]> { get }
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
    
    // MARK: - outputs
    
    var users: Driver<[UserApiData]>

    var inputs: UserViewModelInputs { self }
    var outputs: UserViewModelOutputs { self }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let userName = BehaviorRelay<String>(value: "")
        let users = BehaviorRelay<[UserApiData]>(value: [])
        
        self.viewDidLoad = viewDidLoad
        self.userName = userName
        self.users = users.asDriver()
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: {
//                userName.accept("")
            })
            .disposed(by: disposeBag)
        
        userName
            .compactMap { $0 }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] name in
                self?.getAllUsers(name: name, users: users)
            })
            .disposed(by: disposeBag)
    }
    
    private func getAllUsers(name: String, users: BehaviorRelay<[UserApiData]>) {
        UserService.getUsers(name: name)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(userApiResponse):
                        users.accept(userApiResponse.data)
                    case let .failure(responseFailure):
                        self?.errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
                    }
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
        
        let mockUsers = [
            UserApiData(
                userId: "001",
                name: "Harry",
                roi: 60.11111,
                roiAnnual: 60.22222,
                mdd: 60.33333,
                dailyWinRate: 60.44444,
                sharpeRatio: 60.55555
            ),
            UserApiData(
                userId: "002",
                name: "Stacey",
                roi: 50.11111,
                roiAnnual: 50.22222,
                mdd: 50.33333,
                dailyWinRate: 50.44444,
                sharpeRatio: 50.55555
            ),
            UserApiData(
                userId: "003",
                name: "Angel",
                roi: 40.11111,
                roiAnnual: 40.22222,
                mdd: 40.33333,
                dailyWinRate: 40.44444,
                sharpeRatio: 40.55555
            )
        ]
        users.accept(mockUsers)
    }
}

