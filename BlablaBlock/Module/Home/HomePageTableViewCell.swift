//
//  HomePageTableViewCell.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/28.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final public class HomePageTableViewCell: UITableViewCell {
    
    static let identifier = "HomePageTableViewCell"
    
    private var disposeBag = DisposeBag()
    weak var viewModel: HomePageViewModelType!

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
        
        bottomBgView.layer.cornerRadius = 4
        bottomBgView.backgroundColor = .black2D2D2D
        
        bgView.layer.cornerRadius = 4
        bgView.backgroundColor = .white
        
        avatarImageView.image = "ic_profile_avatar_placeholder".image()
        avatarImageView.layer.cornerRadius = 17
        avatarImageView.clipsToBounds = true
        
        userNameView.font = .boldSystemFont(ofSize: 13)
        userNameView.textColor = .black2D2D2D
        
        timestampCounterLabel.font = .systemFont(ofSize: 10, weight: .medium)
        timestampCounterLabel.textColor = .gray2D2D2D_40
        
        followButton.setTitle("vc_home_follow".localized(), for: .normal)
        followButton.setTitle("vc_home_following".localized(), for: .selected)
        followButton.font = .boldSystemFont(ofSize: 12)
        
        separatorView.backgroundColor = .gray2D2D2D_40
        
        currencyLabel.font = .boldSystemFont(ofSize: 16)
        currencyLabel.textColor = .black2D2D2D
        currencyLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        currencyTypeLabel.font = .systemFont(ofSize: 10, weight: .medium)
        currencyTypeLabel.textColor = .black2D2D2D
        currencyTypeLabel.textAlignment = .left
        
        timestampLabel.font = .systemFont(ofSize: 10, weight: .medium)
        timestampLabel.textColor = .gray2D2D2D_40
        timestampLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        actionLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        exchangeTtitleLabel.text = "vc_home_exchange".localized()
        exchangeTtitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        exchangeTtitleLabel.textColor = .black2D2D2D_80
        
        exchangeLabel.font = .systemFont(ofSize: 12, weight: .medium)
        exchangeLabel.textColor = .black2D2D2D
        
        priceTitleLabel.text = "vc_home_price".localized()
        priceTitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        priceTitleLabel.textColor = .black2D2D2D_80
        
        priceLabel.font = .systemFont(ofSize: 12, weight: .medium)
        priceLabel.textColor = .black2D2D2D
        
        amountTitleLabel.text = "vc_home_amount".localized()
        amountTitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        amountTitleLabel.textColor = .black2D2D2D_80
        
        amountLabel.font = .systemFont(ofSize: 12, weight: .medium)
        amountLabel.textColor = .black2D2D2D
    }
    
    private func setupLayout() {
        contentView.addSubview(bottomBgView)
        bottomBgView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 24, bottom: 10, right: 24))
        }

        bottomBgView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0))
        }
        
        bgView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        }
        
        containerView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(34)
            make.leading.top.equalToSuperview()
        }

        containerView.addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(22)
            make.centerY.equalTo(avatarImageView)
            make.trailing.equalToSuperview()
        }
        
        containerView.addSubview(userNameSectionView)
        userNameSectionView.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.top.equalToSuperview()
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalTo(followButton.snp.leading).offset(-16)
        }
        
        userNameSectionView.addSubview(userNameView)
        userNameView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.top.trailing.equalToSuperview()
        }

        userNameSectionView.addSubview(timestampCounterLabel)
        timestampCounterLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.leading.bottom.trailing.equalToSuperview()
        }

        containerView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(userNameSectionView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        containerView.addSubview(currencyImageView)
        currencyImageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
            make.top.equalTo(separatorView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }

        containerView.addSubview(currencyLabel)
        currencyLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerY.equalTo(currencyImageView)
            make.leading.equalTo(currencyImageView.snp.trailing).offset(8)
        }

        containerView.addSubview(timestampLabel)
        timestampLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerY.equalTo(currencyImageView)
            make.trailing.equalToSuperview()
        }

        containerView.addSubview(currencyTypeLabel)
        currencyTypeLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.centerY.equalTo(currencyImageView)
            make.leading.equalTo(currencyLabel.snp.trailing).offset(8)
            make.trailing.equalTo(timestampLabel.snp.leading).offset(-8)
        }

        containerView.addSubview(actionLabel)
        actionLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.top.equalTo(currencyImageView.snp.bottom).offset(5)
            make.leading.equalToSuperview()
        }

        containerView.addSubview(exchangeTtitleLabel)
        exchangeTtitleLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.top.equalTo(actionLabel.snp.bottom)
            make.leading.equalToSuperview()
        }

        containerView.addSubview(exchangeLabel)
        exchangeLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.centerY.equalTo(exchangeTtitleLabel)
            make.trailing.equalToSuperview()
        }

        containerView.addSubview(priceTitleLabel)
        priceTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.top.equalTo(exchangeTtitleLabel.snp.bottom)
            make.leading.equalToSuperview()
        }

        containerView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.centerY.equalTo(priceTitleLabel)
            make.trailing.equalToSuperview()
        }

        containerView.addSubview(amountTitleLabel)
        amountTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.top.equalTo(priceTitleLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
        }

        containerView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.centerY.equalTo(amountTitleLabel)
            make.trailing.equalToSuperview()
        }
    }
    
    private let bottomBgView = UIView()
    private let bgView = UIView()
    private let containerView = UIView()
    private let avatarImageView = UIImageView()
    private let userNameSectionView = UIView()
    private let userNameView = BlablablockUserNameLabelView()
    private let timestampCounterLabel = UILabel()
    private let followButton = BlablaBlockOrangeButtonView()
    private let separatorView = UIView()
    private let currencyImageView = UIImageView()
    private let currencyLabel = UILabel()
    private let currencyTypeLabel = UILabel()
    private let timestampLabel = UILabel()
    private let actionLabel = UILabel()
    private let exchangeTtitleLabel = UILabel()
    private let exchangeLabel = UILabel()
    private let priceTitleLabel = UILabel()
    private let priceLabel = UILabel()
    private let amountTitleLabel = UILabel()
    private let amountLabel = UILabel()
}

public extension HomePageTableViewCell {
    
    func bind(notification: NotificationApiData) {
        currencyImageView.currency(name: notification.baseCurrency)
        followButton.isSelected = notification.isFollow
        
        userNameView.text = notification.name
        userNameView.setCertification(userId: notification.userId)
        
        timestampCounterLabel.text = notification.timestamp.ago()
        currencyLabel.text = notification.currency
        currencyTypeLabel.text = AssetType.map(type: notification.type)
        timestampLabel.text = notification.timestamp.format()
        if notification.side.caseInsensitiveCompare("buy") == .orderedSame {
            actionLabel.text = "vc_home_buy".localized()
            actionLabel.textColor = .systemGreen
        } else {
            actionLabel.text = "vc_home_sell".localized()
            actionLabel.textColor = .red
        }
        exchangeLabel.text = notification.exchange.uppercased()
        priceLabel.text = notification.price?.toPrettyPrecisedString()
        amountLabel.text = notification.executedQty.toPrettyPrecisedString()
        
        followButton.rx
            .tapGesture()
            .when(.recognized)
            .map { _ in notification.userId }
            .bind(to: viewModel.inputs.followBtnTap)
            .disposed(by: disposeBag)
    }
}
