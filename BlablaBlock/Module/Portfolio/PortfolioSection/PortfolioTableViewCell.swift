//
//  PortfolioTableViewCell.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/24.
//

import UIKit
import SnapKit
import RxSwift

final class PortfolioTableViewCell: UITableViewCell {
    
    static let identifier = "PortfolioTableViewCell"
    
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
        currencyImageView.makeCircle(base: 11)
        separatorView.backgroundColor = .gray2D2D2D_40
        
        setupBlackLabel(currencyLabel)
        currencyLabel.textAlignment = .left
        
        setupGrayLabel(percentageLabel)
        percentageLabel.textAlignment = .left
        
        setupBlackLabel(balanceLabel)
        balanceLabel.textAlignment = .right
        
        setupGrayLabel(valueLabel)
        valueLabel.textAlignment = .right
        
        dayChangeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        dayChangeLabel.textAlignment = .right
        dayChangeLabel.numberOfLines = 1
        dayChangeLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupBlackLabel(_ label: UILabel) {
        label.textColor = .black2D2D2D
        label.font = .boldSystemFont(ofSize: 14)
        label.autoFontSize()
    }
    
    private func setupGrayLabel(_ label: UILabel) {
        label.textColor = .gray2D2D2D_40
        label.font = .boldSystemFont(ofSize: 14)
        label.autoFontSize()
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        containerView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        containerView.addSubview(subContainerView)
        subContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalTo(separatorView.snp.top).offset(-8)
        }
        
        subContainerView.addSubview(currencySectionView)
        currencySectionView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(PortfolioSectionView.currencySectionWidth)
        }
        
        currencySectionView.addSubview(currencyImageView)
        currencyImageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        currencySectionView.addSubview(currencyLabel)
        currencyLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalTo(currencyImageView.snp.trailing).offset(8)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
        }

        currencySectionView.addSubview(percentageLabel)
        percentageLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalTo(currencyImageView.snp.trailing).offset(8)
//            make.top.equalTo(currencyLabel.snp.bottom)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
        }

        subContainerView.addSubview(balanceSectionView)
        balanceSectionView.snp.makeConstraints { make in
            make.leading.equalTo(currencySectionView.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(PortfolioSectionView.balanceSectionWidth)
        }

        balanceSectionView.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        balanceSectionView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(8)
//            make.top.equalTo(currencyLabel.snp.bottom)
            make.trailing.bottom.equalToSuperview()
        }

        subContainerView.addSubview(dayChangeLabel)
        dayChangeLabel.snp.makeConstraints { make in
            make.leading.equalTo(balanceSectionView.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private let containerView = UIView()
    private let subContainerView = UIView()
    
    private let currencySectionView = UIView()
    private let currencyImageView = UIImageView()
    private let currencyLabel = UILabel()
    private let percentageLabel = UILabel()
    
    private let balanceSectionView = UIView()
    private let balanceLabel = UILabel()
    private let valueLabel = UILabel()
    
    private let dayChangeLabel = UILabel()
    private let separatorView = UIView()
}

extension PortfolioTableViewCell {
    func bind(_ portfolio: PortfolioAssetViewData) {
        currencyImageView.currency(name: portfolio.currency)
        currencyLabel.text = portfolio.currency
        percentageLabel.text = portfolio.percentage
        balanceLabel.text = portfolio.balance
        valueLabel.text = portfolio.value
        dayChangeLabel.text = portfolio.dayChange
        
        var dayChangeDouble = portfolio.dayChange
        dayChangeDouble.removeAll(where: { $0 == "％" })
        if Double(dayChangeDouble) ?? 0 < 0 {
            dayChangeLabel.textColor = #colorLiteral(red: 0.8666666667, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
        } else {
            dayChangeLabel.textColor = #colorLiteral(red: 0.2352941176, green: 0.831372549, blue: 0.5568627451, alpha: 1)
        }
    }
}
