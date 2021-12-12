//
//  ColorButton.swift
//  BlablaBlock
//
//  Created by yhw on 2021/10/20.
//

import UIKit

@IBDesignable
public class ColorButton: RadioButton {

    public enum Style: Int { case square, rounded }
    
    @IBInspectable public var normalBgColor: UIColor?
    @IBInspectable public var selectedBgColor: UIColor?
    
    @IBInspectable public var normalBorderColor: UIColor?
    @IBInspectable public var selectedBorderColor: UIColor?
    
    @IBInspectable public var normalTitleColor: UIColor?
    @IBInspectable public var selectedTitleColor: UIColor?
    @IBInspectable public var titleSize: CGFloat = 14
    
    @IBInspectable public var rounded: Bool = false
    @IBInspectable public var border: Bool = false
    
    override public var isSelected: Bool {
        didSet { update() }
    }
    
    override public var buttonType: UIButton.ButtonType { .custom }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = rounded ? 6 : 0
        layer.borderWidth = border ? 1 : 0
        titleLabel?.font = .systemFont(ofSize: titleSize)
        update()
    }
    
    internal func update() {
        if isSelected {
            layer.borderColor = selectedBorderColor?.cgColor ?? normalBorderColor?.cgColor
            backgroundColor = selectedBgColor ?? normalBgColor
            setTitleColor(selectedTitleColor ?? normalTitleColor, for: .normal)
        } else {
            layer.borderColor = normalBorderColor?.cgColor
            backgroundColor = normalBgColor
            setTitleColor(normalTitleColor, for: .normal)
        }
    }

}
