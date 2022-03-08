//
//  FollowViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import RxCocoa
import RxSwift

public protocol FollowViewModelInputs {
    var viewDidLoad: PublishRelay<()> { get }
}

public protocol FollowViewModelOutputs {
    var followers: Driver<[FollowerApiDataUser]> { get }
    var followings: Driver<[FollowerApiDataUser]> { get }
}

public protocol FollowViewModelType {
    var inputs: FollowViewModelInputs { get }
    var outputs: FollowViewModelOutputs { get }
}

final class FollowViewModel:
    BaseViewModel,
    FollowViewModelInputs,
    FollowViewModelOutputs,
    FollowViewModelType
{
    // MARK: - inputs
    
    var viewDidLoad: PublishRelay<()>
    
    // MARK: - outputs
    
    var followers: Driver<[FollowerApiDataUser]>
    var followings: Driver<[FollowerApiDataUser]>
    
    var inputs: FollowViewModelInputs { self }
    var outputs: FollowViewModelOutputs { self }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let followers = BehaviorRelay<[FollowerApiDataUser]>(value: [])
        let followings = BehaviorRelay<[FollowerApiDataUser]>(value: [])
        
        self.viewDidLoad = viewDidLoad
        self.followers = followers.asDriver()
        self.followings = followings.asDriver()
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.loadFollowers(followers: followers, followings: followings)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadFollowers(
        followers: BehaviorRelay<[FollowerApiDataUser]>,
        followings: BehaviorRelay<[FollowerApiDataUser]>
    ) {
        FollowService.getFollower()
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(followerApiResponse):
                        let data = followerApiResponse.data
                        followers.accept(data.followers)
                        followings.accept(data.followings)
                    case let .failure(responseFailure):
                        self?.errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
                    }
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
        
//        let followers_data = [
//            FollowerApiDataUser(
//                userId: "001",
//                name: "小花",
//                isFollow: true
//            ),
//            FollowerApiDataUser(
//                userId: "002",
//                name: "小明",
//                isFollow: false
//            ),
//            FollowerApiDataUser(
//                userId: "003",
//                name: "小華",
//                isFollow: true
//            )
//        ]
//        followers.accept(followers_data)
//
//        let followings_data = [
//            FollowerApiDataUser(
//                userId: "003",
//                name: "小華",
//                isFollow: true
//            ),
//            FollowerApiDataUser(
//                userId: "002",
//                name: "小強",
//                isFollow: true
//            ),
//            FollowerApiDataUser(
//                userId: "001",
//                name: "小花",
//                isFollow: true
//            )
//        ]
//        followings.accept(followings_data)
    }
}
