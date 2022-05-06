//
//  PaddingTextField.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import UIKit

final public class TextFieldWithPadding: UITextField {
    
    public var textPadding = UIEdgeInsets(
        top: 4,
        left: 10,
        bottom: 4,
        right: 10
    )

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
