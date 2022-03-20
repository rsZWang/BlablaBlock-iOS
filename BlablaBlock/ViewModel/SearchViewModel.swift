//
//  SearchViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import Foundation
import RxCocoa

public protocol SearchViewModelInputs {
    var viewDidLoad: PublishRelay<()> { get }
    var userName: BehaviorRelay<String> { get }
    var selectedIndexPath: PublishRelay<IndexPath> { get }
    var refresh: PublishRelay<()> { get }
}

public protocol SearchViewModelOutputs {
    var users: Driver<[UserApiData]> { get }
    var selectedUser: Signal<UserApiData> { get }
    var finishLoading: Signal<Bool> { get }
}

public protocol SearchViewModelType {
    var inputs: SearchViewModelInputs { get }
    var outputs: SearchViewModelOutputs { get }
}

final class SearchViewModel:
    BaseViewModel,
    SearchViewModelInputs,
    SearchViewModelOutputs,
    SearchViewModelType
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

    var inputs: SearchViewModelInputs { self }
    var outputs: SearchViewModelOutputs { self }
    
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
    }
}

