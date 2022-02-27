//
//  PaddingTextField.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import UIKit

class TextFieldWithPadding: UITextField {
    
    var textPadding = UIEdgeInsets(
        top: 4,
        left: 10,
        bottom: 4,
        right: 10
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
}
