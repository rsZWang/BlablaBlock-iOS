//
//  PortfolioSectionView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/21.
//

import UIKit
import SnapKit

public final class PortfolioSectionView: UIView {
    
    static let currencySectionWidth = 0.38
    static let balanceSectionWidth = 0.38
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        historyButton.layer.cornerRadius = 4
        historyButton.setImage("ic_portfolio_history".image(), for: .normal)
        historyButton.backgroundColor = .grayEDEDED

        headerSectionSeparatorView.backgroundColor = .black2D2D2D
        
        currencyTitleLabel.text = "代幣"
        currencyTitleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        currencyTitleLabel.textColor = .black2D2D2D_80
        currencyTitleLabel.textAlignment = .left
        
        balanceTitleLabel.text = "曝險"
        balanceTitleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        balanceTitleLabel.textColor = .black2D2D2D_80
        balanceTitleLabel.textAlignment = .right
        
        dayChangeTitleLabel.text = "24h漲跌"
        dayChangeTitleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        dayChangeTitleLabel.textColor = .black2D2D2D_80
        dayChangeTitleLabel.textAlignment = .right
    }
    
    private func setupLayout() {
        addSubview(pickerSectionView)
        pickerSectionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        pickerSectionView.addSubview(exchangePicker)
        exchangePicker.snp.makeConstraints { make in
            make.width.equalTo(92)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        pickerSectionView.addSubview(typePicker)
        typePicker.snp.makeConstraints { make in
            make.width.equalTo(104)
            make.leading.equalTo(exchangePicker.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        
        pickerSectionView.addSubview(historyButton)
        historyButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        addSubview(headerSectionView)
        headerSectionView.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.top.equalTo(pickerSectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        headerSectionView.addSubview(currencyTitleLabel)
        currencyTitleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(PortfolioSectionView.currencySectionWidth)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        headerSectionView.addSubview(balanceTitleLabel)
        balanceTitleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(PortfolioSectionView.balanceSectionWidth)
            make.leading.equalTo(currencyTitleLabel.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        headerSectionView.addSubview(dayChangeTitleLabel)
        dayChangeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(balanceTitleLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        addSubview(headerSectionSeparatorView)
        headerSectionSeparatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerSectionView.snp.bottom)
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerSectionSeparatorView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private let pickerSectionView = UIView()
    private let headerSectionView = UIView()
    private let currencyTitleLabel = UILabel()
    private let balanceTitleLabel = UILabel()
    private let dayChangeTitleLabel = UILabel()
    private let headerSectionSeparatorView = UIView()
    
    let exchangePicker = BlablaBlockPickerView()
    let typePicker = BlablaBlockPickerView()
    let historyButton = UIButton()
    let tableView = PortfolioTableView()
}
