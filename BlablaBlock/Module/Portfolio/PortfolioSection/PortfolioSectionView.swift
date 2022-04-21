//
//  PortfolioSectionView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/21.
//

import UIKit
import SnapKit

public final class PortfolioSectionView: UIView {
    
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
        historyButton.setImage("ic_portfolio_history".image(), for: .normal)
        historyButton.backgroundColor = .grayEDEDED
        historyButton.layer.cornerRadius = 4
        historyButton.addTarget(self, action: #selector(toHistory), for: .touchUpInside)
        
        pickerSectionView.backgroundColor = .red
    }
    
    private func setupLayout() {
        addSubview(pickerSectionView)
        pickerSectionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        pickerSectionView.addSubview(exchangePicker)
        exchangePicker.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(92)
        }
        
        pickerSectionView.addSubview(typePicker)
        typePicker.snp.makeConstraints { make in
            make.leading.equalTo(exchangePicker.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(104)
        }
        
        pickerSectionView.addSubview(historyButton)
        historyButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private let pickerSectionView = UIView()
    private let exchangePicker = BlablaBlockPickerView()
    private let typePicker = BlablaBlockPickerView()
    private let historyButton = UIButton()
    private let headerSectionView = UIView()
    
    @objc
    private func toHistory() {
        Timber.i("toHistory")
    }
}
