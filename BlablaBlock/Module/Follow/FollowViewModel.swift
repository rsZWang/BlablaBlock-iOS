//
//  FollowViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import RxCocoa
import RxSwift

public protocol FollowViewModelInputs: AnyObject {
    var user: BehaviorRelay<UserApiData?> { get }
    var viewWillAppear: PublishRelay<()> { get }
    var portfolioFollowBtnTap: PublishRelay<Int> { get }
    var followBtnTap: PublishRelay<Int> { get }
    var followCellTap: PublishRelay<FollowApiDataFollowUser> { get }
}

public protocol FollowViewModelOutputs: AnyObject {
    var isFollowing: BehaviorRelay<Bool> { get }
    var followerAmount: BehaviorRelay<Int> { get }
    var followingAmount: BehaviorRelay<Int> { get }
    var followers: BehaviorRelay<[FollowApiDataFollowUser]> { get }
    var followings: BehaviorRelay<[FollowApiDataFollowUser]> { get }
    var toProfile: Signal<UserApiData> { get }
}

public protocol FollowViewModelType: AnyObject {
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
    var portfolioFollowBtnTap: PublishRelay<Int>
    var followBtnTap: PublishRelay<Int>
    var followCellTap: PublishRelay<FollowApiDataFollowUser>
    
    // MARK: - outputs
    
    var isFollowing: BehaviorRelay<Bool>
    var followerAmount: BehaviorRelay<Int>
    var followingAmount: BehaviorRelay<Int>
    var followers: BehaviorRelay<[FollowApiDataFollowUser]>
    var followings: BehaviorRelay<[FollowApiDataFollowUser]>
    var toProfile: Signal<UserApiData>
    
    var inputs: FollowViewModelInputs { self }
    var outputs: FollowViewModelOutputs { self }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let user = BehaviorRelay<UserApiData?>(value: nil)
        let viewWillAppear = PublishRelay<()>()
        let followBtnTap = PublishRelay<Int>()
        let followCellTap = PublishRelay<FollowApiDataFollowUser>()
        let portfolioFollowBtnTap = PublishRelay<Int>()
        
        let isFollowing = BehaviorRelay<Bool>(value: false)
        let followerAmount = BehaviorRelay<Int>(value: 0)
        let followingAmount = BehaviorRelay<Int>(value: 0)
        let followers = BehaviorRelay<[FollowApiDataFollowUser]>(value: [])
        let followings = BehaviorRelay<[FollowApiDataFollowUser]>(value: [])
        let toProfile = PublishRelay<UserApiData>()
        
        self.user = user
        self.viewWillAppear = viewWillAppear
        self.followBtnTap = followBtnTap
        self.followCellTap = followCellTap
        self.portfolioFollowBtnTap = portfolioFollowBtnTap
        
        self.isFollowing = isFollowing
        self.followerAmount = followerAmount
        self.followingAmount = followingAmount
        self.followers = followers
        self.followings = followings
        self.toProfile = toProfile.asSignal()
        
        super.init()
        
        user
            .subscribe(onNext: { [weak self] user in
                if let user = user {
                    self?.isFollowing.accept(user.isFollow)
                }
            })
            .disposed(by: disposeBag)
        
        viewWillAppear
            .throttle(.milliseconds(1000), scheduler: MainScheduler.asyncInstance)
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .utility))
            .subscribe(onNext: { [weak self] _ in
                self?.getFollowers()
            })
            .disposed(by: disposeBag)
        
        portfolioFollowBtnTap
            .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .utility))
            .subscribe(onNext: { [weak self] userId in
                self?.tell(userId: userId, isProfolioPage: true)
            })
            .disposed(by: disposeBag)
        
        followBtnTap
            .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .utility))
            .subscribe(onNext: { [weak self] userId in
                self?.tell(userId: userId, isProfolioPage: false)
            })
            .disposed(by: disposeBag)
        
        followCellTap
            .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
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
            .bind(to: toProfile)
            .disposed(by: disposeBag)
    }
}

private extension FollowViewModel {
    func getFollowers() {
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
                    self?.followerAmount.accept(data.followers.count)
                    self?.followingAmount.accept(data.followings.count)
                    self?.followers.accept(data.followers.list)
                    self?.followings.accept(data.followings.list)
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
    
    private func tell(userId: Int, isProfolioPage: Bool) {
        if let isFollowing = followers.value.first(where: { $0.userId == userId })?.isFollow
            ?? followings.value.first(where: { $0.userId == userId })?.isFollow
            ?? user.value?.isFollow
        {
            if !isFollowing {
                follow(userId: userId, isProfolioPage: isProfolioPage)
            } else {
                unfollow(userId: userId, isProfolioPage: isProfolioPage)
            }
        }
    }
    
    private func follow(userId: Int, isProfolioPage: Bool) {
        FollowService.follow(userId: userId)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case .success(_):
                        self?.updateList(userId: userId, isFollow: true, isProfolioPage: isProfolioPage)
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
    
    private func unfollow(userId: Int, isProfolioPage: Bool) {
        FollowService.unfollow(userId: userId)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case .success(_):
                        self?.updateList(userId: userId, isFollow: false, isProfolioPage: isProfolioPage)
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
    
    private func updateList(userId: Int, isFollow: Bool, isProfolioPage: Bool) {
        updateList(
            userId: userId,
            isFollow: isFollow,
            list: followers
        )
        
        updateList(
            userId: userId,
            isFollow: isFollow,
            list: followings
        )
        
        if isProfolioPage {
            if var user = user.value {
                user.isFollow = isFollow
                self.user.accept(user)
            }
            
            var newList = followers.value
            if let userIdString = keychainUser[.userId], let userId = Int(userIdString) {
                if isFollow {
                    let userName = keychainUser[.userName] ?? keychainUser[.userEmail]
                    newList.append(FollowApiDataFollowUser(userId: userId, name: userName, isFollow: isFollow))
                } else {
                    newList.removeAll(where: { $0.userId == userId })
                }
            }
            followers.accept(newList)
            followerAmount.accept(newList.count)
        }
    }
    
    private func updateList(
        userId: Int,
        isFollow: Bool,
        list: BehaviorRelay<[FollowApiDataFollowUser]>,
        block: ((Bool, [FollowApiDataFollowUser]) -> [FollowApiDataFollowUser])? = nil
    ) {
        var isNotExisting = true
        var newList = list.value
        for index in newList.indices {
            if newList[index].userId == userId {
                newList[index].isFollow = isFollow
                isNotExisting = false
                break
            }
        }
        if let block = block {
            newList = block(isNotExisting, newList)
        }
        list.accept(newList)
    }
}
