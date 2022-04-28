//
//  FollowListTableViewCell.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import UIKit
import RxCocoa
import RxSwift

final class FollowListTableViewCell: UITableViewCell {
    
    static let identifier = "FollowListTableViewCell"
    private var disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setupUI() {
        avatarImageView.image = UIImage(named: "ic_profile_avatar_placeholder")
        avatarImageView.makeCircle(base: 32)
        
        userNameLabel.font = .boldSystemFont(ofSize: 16)
        
        followButton.setTitle("追蹤", for: .normal)
        followButton.setTitle("追蹤中", for: .selected)
        followButton.font = .boldSystemFont(ofSize: 12)
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(followButton)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.lessThanOrEqualTo(followButton.snp.leading).offset(-16)
        }
        
        followButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    
    func bind(
        follow: FollowApiDataFollowUser,
        followBtnTap: PublishRelay<Int>,
        cellTap: PublishRelay<FollowApiDataFollowUser>
    ) {
        userNameLabel.text = follow.name
        if follow.userId != Int(keychainUser[.userId] ?? "-1") {
            followButton.isSelected = follow.isFollow
            followButton.rx
                .tapGesture(configuration: { _, delegate in
                    delegate.simultaneousRecognitionPolicy = .never
                })
                .when(.recognized)
                .subscribe(onNext: { _ in
                    followBtnTap.accept(follow.userId)
                })
                .disposed(by: disposeBag)
        } else {
            followButton.isHidden = true
        }
        containerView.rx
            .tapGesture(configuration: { _, delegate in
                delegate.simultaneousRecognitionPolicy = .never
            })
            .when(.recognized)
            .subscribe(onNext: { _ in
                cellTap.accept(follow)
            })
            .disposed(by: disposeBag)
    }
    
    private let containerView = UIView()
    private let avatarImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let followButton = BlablaBlockOrangeButtonView()
}
