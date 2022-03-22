//
//  TradeHistoryTableViewCell.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import UIKit
import SnapKit

final class TradeHistoryTableViewCell: UITableViewCell {
    
    private let bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = .white
        return view
    }()
    
    private let currencyImageView = UIImageView()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let currencyType: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
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
    
    private func setupUI() {
        contentView.backgroundColor = #colorLiteral(red: 0.1803734004, green: 0.1804045737, blue: 0.1803635955, alpha: 1)
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 18, bottom: 16, right: 18))
        }
        
        let contentMarginView = UIView()
        bgView.addSubview(contentMarginView)
        contentMarginView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 12))
        }
        
        contentMarginView.addSubview(currencyImageView)
        currencyImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-8)
            make.top.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        let currencyStackView = UIStackView()
        currencyStackView.axis = .vertical
        currencyStackView.addArrangedSubview(currencyLabel)
        currencyStackView.addArrangedSubview(currencyType)
        
        contentMarginView.addSubview(currencyStackView)
        currencyStackView.snp.makeConstraints { make in
            make.leading.equalTo(currencyImageView.snp.trailing).offset(6)
            make.centerY.equalTo(currencyImageView)
        }
        
//        contentMarginView.addSubview(currencyLabel)
//        currencyLabel.snp.makeConstraints { make in
//            make.leading.equalTo(currencyImageView.snp.trailing).offset(8)
//            make.centerY.equalTo(currencyImageView)
//        }
//
//        contentMarginView.addSubview(currencyType)
//        currencyType.snp.makeConstraints { make in
//            make.leading.equalTo(currencyLabel)
//            make.top.equalTo(currencyLabel.snp.bottom)
//        }
        
        contentMarginView.addSubview(timestampLabel)
        timestampLabel.snp.makeConstraints { make in
            make.bottom.equalTo(currencyType)
            make.trailing.equalToSuperview()
        }
        
        contentMarginView.addSubview(actionLabel)
        actionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(currencyImageView.snp.bottom).offset(14)
        }
        
        contentMarginView.addSubview(exchangeTtitleLabel)
        exchangeTtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(actionLabel.snp.bottom).offset(14)
        }

        contentMarginView.addSubview(exchangeLabel)
        exchangeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(exchangeTtitleLabel)
            make.trailing.equalToSuperview()
        }

        contentMarginView.addSubview(priceTitleLabel)
        priceTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(exchangeTtitleLabel.snp.bottom).offset(6)
        }

        contentMarginView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceTitleLabel)
            make.trailing.equalToSuperview()
        }

        contentMarginView.addSubview(amountTitleLabel)
        amountTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(priceTitleLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview()
        }

        contentMarginView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(amountTitleLabel)
            make.trailing.equalToSuperview()
        }
    }
    
    func bind(history: HistoryApiData) {
        currencyImageView.currency(name: history.baseCurrency)
        currencyLabel.text = history.currency.uppercased()
        currencyType.text = AssetType.map(type: history.type)
        timestampLabel.text = formatDateTime(timestamp: history.timestamp)
        if history.side == "BUY" {
            actionLabel.text = "買入"
            actionLabel.textColor = .systemGreen
        } else {
            actionLabel.text = "賣出"
            actionLabel.textColor = .red
        }
        exchangeLabel.text = history.exchange.uppercased()
        priceTitleLabel.text = "價格"
        priceLabel.text = history.price.toPrettyPrecisedString()
        amountTitleLabel.text = "成交數量"
        amountLabel.text = history.executedQty.toPrettyPrecisedString()
    }
    
    private func formatDateTime(timestamp: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}


