//
//  FollowListTableViewCell.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import UIKit

final class FollowListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "FollowListTableViewCell"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        avatarImageView.image = UIImage(named: "ic_profile_avatar_placeholder")
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        
        userNameLabel.font = .boldSystemFont(ofSize: 24)
        
        followButton.rounded = true
        followButton.border = true
        followButton.normalBgColor = .white
        followButton.normalTitleColor = .black
        followButton.normalBorderColor = .black
        followButton.selectedBgColor = .black
        followButton.selectedTitleColor = .white
        followButton.selectedBorderColor = .black
    }
    
    private func setupLayout() {
        contentView.addSubview(bgView)
        bgView.addSubview(avatarImageView)
        bgView.addSubview(userNameLabel)
        bgView.addSubview(followButton)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(avatarImageView.snp.trailing).offset(20)
            make.trailing.lessThanOrEqualTo(followButton.snp.leading).offset(-20)
        }
        
        followButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func bind(follow: FollowApiDataFollowUser) {
        userNameLabel.text = follow.name
        if follow.isFollow {
            followButton.isSelected = true
            followButton.setTitle("追蹤中", for: .normal)
        } else {
            followButton.isSelected = false
            followButton.setTitle("追蹤", for: .normal)
        }
    }
    
    private let bgView = UIView()
    private let avatarImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let followButton = ColorButton()
    
}
