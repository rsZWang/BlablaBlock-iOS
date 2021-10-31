//
//  ColorTextButton.swift
//  BlablaBlock
//
//  Created by yhw on 2021/10/20.
//

import UIKit

@IBDesignable
public class ColorTextButton: RadioButton {

    @IBInspectable public var normalColor: UIColor = .lightGray
    @IBInspectable public var selectedColor: UIColor = .black
    @IBInspectable public var underline: Bool = true
    @IBInspectable public var fontSize: CGFloat = 14
    
    override public var buttonType: UIButton.ButtonType { .custom }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        commonInit()
    }
    
    private func commonInit() {
        setTitle(title: titleLabel?.text ?? "TITLE", underline: underline)
    }
    
    public func setTitle(title: String, underline: Bool) {
        if underline {
            setAttributedTitle(
                NSAttributedString(
                    string: title,
                    attributes: [
                        .font : UIFont.systemFont(ofSize: fontSize),
                        .foregroundColor : normalColor,
                        .underlineStyle: 1.0,
                        .baselineOffset : 0
                    ]
                ),
                for: .normal
            )
            setAttributedTitle(
                NSAttributedString(
                    string: title,
                    attributes: [
                        .font : UIFont.systemFont(ofSize: fontSize),
                        .foregroundColor : selectedColor,
                        .underlineStyle : 1.0,
                        .baselineOffset : 0
                    ]
                ),
                for: .selected
            )
            setAttributedTitle(
                NSAttributedString(
                    string: title,
                    attributes: [
                        .font : UIFont.systemFont(ofSize: fontSize),
                        .foregroundColor : selectedColor,
                        .underlineStyle : 1.0,
                        .baselineOffset : 0
                    ]
                ),
                for: .highlighted
            )
        } else {
            setTitleColor(normalColor, for: .normal)
            setTitleColor(selectedColor, for: .selected)
            setTitleColor(selectedColor, for: .highlighted)
            titleLabel!.font = .systemFont(ofSize: fontSize)
        }
    }

}
