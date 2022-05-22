//
//  TradeHistoryTableViewCell.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import UIKit
import SnapKit

final class TradeHistoryTableViewCell: UITableViewCell {
    
    static let identifier = "TradeHistoryTableViewCell"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayuot()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .grayEDEDED
        
        bottomBgView.layer.cornerRadius = 4
        bottomBgView.backgroundColor = .black2D2D2D
        
        bgView.layer.cornerRadius = 4
        bgView.backgroundColor = .white
        
        currencyLabel.font = .boldSystemFont(ofSize: 16)
        currencyLabel.textColor = .black2D2D2D
        
        currencyType.font = .systemFont(ofSize: 10, weight: .medium)
        currencyType.textColor = .darkGray
        
        timestampLabel.textColor = .gray2D2D2D_40
        timestampLabel.font = .systemFont(ofSize: 10, weight: .medium)
        
        actionLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        exchangeTtitleLabel.text = "交易所"
        setupTitleLabel(exchangeTtitleLabel)
        setupValueLabel(exchangeLabel)
        
        priceTitleLabel.text = "價格"
        setupTitleLabel(priceTitleLabel)
        setupValueLabel(priceLabel)
        
        amountTitleLabel.text = "成交數量"
        setupTitleLabel(amountTitleLabel)
        setupValueLabel(amountLabel)
    }
    
    private func setupTitleLabel(_ label: UILabel) {
        label.textColor = .black2D2D2D_80
        label.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    private func setupValueLabel(_ label: UILabel) {
        label.textColor = .black2D2D2D
        label.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    private func setupLayuot() {
        contentView.addSubview(bottomBgView)
        bottomBgView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 22, bottom: 5, right: 22))
        }
        
        bottomBgView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0))
        }
        
        bgView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        }
        
        containerView.addSubview(currencyImageView)
        currencyImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        let currencyStackView = UIStackView()
        currencyStackView.axis = .vertical
        currencyStackView.addArrangedSubview(currencyLabel)
        currencyStackView.addArrangedSubview(currencyType)
        
        containerView.addSubview(currencyStackView)
        currencyStackView.snp.makeConstraints { make in
            make.leading.equalTo(currencyImageView.snp.trailing).offset(8)
            make.centerY.equalTo(currencyImageView)
        }
        
        containerView.addSubview(timestampLabel)
        timestampLabel.snp.makeConstraints { make in
            make.bottom.equalTo(currencyType)
            make.trailing.equalToSuperview()
        }
        
        containerView.addSubview(actionLabel)
        actionLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.leading.equalToSuperview()
            make.top.equalTo(currencyImageView.snp.bottom).offset(5)
        }
        
        containerView.addSubview(exchangeTtitleLabel)
        exchangeTtitleLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.leading.equalToSuperview()
            make.top.equalTo(actionLabel.snp.bottom)
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
            make.leading.equalToSuperview()
            make.top.equalTo(exchangeTtitleLabel.snp.bottom)
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
            make.leading.equalToSuperview()
            make.top.equalTo(priceTitleLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }

        containerView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(amountTitleLabel)
            make.trailing.equalToSuperview()
        }
    }
    
    private let bottomBgView =  UIView()
    private let bgView = UIView()
    private let containerView = UIView()
    private let currencyImageView = UIImageView()
    private let currencyLabel = UILabel()
    private let currencyType = UILabel()
    private let timestampLabel = UILabel()
    private let actionLabel = UILabel()
    private let exchangeTtitleLabel = UILabel()
    private let exchangeLabel = UILabel()
    private let priceTitleLabel = UILabel()
    private let priceLabel: UILabel = UILabel()
    private let amountTitleLabel = UILabel()
    private let amountLabel = UILabel()
}

extension TradeHistoryTableViewCell {
    func bind(history: HistoryApiData) {
        currencyImageView.currency(name: history.baseCurrency)
        currencyLabel.text = history.currency.uppercased()
        currencyType.text = AssetType.map(type: history.type)
        timestampLabel.text = history.timestamp.format()
        if history.side.caseInsensitiveCompare("buy") == .orderedSame {
            actionLabel.text = "買入"
            actionLabel.textColor = .systemGreen
        } else {
            actionLabel.text = "賣出"
            actionLabel.textColor = .red
        }
        exchangeLabel.text = history.exchange.uppercased()
        priceTitleLabel.text = "價格"
        priceLabel.text = history.price?.toPrettyPrecisedString()
        amountTitleLabel.text = "成交數量"
        amountLabel.text = history.executedQty.toPrettyPrecisedString()
    }
}
