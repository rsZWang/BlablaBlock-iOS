//
//  FollowViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import RxCocoa
import RxSwift

public protocol FollowViewModelInputs {
    var viewWillAppear: PublishRelay<()> { get }
    var userId: BehaviorRelay<Int?> { get }
}

public protocol FollowViewModelOutputs {
    var followerAmount: Signal<Int> { get }
    var followingAmount: Signal<Int> { get }
    var followers: Driver<[FollowApiDataFollowUser]> { get }
    var followings: Driver<[FollowApiDataFollowUser]> { get }
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
    
    var viewWillAppear: PublishRelay<()>
    var userId: BehaviorRelay<Int?>
    
    // MARK: - outputs
    
    var followerAmount: Signal<Int>
    var followingAmount: Signal<Int>
    var followers: Driver<[FollowApiDataFollowUser]>
    var followings: Driver<[FollowApiDataFollowUser]>
    
    var inputs: FollowViewModelInputs { self }
    var outputs: FollowViewModelOutputs { self }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewWillAppear = PublishRelay<()>()
        let userId = BehaviorRelay<Int?>(value: nil)
        let followerAmount = PublishRelay<Int>()
        let followingAmount = PublishRelay<Int>()
        let followers = BehaviorRelay<[FollowApiDataFollowUser]>(value: [])
        let followings = BehaviorRelay<[FollowApiDataFollowUser]>(value: [])
        
        self.viewWillAppear = viewWillAppear
        self.userId = userId
        self.followerAmount = followerAmount.asSignal()
        self.followingAmount = followingAmount.asSignal()
        self.followers = followers.asDriver()
        self.followings = followings.asDriver()
        
        super.init()
        
        viewWillAppear
            .subscribe(onNext: { [weak self] in
                self?.getFollowers(
                    followerAmount: followerAmount,
                    followingAmount: followingAmount,
                    followers: followers,
                    followings: followings
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func getFollowers(
        followerAmount: PublishRelay<Int>,
        followingAmount: PublishRelay<Int>,
        followers: BehaviorRelay<[FollowApiDataFollowUser]>,
        followings: BehaviorRelay<[FollowApiDataFollowUser]>
    ) {
        let target: Single<HttpResponse<FollowApi, ResponseFailure>>
        if let userId = userId.value {
            target = UserService.getFollowerByID(userId: userId)
                .request()
        } else {
            target = FollowService.getFollower()
                .request()
        }
        target.subscribe(
            onSuccess: { [weak self] response in
                switch response {
                case let .success(followerApiResponse):
                    let data = followerApiResponse.data
                    followerAmount.accept(data.followers.count)
                    followingAmount.accept(data.followings.count)
                    followers.accept(data.followers.list)
                    followings.accept(data.followings.list)
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
