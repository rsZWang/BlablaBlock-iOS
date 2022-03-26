//
//  FollowViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import RxCocoa
import RxSwift

public protocol FollowViewModelInputs {
    var user: BehaviorRelay<UserApiData?> { get }
    var viewWillAppear: PublishRelay<()> { get }
    var followBtnTap: PublishRelay<()> { get }
    var followerFollowBtnTap: PublishRelay<Int> { get }
    var followingFollowBtnTap: PublishRelay<Int> { get }
    var followCellTap: PublishRelay<FollowApiDataFollowUser> { get }
}

public protocol FollowViewModelOutputs {
    var user: BehaviorRelay<UserApiData?> { get }
    var followerAmount: Signal<Int> { get }
    var followingAmount: Signal<Int> { get }
    var followers: Driver<[FollowApiDataFollowUser]> { get }
    var followings: Driver<[FollowApiDataFollowUser]> { get }
    var showUser: Signal<UserApiData> { get }
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
    
    var user: BehaviorRelay<UserApiData?>
    var viewWillAppear: PublishRelay<()>
    var followBtnTap: PublishRelay<()>
    var followerFollowBtnTap: PublishRelay<Int>
    var followingFollowBtnTap: PublishRelay<Int>
    var followCellTap: PublishRelay<FollowApiDataFollowUser>
    
    // MARK: - outputs
    
    var followerAmount: Signal<Int>
    var followingAmount: Signal<Int>
    var followers: Driver<[FollowApiDataFollowUser]>
    var followings: Driver<[FollowApiDataFollowUser]>
    var showUser: Signal<UserApiData>
    
    var inputs: FollowViewModelInputs { self }
    var outputs: FollowViewModelOutputs { self }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let user = BehaviorRelay<UserApiData?>(value: nil)
        let viewWillAppear = PublishRelay<()>()
        let followBtnTap = PublishRelay<()>()
        let followerFollowBtnTap = PublishRelay<Int>()
        let followingFollowBtnTap = PublishRelay<Int>()
        let followCellTap = PublishRelay<FollowApiDataFollowUser>()
        
        let followerAmount = PublishRelay<Int>()
        let followingAmount = PublishRelay<Int>()
        let followers = BehaviorRelay<[FollowApiDataFollowUser]>(value: [])
        let followings = BehaviorRelay<[FollowApiDataFollowUser]>(value: [])
        let showUser = PublishRelay<UserApiData>()
        
        self.user = user
        self.viewWillAppear = viewWillAppear
        self.followBtnTap = followBtnTap
        self.followerFollowBtnTap = followerFollowBtnTap
        self.followingFollowBtnTap = followingFollowBtnTap
        self.followCellTap = followCellTap
        
        self.user = user
        self.followerAmount = followerAmount.asSignal()
        self.followingAmount = followingAmount.asSignal()
        self.followers = followers.asDriver()
        self.followings = followings.asDriver()
        self.showUser = showUser.asSignal()
        
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
        
        followBtnTap
            .subscribe(onNext: { [weak self] in
                Timber.i("followBtnTap")
                if let user = self?.user.value {
                    self?.follow(user)
                }
            })
            .disposed(by: disposeBag)
        
        followerFollowBtnTap
            .subscribe(onNext: { [weak self] userId in
                self?.follow(id: userId, follow: followers)
            })
            .disposed(by: disposeBag)
        
        followingFollowBtnTap
            .subscribe(onNext: { [weak self] userId in
                self?.follow(id: userId, follow: followings)
            })
            .disposed(by: disposeBag)
        
        followCellTap
            .filter { $0.userId != Int(keychainUser[.userId] ?? "-1") }
            .map {
                UserApiData(
                    userId: $0.userId,
                    name: $0.name,
                    totalValue: 0,
                    roi: 0,
                    roiAnnual: 0,
                    mdd: 0,
                    dailyWinRate: 0,
                    sharpeRatio: 0,
                    isFollow: $0.isFollow
                )
            }
            .bind(to: showUser)
            .disposed(by: disposeBag)
    }
}

private extension FollowViewModel {
    func getFollowers(
        followerAmount: PublishRelay<Int>,
        followingAmount: PublishRelay<Int>,
        followers: BehaviorRelay<[FollowApiDataFollowUser]>,
        followings: BehaviorRelay<[FollowApiDataFollowUser]>
    ) {
        let target: Single<HttpResponse<FollowApi, ResponseFailure>>
        if let userId = user.value?.userId {
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
    
    func follow(_ user: UserApiData) {
        if user.isFollow {
            FollowService.unfollow(userId: user.userId)
                .request()
                .subscribe(
                    onSuccess: { [weak self] response in
                        switch response {
                        case .success(_):
                            var user = user
                            user.isFollow = false
                            self?.user.accept(user)
                            self?.viewWillAppear.accept(())
                        case let .failure(responseFailure):
                            self?.errorCodeHandler(responseFailure)
                        }
                    },
                    onFailure: { [weak self] error in
                        self?.errorHandler(error: error)
                    }
                )
                .disposed(by: disposeBag)
        } else {
            FollowService.follow(userId: user.userId)
                .request()
                .subscribe(
                    onSuccess: { [weak self] response in
                        switch response {
                        case .success(_):
                            var user = user
                            user.isFollow = true
                            self?.user.accept(user)
                            self?.viewWillAppear.accept(())
                        case let .failure(responseFailure):
                            self?.errorCodeHandler(responseFailure)
                        }
                    },
                    onFailure: { [weak self] error in
                        self?.errorHandler(error: error)
                    }
                )
                .disposed(by: disposeBag)
        }
    }
    
    func follow(id: Int, follow: BehaviorRelay<[FollowApiDataFollowUser]>) {
        if let user = follow.value.first(where: { $0.userId == id }) {
            if user.isFollow {
                FollowService.unfollow(userId: user.userId)
                    .request()
                    .subscribe(
                        onSuccess: { [weak self] response in
                            switch response {
                            case .success(_):
                                self?.updateList(
                                    id: id,
                                    isFollow: false,
                                    follow: follow
                                )
                            case let .failure(responseFailure):
                                self?.errorCodeHandler(responseFailure)
                            }
                        },
                        onFailure: { [weak self] error in
                            self?.errorHandler(error: error)
                        }
                    )
                    .disposed(by: disposeBag)
            } else {
                FollowService.follow(userId: user.userId)
                    .request()
                    .subscribe(
                        onSuccess: { [weak self] response in
                            switch response {
                            case .success(_):
                                self?.updateList(
                                    id: id,
                                    isFollow: true,
                                    follow: follow
                                )
                            case let .failure(responseFailure):
                                self?.errorCodeHandler(responseFailure)
                            }
                        },
                        onFailure: { [weak self] error in
                            self?.errorHandler(error: error)
                        }
                    )
                    .disposed(by: disposeBag)
            }
        }
    }
    
    func updateList(id: Int, isFollow: Bool, follow: BehaviorRelay<[FollowApiDataFollowUser]>) {
        var newList = follow.value
        for index in newList.indices {
            if newList[index].userId == id {
                newList[index].isFollow = isFollow
                break
            }
        }
        follow.accept(newList)
    }
}
