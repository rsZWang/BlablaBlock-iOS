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
    
    static let reuseIdentifier = "HomePageTableViewCell"
    
    private var disposeBag = DisposeBag()
    
    private let bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_profile_avatar_placeholder")
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "nameLabel"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let timestampCounterLabel: UILabel = {
        let label = UILabel()
        label.text = "timestampCounterLabel"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let followButton: ColorButton = {
        let button = ColorButton()
        button.rounded = true
        button.normalBgColor = .white
        button.selectedBgColor = .black
        button.normalTitleColor = .black
        button.selectedTitleColor = .white
        button.borderColor = .black
        button.border = true
        button.borderWidth = 1
        button.setTitle("追蹤中", for: .normal)
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let currencyImageView = UIImageView()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let currencyTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let actionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.text = "  "
        return label
    }()
    
    private let exchangeTtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.text = "交易所"
        return label
    }()
    
    private let exchangeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.text = "  "
        return label
    }()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.text = "  "
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.text = "  "
        return label
    }()
    
    private let amountTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.text = "  "
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.text = "  "
        return label
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setupUI() {
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 16, left: 18, bottom: 0, right: 18))
        }
        
        let contentMarginView = UIView()
        bgView.addSubview(contentMarginView)
        contentMarginView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 12))
        }
        
        contentMarginView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(38)
            make.leading.top.equalToSuperview()
        }
        
        let nameSectionView = UIStackView()
        nameSectionView.axis = .vertical
        nameSectionView.spacing = 0
        nameSectionView.addArrangedSubview(nameLabel)
        nameSectionView.addArrangedSubview(timestampCounterLabel)
        contentMarginView.addSubview(nameSectionView)
        nameSectionView.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(6)
        }
        
        contentMarginView.addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.centerY.equalTo(avatarImageView)
            make.trailing.equalToSuperview()
        }
        
        contentMarginView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
        }
        
        contentMarginView.addSubview(currencyImageView)
        currencyImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(separatorView.snp.bottom).offset(10)
            make.width.height.equalTo(38)
        }
        
        let currencyStackView = UIStackView()
        currencyStackView.axis = .vertical
        currencyStackView.addArrangedSubview(currencyLabel)
        currencyStackView.addArrangedSubview(currencyTypeLabel)
        
        contentMarginView.addSubview(currencyStackView)
        currencyStackView.snp.makeConstraints { make in
            make.leading.equalTo(currencyImageView.snp.trailing).offset(8)
            make.centerY.equalTo(currencyImageView)
        }

        contentMarginView.addSubview(timestampLabel)
        timestampLabel.snp.makeConstraints { make in
            make.bottom.equalTo(currencyStackView)
            make.trailing.equalToSuperview()
        }

        contentMarginView.addSubview(actionLabel)
        actionLabel.snp.makeConstraints { make in
            make.leading.equalTo(currencyImageView).offset(4)
            make.top.equalTo(currencyImageView.snp.bottom).offset(10)
        }

        contentMarginView.addSubview(exchangeTtitleLabel)
        exchangeTtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(currencyImageView).offset(4)
            make.top.equalTo(actionLabel.snp.bottom).offset(10)
        }

        contentMarginView.addSubview(exchangeLabel)
        exchangeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(exchangeTtitleLabel)
            make.trailing.equalToSuperview()
        }

        contentMarginView.addSubview(priceTitleLabel)
        priceTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(currencyImageView).offset(4)
            make.top.equalTo(exchangeTtitleLabel.snp.bottom).offset(6)
        }

        contentMarginView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceTitleLabel)
            make.trailing.equalToSuperview()
        }

        contentMarginView.addSubview(amountTitleLabel)
        amountTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(currencyImageView).offset(4)
            make.top.equalTo(priceTitleLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview()
        }

        contentMarginView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(amountTitleLabel)
            make.trailing.equalToSuperview()
        }
    }
    
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
        timestampCounterLabel.text = Date(timeIntervalSince1970: notification.timestamp).agoString()
        currencyLabel.text = notification.currency
        currencyTypeLabel.text = AssetType.map(type: notification.type)
        timestampLabel.text = formatDateTime(timestamp: notification.timestamp)
        if notification.side.caseInsensitiveCompare("buy") == .orderedSame {
            actionLabel.text = "買入"
            actionLabel.textColor = .systemGreen
        } else {
            actionLabel.text = "賣出"
            actionLabel.textColor = .red
        }
        exchangeLabel.text = notification.exchange.uppercased()
        priceTitleLabel.text = "價格"
        priceLabel.text = notification.price.toPrettyPrecisedString()
        amountTitleLabel.text = "成交數量"
        amountLabel.text = notification.executedQty.toPrettyPrecisedString()
        
        followButton.rx
            .tap
            .subscribe(onNext: {
                followBtnTap?.accept(notification.userId)
            })
            .disposed(by: disposeBag)
    }
    
    private func formatDateTime(timestamp: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date(timeIntervalSince1970: timestamp))
    }

}
