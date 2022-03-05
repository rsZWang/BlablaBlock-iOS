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
    
    // MARK: - outputs
    
    var users: Driver<[UserApiData]>

    var inputs: UserViewModelInputs { self }
    var outputs: UserViewModelOutputs { self }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let users = BehaviorRelay<[UserApiData]>(value: [])
        
        self.viewDidLoad = viewDidLoad
        self.users = users.asDriver()
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.getAllUsers(users: users)
            })
            .disposed(by: disposeBag)
    }
    
    private func getAllUsers(users: BehaviorRelay<[UserApiData]>) {
        UserService.getUsers(name: "")
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(userApiResponse):
                        users.accept(userApiResponse.data)
//                        let data = followerApiResponse.data
//                        followers.accept(data.followers)
//                        followings.accept(data.followings)
                    case let .failure(responseFailure):
                        self?.errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
                    }
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
}

