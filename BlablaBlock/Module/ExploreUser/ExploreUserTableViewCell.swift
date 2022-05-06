//
//  ExploreUserTableViewCell.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/3.
//

import UIKit
import SnapKit
import RxSwift

final public class ExploreUserTableViewCell: UITableViewCell {
    
    static let identifier = "ExploreUserTableViewCell"
    
    private var disposeBag = DisposeBag()
    weak var viewModel: ExploreUserViewModelType?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .grayE5E5E5
        
        bgBottomView.layer.cornerRadius = 4
        bgBottomView.backgroundColor = .black
        
        bgView.layer.cornerRadius = 4
        bgView.backgroundColor = .white
        
        avatarImageView.image = "ic_profile_avatar_placeholder".image()
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        
        followButton.setTitle("追蹤", for: .normal)
        followButton.setTitle("追蹤中", for: .selected)
        followButton.font = .boldSystemFont(ofSize: 12)
        
        totalAssetLabel.font = .boldSystemFont(ofSize: 10)
        totalAssetLabel.textColor = .black2D2D2D_80
        
        userNameSectionView.font = .boldSystemFont(ofSize: 18)
        userNameSectionView.textColor = .black2D2D2D
        
        leftSectionView.axis = .vertical
        
        separatorView.backgroundColor = .gray2D2D2D_40
        
        rightSectionView.axis = .vertical
        
        roiTitleLabel.text = "總報酬率"
        roiTitleLabel.font = .systemFont(ofSize: 10)
        roiTitleLabel.textColor = .black2D2D2D_80
        roiTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        roiLabel.textColor = .black2D2D2D
        roiLabel.font = .systemFont(ofSize: 10)
        roiLabel.numberOfLines = 1
        roiLabel.adjustsFontSizeToFitWidth = true
        roiLabel.textAlignment = .right
        
        annualRoiTitleLabel.text = "年化報酬率"
        annualRoiTitleLabel.font = .systemFont(ofSize: 10)
        annualRoiTitleLabel.textColor = .black2D2D2D_80
        annualRoiTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        annualRoiLabel.textColor = .black2D2D2D
        annualRoiLabel.font = .systemFont(ofSize: 10)
        annualRoiLabel.numberOfLines = 1
        annualRoiLabel.adjustsFontSizeToFitWidth = true
        annualRoiLabel.textAlignment = .right
        
        mDDTitleLabel.text = "最大回撤"
        mDDTitleLabel.font = .systemFont(ofSize: 10)
        mDDTitleLabel.textColor = .black2D2D2D_80
        mDDTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        mDDLabel.textColor = .black2D2D2D
        mDDLabel.font = .systemFont(ofSize: 10)
        mDDLabel.numberOfLines = 1
        mDDLabel.adjustsFontSizeToFitWidth = true
        mDDLabel.textAlignment = .right
        
        winRateTitleLabel.text = "勝率"
        winRateTitleLabel.font = .systemFont(ofSize: 10)
        winRateTitleLabel.textColor = .black2D2D2D_80
        winRateTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        winRateLabel.textColor = .black2D2D2D
        winRateLabel.font = .systemFont(ofSize: 10)
        winRateLabel.numberOfLines = 1
        winRateLabel.adjustsFontSizeToFitWidth = true
        winRateLabel.textAlignment = .right
        
