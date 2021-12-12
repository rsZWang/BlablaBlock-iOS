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
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(selected), for: .touchUpInside)
    }
    
    @objc
    private func selected() {
        isSelected = !isSelected
        delegate?.onClicked(radioButton: self)
    }
    
}
