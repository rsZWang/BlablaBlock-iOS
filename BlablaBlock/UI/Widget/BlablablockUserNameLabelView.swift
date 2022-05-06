//
//  BlablablockUserNameLabelView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/5/6.
//

import UIKit
import SnapKit

final public class BlablablockUserNameLabelView: UIView {
    
    public var text: String! {
        didSet {
            nameLabel.text = text
        }
    }
    public var font: UIFont! {
        didSet {
            nameLabel.font = font
        }
    }
    public var textColor: UIColor! {
        didSet {
            nameLabel.textColor = textColor
        }
    }
    public var isCertificated: Bool = false {
        didSet {
            certImageView.isHidden = !isCertificated
        }
    }

    convenience init() {
        self.init(frame: .zero)
        commonInit()
    }

    override public init(frame: CGRect) {
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
        nameLabel.textColor = .black2D2D2D
        
        certImageView.isHidden = true
        certImageView.image = "ic_user_name_ceritficated".image()
    }
    
    private func setupLayout() {
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        self.addSubview(certImageView)
        certImageView.snp.makeConstraints { make in
            make.width.height.equalTo(10)
            make.leading.equalTo(nameLabel.snp.trailing).offset(3)
            make.centerY.equalTo(nameLabel)
        }
    }
    
    private let nameLabel = UILabel()
    private let certImageView = UIImageView()
}

public extension BlablablockUserNameLabelView {
    func setCertification(userId: Int) {
        isCertificated = userId == 57
    }
}