        sharpRatioTitleLabel.text = "Sharp Ratio"
        sharpRatioTitleLabel.font = .systemFont(ofSize: 10)
        sharpRatioTitleLabel.textColor = .black2D2D2D_80
        sharpRatioTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        sharpRatioLabel.textColor = .black2D2D2D
        sharpRatioLabel.font = .systemFont(ofSize: 10)
        sharpRatioLabel.numberOfLines = 1
        sharpRatioLabel.adjustsFontSizeToFitWidth = true
        sharpRatioLabel.textAlignment = .right
    }
    
    private func setupLayout() {
        contentView.addSubview(bgBottomView)
        bgBottomView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 24, bottom: 10, right: 24))
        }
        
        bgBottomView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0))
        }
        
        bgView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        }
        
        containerView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.leading.top.equalToSuperview()
        }
        
        containerView.addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(22)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(avatarImageView)
        }
        
        containerView.addSubview(totalAssetLabel)
        totalAssetLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.top.equalTo(followButton)
            make.trailing.equalTo(followButton.snp.leading).offset(4)
            make.bottom.equalTo(followButton)
        }
        
        containerView.addSubview(userNameSectionView)
        userNameSectionView.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.bottom.equalTo(followButton.snp.top).offset(-4)
        }
        
        containerView.addSubview(bottomSectionView)
        bottomSectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
        
        bottomSectionView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        bottomSectionView.addSubview(leftSectionView)
        leftSectionView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(separatorView.snp.leading).offset(-8)
        }
        
        bottomSectionView.addSubview(rightSectionView)
        rightSectionView.snp.makeConstraints { make in
            make.leading.equalTo(separatorView.snp.trailing).offset(8)
            make.top.trailing.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        
        leftSectionView.addArrangedSubview(roiView)
        roiView.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        roiView.addSubview(roiTitleLabel)
        roiTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        roiView.addSubview(roiLabel)
        roiLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(roiTitleLabel.snp.trailing)
        }
        
        leftSectionView.addArrangedSubview(annualRoiView)
        annualRoiView.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        annualRoiView.addSubview(annualRoiTitleLabel)
        annualRoiTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        annualRoiView.addSubview(annualRoiLabel)
        annualRoiLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(annualRoiTitleLabel.snp.trailing)
        }
        
        leftSectionView.addArrangedSubview(sharpRatioView)
        sharpRatioView.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        sharpRatioView.addSubview(sharpRatioTitleLabel)
        sharpRatioTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        sharpRatioView.addSubview(sharpRatioLabel)
        sharpRatioLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(sharpRatioTitleLabel.snp.trailing)
        }

        rightSectionView.addArrangedSubview(mDDView)
        mDDView.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        mDDView.addSubview(mDDTitleLabel)
        mDDTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        mDDView.addSubview(mDDLabel)
        mDDLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(mDDTitleLabel.snp.trailing)
        }
        
        rightSectionView.addArrangedSubview(winRateView)
        winRateView.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        winRateView.addSubview(winRateTitleLabel)
        winRateTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        winRateView.addSubview(winRateLabel)
        winRateLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(winRateTitleLabel.snp.trailing)
        }
    }
    
    private let bgBottomView = UIView()
    private let bgView = UIView()
    private let containerView = UIView()
    private let avatarImageView = UIImageView()
    private let followButton = BlablaBlockOrangeButtonView()
    private let totalAssetLabel = UILabel()
    private let userNameSectionView = BlablablockUserNameLabelView()
    private let bottomSectionView = UIView()
    private let leftSectionView = UIStackView()
    private let separatorView = UIView()
    private let rightSectionView = UIStackView()
    private let roiView = UIView()
    private let roiTitleLabel = UILabel()
    private let roiLabel = UILabel()
    private let annualRoiView = UIView()
    private let annualRoiTitleLabel = UILabel()
    private let annualRoiLabel = UILabel()
    private let mDDView = UIView()
    private let mDDTitleLabel = UILabel()
    private let mDDLabel = UILabel()
    private let winRateView = UIView()
    private let winRateTitleLabel = UILabel()
    private let winRateLabel = UILabel()
    private let sharpRatioView = UIView()
    private let sharpRatioTitleLabel = UILabel()
    private let sharpRatioLabel = UILabel()
}

public extension ExploreUserTableViewCell {
    func bind(_ user: UserApiData) {
        userNameSectionView.text = user.name ?? " "
        userNameSectionView.setCertification(userId: user.userId)
        totalAssetLabel.text = "$\(user.totalValue.toPrettyPrecisedString()) USDT"
        followButton.isSelected = user.isFollow
        roiLabel.text = "\(user.roi?.toPrettyPrecisedString() ?? "")％"
        annualRoiLabel.text = "\(user.roiAnnual?.toPrettyPrecisedString() ?? "")％"
        mDDLabel.text = "\(user.mdd?.toPrettyPrecisedString() ?? "")％"
        winRateLabel.text = "\(user.dailyWinRate?.toPrettyPrecisedString() ?? "")％"
        sharpRatioLabel.text = "\(user.sharpeRatio?.toPrettyPrecisedString() ?? "")"
        
        followButton.rx
            .tapGesture()
            .when(.recognized)
            .map { _ in user.userId }
            .bind(to: viewModel!.inputs.followBtnTap)
            .disposed(by: disposeBag)
    }
}
