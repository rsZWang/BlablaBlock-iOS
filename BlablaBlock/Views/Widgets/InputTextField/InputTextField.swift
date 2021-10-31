//
//  InputTextField.swift
//  BlablaBlock
//
//  Created by yhw on 2021/10/20.
//

import UIKit

@IBDesignable
class InputTextField: UIView, NibOwnerLoadable {
    
    @IBInspectable var placeholder: String? {
        didSet { textField.placeholder = placeholder }
    }
    
    @IBOutlet weak var textField: UITextField!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    convenience public init() {
        self.init(frame: .zero)
    }
    
    private func commonInit() {
        loadNibContent()
        textField.contentVerticalAlignment =  .bottom
    }

}
