//
//  FollowingPortfolioTableViewCell.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/24.
//

import UIKit
import SnapKit
import RxSwift

final class FollowingPortfolioTableViewCell: UITableViewCell {
    
    static let identifier = "FollowingPortfolioTableViewCell"
    
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
        
        setupLabel(currencyLabel)
        currencyLabel.textAlignment = .left
        
        setupLabel(balanceLabel)
        balanceLabel.textAlignment = .right

        dayChangeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        dayChangeLabel.textAlignment = .right
        dayChangeLabel.autoFontSize()
    }
    
    private func setupLabel(_ label: UILabel) {
        label.textColor = .black2D2D2D
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
            make.width.equalToSuperview().multipliedBy(FollowingPortfolioSectionView.currencySectionWidth)
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
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }

        subContainerView.addSubview(balanceSectionView)
        balanceSectionView.snp.makeConstraints { make in
            make.leading.equalTo(currencySectionView.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(FollowingPortfolioSectionView.balanceSectionWidth)
        }

        balanceSectionView.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
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
    
    private let balanceSectionView = UIView()
    private let balanceLabel = UILabel()
    
    private let dayChangeLabel = UILabel()
    private let separatorView = UIView()
}

extension FollowingPortfolioTableViewCell {
    func bind() {
        
    }
}
