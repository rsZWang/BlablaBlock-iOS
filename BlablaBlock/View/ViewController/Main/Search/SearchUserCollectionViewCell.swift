//
//  SearchUserCollectionViewCell.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import UIKit
import SnapKit

final class SearchUserCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SearchUserCollectionViewCell"
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_profile_avatar_placeholder")
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "NAME"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let assetLabel: UILabel = {
        let label = UILabel()
        label.text = "ASSET"
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let roiTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "總報酬"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let roiLabel: UILabel = {
        let label = UILabel()
        label.text = "9999999999999999999999"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    private let annualRoiTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "年化報酬率"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let annualRoiLabel: UILabel = {
        let label = UILabel()
        label.text = "9999999999999999999999"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    private let mDDTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "績效最大回撤"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let mDDLabel: UILabel = {
        let label = UILabel()
        label.text = "9999999999999999999999"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    private let winRateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "勝率"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let winRateLabel: UILabel = {
        let label = UILabel()
        label.text = "9999999999999999999999"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    private let sharpRatioTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "夏普值"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let sharpRatioLabel: UILabel = {
        let label = UILabel()
        label.text = "9999999999999999999999"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupLayout() {
        let width = (UIScreen.main.bounds.width / 2) - 24
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 6
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        let paddingView = UIView()
        bgView.addSubview(paddingView)
        paddingView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14))
        }
        
        paddingView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        let nameStackView = UIStackView()
        nameStackView.axis = .vertical
        nameStackView.spacing = 2
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(assetLabel)

        paddingView.addSubview(nameStackView)
        nameStackView.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }

        let detailStackView = UIStackView()
        detailStackView.axis = .vertical
        detailStackView.spacing = 8
        paddingView.addSubview(detailStackView)
        detailStackView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(14)
            make.leading.trailing.bottom.equalToSuperview()
        }

        let roiView = UIView()
        roiView.addSubview(roiTitleLabel)
        roiTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        roiView.addSubview(roiLabel)
        roiLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(roiTitleLabel.snp.trailing)
        }
        detailStackView.addArrangedSubview(roiView)

        let annualRoiView = UIView()
        annualRoiView.addSubview(annualRoiTitleLabel)
        annualRoiTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        annualRoiView.addSubview(annualRoiLabel)
        annualRoiLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(annualRoiTitleLabel.snp.trailing)
        }
        detailStackView.addArrangedSubview(annualRoiView)

        let mDDView = UIView()
        mDDView.addSubview(mDDTitleLabel)
        mDDTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        mDDView.addSubview(mDDLabel)
        mDDLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(mDDTitleLabel.snp.trailing)
        }
        detailStackView.addArrangedSubview(mDDView)

        let winRateView = UIView()
        winRateView.addSubview(winRateTitleLabel)
        winRateTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        winRateView.addSubview(winRateLabel)
        winRateLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(winRateTitleLabel.snp.trailing)
        }
        detailStackView.addArrangedSubview(winRateView)

        let sharpRateView = UIView()
        sharpRateView.addSubview(sharpRatioTitleLabel)
        sharpRatioTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        sharpRateView.addSubview(sharpRatioLabel)
        sharpRatioLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(sharpRatioTitleLabel.snp.trailing)
        }
        detailStackView.addArrangedSubview(sharpRateView)
    }
    
    func bind(_ data: UserApiData) {
        nameLabel.text = data.name ?? " "
        roiLabel.text = "\(data.roi?.toPrettyPrecisedString() ?? "")％"
        annualRoiLabel.text = "\(data.roiAnnual?.toPrettyPrecisedString() ?? "")％"
        mDDLabel.text = "\(data.mdd?.toPrettyPrecisedString() ?? "")％"
        winRateLabel.text = "\(data.dailyWinRate?.toPrettyPrecisedString() ?? "")％"
        sharpRatioLabel.text = "\(data.sharpeRatio?.toPrettyPrecisedString() ?? "")"
    }
}
