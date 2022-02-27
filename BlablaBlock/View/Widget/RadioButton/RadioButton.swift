//
//  RadioButton.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/22.
//

import UIKit

public protocol RadioButtonDelegate {
    func onClicked(radioButton: RadioButton)
}

@IBDesignable
open class RadioButton: UIButton {
    
    public var delegate: RadioButtonDelegate?
    
    override public var buttonType: UIButton.ButtonType { get { .custom } }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(selected), for: .touchUpInside)
        commonInit()
    }
    
    private func commonInit() {
        contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        titleLabel?.numberOfLines = 1
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.lineBreakMode = .byClipping
    }
    
    @objc
    private func selected() {
        isSelected = !isSelected
        delegate?.onClicked(radioButton: self)
    }
    
}
