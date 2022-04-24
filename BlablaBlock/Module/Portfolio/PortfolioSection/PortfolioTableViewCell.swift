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
        
        currencyLabel.textColor = .black2D2D2D
        currencyLabel.font = .boldSystemFont(ofSize: 14)
        currencyLabel.textAlignment = .left
        currencyLabel.numberOfLines = 1
        currencyLabel.adjustsFontSizeToFitWidth = true
        
        percentageLabel.textColor = .gray2D2D2D_40
        percentageLabel.font = .systemFont(ofSize: 12, weight: .medium)
        percentageLabel.textAlignment = .left
        percentageLabel.numberOfLines = 1
        percentageLabel.adjustsFontSizeToFitWidth = true
        
        balanceLabel.textColor = .black2D2D2D
        balanceLabel.font = .boldSystemFont(ofSize: 14)
        balanceLabel.textAlignment = .right
        balanceLabel.numberOfLines = 1
        balanceLabel.adjustsFontSizeToFitWidth = true
        
        valueLabel.textColor = .gray2D2D2D_40
        valueLabel.font = .systemFont(ofSize: 12, weight: .medium)
        valueLabel.textAlignment = .right
        valueLabel.numberOfLines = 1
        valueLabel.adjustsFontSizeToFitWidth = true
        
        dayChangeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        dayChangeLabel.textAlignment = .right
        dayChangeLabel.numberOfLines = 1
        dayChangeLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupLayout() {
        contentView.addSubview(contentParentView)
        contentParentView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        contentParentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentParentView.addSubview(contentPaddingView)
        contentPaddingView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalTo(separatorView.snp.top).offset(-8)
        }
        
        contentPaddingView.addSubview(currencySectionView)
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
            make.top.equalTo(currencyLabel.snp.bottom)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
        }

        contentPaddingView.addSubview(balanceSectionView)
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
            make.top.equalTo(currencyLabel.snp.bottom)
            make.trailing.bottom.equalToSuperview()
        }

        contentPaddingView.addSubview(dayChangeLabel)
        dayChangeLabel.snp.makeConstraints { make in
            make.leading.equalTo(balanceSectionView.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private let contentParentView = UIView()
    private let contentPaddingView = UIView()
    
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
    func bind() {
        
    }
}
