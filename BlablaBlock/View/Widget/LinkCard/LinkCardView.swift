//
//  LinkCardView.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/24.
//

import UIKit

enum ExchangeType: String {
    case Binance = "binance"
    case FTX = "ftx"
}

protocol LinkCardViewDelegate: NSObject {
    func onTap(type: ExchangeType, exchange: ExchangeData?)
}

class LinkCardView: UIView, NibOwnerLoadable {
    
    weak var delegate: LinkCardViewDelegate?
    var type: ExchangeType!
    var exchange: ExchangeData? = nil {
        didSet {
            setData(exchange: exchange)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var connectionStateBtn: ColorButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init(_ delegate: LinkCardViewDelegate, type: ExchangeType) {
        self.init(frame: .zero)
        self.delegate = delegate
        self.type = type
        switch type {
        case .Binance:
            imageView.image = UIImage(named: "ic_setting_binance")!
            titleLabel.text = "連結幣安"
        case .FTX:
            imageView.image = UIImage(named: "ic_setting_ftx")!
            titleLabel.text = "連結FTX"
        }
    }
    
    func commonInit() {
        loadNibContent()
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/12).isActive = true
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }
    
    private func setData(exchange: ExchangeData?) {
        if exchange?.isLinked() ?? false {
            connectionStateBtn.isSelected = true
            connectionStateBtn.setTitle("已連結", for: .normal)
        } else {
            connectionStateBtn.isSelected = false
            connectionStateBtn.setTitle("未連結", for: .normal)
        }
    }
    
    @objc
    private func onTap() {
        delegate?.onTap(type: type, exchange: exchange)
    }
    
}
