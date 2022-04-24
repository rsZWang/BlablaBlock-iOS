//
//  PNLSectionView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/24.
//

import UIKit
import SnapKit

final class PNLSectionView: UIView {
    
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
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        
        separatorView.backgroundColor = .black2D2D2D
        
        roiTitleLabel.text = "總報酬率"
        setupLabel(roiTitleLabel)
        setupLabel(roiLabel)
        
        roiAnnualTitleLabel.text = "年化報酬率"
        setupLabel(roiAnnualTitleLabel)
        setupLabel(roiAnnualLabel)
        
        mddTitleLabel.text = "最大回撤"
        setupLabel(mddTitleLabel)
        setupLabel(mddLabel)
        
        dailyWinRateTitleLabel.text = "每日勝率"
        setupLabel(dailyWinRateTitleLabel)
        setupLabel(dailyWinRateLabel)
        
        sharpeRatioTitleLabel.text = "Sharp ratio"
        setupLabel(sharpeRatioTitleLabel)
        setupLabel(sharpeRatioLabel)
    }
    
    private func setupLabel(_ label: UILabel) {
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black2D2D2D
    }
    
    private func setupLayout() {
        addSubview(pickerSectionView)
        pickerSectionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        pickerSectionView.addSubview(periodPicker)
        periodPicker.snp.makeConstraints { make in
            make.width.equalTo(92)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(pickerSectionView.snp.bottom)
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        containerView.addSubview(graphSectionView)
        graphSectionView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }

        containerView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(6)
            make.top.equalTo(graphSectionView.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-6)
        }

        containerView.addSubview(textSectionView)
        textSectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(6)
            make.top.equalTo(separatorView.snp.bottom).offset(24)
            make.trailing.equalToSuperview().offset(-6)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        textSectionView.addSubview(roiTitleLabel)
        roiTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }

        textSectionView.addSubview(roiLabel)
        roiLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        textSectionView.addSubview(roiAnnualTitleLabel)
        roiAnnualTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(roiTitleLabel.snp.bottom).offset(8)
        }

        textSectionView.addSubview(roiAnnualLabel)
        roiAnnualLabel.snp.makeConstraints { make in
            make.top.equalTo(roiLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
        }

        textSectionView.addSubview(mddTitleLabel)
        mddTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(roiAnnualTitleLabel.snp.bottom).offset(8)
        }

        textSectionView.addSubview(mddLabel)
        mddLabel.snp.makeConstraints { make in
            make.top.equalTo(roiAnnualLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
        }

        textSectionView.addSubview(dailyWinRateTitleLabel)
        dailyWinRateTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(mddTitleLabel.snp.bottom).offset(8)
        }

        textSectionView.addSubview(dailyWinRateLabel)
        dailyWinRateLabel.snp.makeConstraints { make in
            make.top.equalTo(mddLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
        }

        textSectionView.addSubview(sharpeRatioTitleLabel)
        sharpeRatioTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(dailyWinRateTitleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }

        textSectionView.addSubview(sharpeRatioLabel)
        sharpeRatioLabel.snp.makeConstraints { make in
            make.top.equalTo(dailyWinRateLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private let pickerSectionView = UIView()
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private let graphSectionView = UIView()
    private let separatorView = UIView()
    private let textSectionView = UIView()
    private let roiTitleLabel = UILabel()
    private let roiLabel = UILabel()
    private let roiAnnualTitleLabel = UILabel()
    private let roiAnnualLabel = UILabel()
    private let mddTitleLabel = UILabel()
    private let mddLabel = UILabel()
    private let dailyWinRateTitleLabel = UILabel()
    private let dailyWinRateLabel = UILabel()
    private let sharpeRatioTitleLabel = UILabel()
    private let sharpeRatioLabel = UILabel()
    
    let periodPicker = BlablaBlockPickerView()
    let refreshControl = UIRefreshControl()
}
