//
//  ExchangeCardView.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/24.
//

import UIKit
import SnapKit

protocol ExchangeCardViewDelegate: NSObject {
    func onTap(type: ExchangeType, exchange: ExchangeApiData?)
}

final class ExchangeCardView: UIView, NibOwnerLoadable {
    
    private weak var delegate: ExchangeCardViewDelegate?
    var type: ExchangeType!
    var exchange: ExchangeApiData? {
        didSet {
            setStatus()
        }
    }
    
    convenience init(
        _ delegate: ExchangeCardViewDelegate,
        type: ExchangeType
    ) {
        self.init(frame: .zero)
        self.delegate = delegate
        self.type = type
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        layer.cornerRadius = 4
        
        imageView.makeCircle(base: 24)
        
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        stateLabel.font = .boldSystemFont(ofSize: 12)
        stateLabel.textColor = .white
        stateLabel.textAlignment = .center
        stateLabel.layer.borderWidth = 1
        stateLabel.layer.borderColor = UIColor.white.cgColor
        stateLabel.layer.cornerRadius = 4
        stateLabel.layer.masksToBounds = true
        
        switch type {
        case .binance:
            imageView.image = UIImage(named: "ic_setting_binance")!
            titleLabel.text = "連結幣安"
        case .ftx:
            imageView.image = UIImage(named: "ic_setting_ftx")!
            titleLabel.text = "連結FTX"
        default:
            imageView.image = nil
            titleLabel.text = "UNKNOWN"
        }
        
        setStatus()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }
    
    private func setStatus() {
        if exchange?.isLinked() == true {
            backgroundColor = .black2D2D2D
            titleLabel.textColor = .white
            stateLabel.text = "已連結"
        } else {
            backgroundColor = .black2D2D2D_80
            titleLabel.textColor = .grayFFFFFF_40
            stateLabel.text = "未連結"
        }
    }
    
    private func setupLayout() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(22)
            make.bottom.equalToSuperview().offset(-22)
        }
        
        addSubview(stateLabel)
        stateLabel.snp.makeConstraints { make in
            make.width.equalTo(62)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.trailing.equalTo(stateLabel.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }
    }

    @objc
    private func onTap() {
        if let type = type {
            delegate?.onTap(type: type, exchange: exchange)
        }
    }
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let stateLabel = UILabel()
}
