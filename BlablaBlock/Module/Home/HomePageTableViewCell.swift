//
//  HomePageTableViewCell.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/28.
//

import UIKit
import RxCocoa
import RxSwift

final class HomePageTableViewCell: UITableViewCell {
    
    static let identifier = "HomePageTableViewCell"
    
    private var disposeBag = DisposeBag()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .grayE5E5E5
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setupLayout() {
        contentView.addSubview(bgBottomView)
        bgBottomView.addSubview(bgView)
        bgView.addSubview(contentMarginView)
        contentMarginView.addSubview(avatarImageView)
        contentMarginView.addSubview(nameSectionStackView)
        nameSectionStackView.addArrangedSubview(nameLabel)
        nameSectionStackView.addArrangedSubview(timestampCounterLabel)
        contentMarginView.addSubview(followButton)
        contentMarginView.addSubview(separatorView)
        contentMarginView.addSubview(currencyImageView)
        contentMarginView.addSubview(currencyLabel)
        contentMarginView.addSubview(currencyTypeLabel)
        contentMarginView.addSubview(timestampLabel)
        contentMarginView.addSubview(actionLabel)
        contentMarginView.addSubview(exchangeTtitleLabel)
        contentMarginView.addSubview(exchangeLabel)
        contentMarginView.addSubview(priceTitleLabel)
        contentMarginView.addSubview(priceLabel)
        contentMarginView.addSubview(amountTitleLabel)
        contentMarginView.addSubview(amountLabel)
        
        bgBottomView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 24, bottom: 10, right: 24))
        }
        
        bgView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(bgBottomView.snp.bottom).offset(-3)
        }
    
        contentMarginView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.leading.top.equalToSuperview()
        }
        
        nameSectionStackView.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
        }
        
        followButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(20)
            make.centerY.equalTo(avatarImageView)
            make.trailing.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(7)
        }
        
        currencyImageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
            make.leading.equalToSuperview()
            make.top.equalTo(separatorView.snp.bottom).offset(7)
        }

        currencyLabel.snp.makeConstraints { make in
            make.leading.equalTo(currencyImageView.snp.trailing).offset(8)
            make.centerY.equalTo(currencyImageView)
        }
        
        currencyTypeLabel.snp.makeConstraints { make in
            make.leading.equalTo(currencyLabel.snp.trailing).offset(8)
            make.centerY.equalTo(currencyLabel)
        }

        timestampLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(currencyLabel)
        }

        actionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(currencyImageView.snp.bottom).offset(10)
        }

        exchangeTtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(actionLabel.snp.bottom).offset(10)
        }

        exchangeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(exchangeTtitleLabel)
            make.trailing.equalToSuperview()
        }

        priceTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(exchangeTtitleLabel.snp.bottom).offset(6)
        }

        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceTitleLabel)
            make.trailing.equalToSuperview()
        }

        amountTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(priceTitleLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview()
        }

        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(amountTitleLabel)
            make.trailing.equalToSuperview()
        }
    }
    
    private let bgBottomView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = .black
        return view
    }()
    
    private let bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = .white
        return view
    }()
    
    private let contentMarginView = UIView()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = "ic_profile_avatar_placeholder".image()
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameSectionStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "nameLabel"
        label.textColor = .black2D2D2D
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let timestampCounterLabel: UILabel = {
        let label = UILabel()
        label.text = "timestampCounterLabel"
        label.textColor = .gray2D2D2D_40
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private let followButton: OrangeButton = {
        let button = OrangeButton()
        button.setTitle("追蹤", for: .normal)
        button.setTitle("追蹤中", for: .selected)
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2D2D2D_40
        return view
    }()
    
    private let currencyImageView = UIImageView()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black2D2D2D
        return label
    }()
    
    private let currencyTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .black2D2D2D
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray2D2D2D_40
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private let actionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.text = "  "
        return label
    }()
    
    private let exchangeTtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "交易所"
        label.textColor = .black2D2D2D_80
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let exchangeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black2D2D2D
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "  "
        label.textColor = .black2D2D2D_80
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black2D2D2D
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    private let amountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "  "
        label.textColor = .black2D2D2D_80
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black2D2D2D
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
}

extension HomePageTableViewCell {
    
    func bind(notification: NotificationApiData, followBtnTap: PublishRelay<Int>?) {
        currencyImageView.currency(name: notification.baseCurrency)
        if notification.isFollow {
            followButton.setTitle("追蹤中", for: .normal)
            followButton.isSelected = true
        } else {
            followButton.setTitle("追蹤", for: .normal)
            followButton.isSelected = false
        }
        nameLabel.text = notification.name
        timestampCounterLabel.text = notification.timestamp.ago()
        currencyLabel.text = notification.currency
        currencyTypeLabel.text = AssetType.map(type: notification.type)
        timestampLabel.text = notification.timestamp.format()
        if notification.side.caseInsensitiveCompare("buy") == .orderedSame {
            actionLabel.text = "買入"
            actionLabel.textColor = .systemGreen
        } else {
            actionLabel.text = "賣出"
            actionLabel.textColor = .red
        }
        exchangeLabel.text = notification.exchange.uppercased()
        priceTitleLabel.text = "價格"
        priceLabel.text = notification.price?.toPrettyPrecisedString()
        amountTitleLabel.text = "成交數量"
        amountLabel.text = notification.executedQty.toPrettyPrecisedString()
        
        followButton.rx
            .tap
            .subscribe(onNext: {
                followBtnTap?.accept(notification.userId)
            })
            .disposed(by: disposeBag)
    }
}
