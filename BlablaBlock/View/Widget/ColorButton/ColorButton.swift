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
    @IBInspectable public var disabledBgColor: UIColor?
    @IBInspectable public var highlightedBgColor: UIColor?
    @IBInspectable public var selectedBgColor: UIColor?
    
    @IBInspectable public var normalBorderColor: UIColor?
    @IBInspectable public var disabledBorderColor: UIColor?
    @IBInspectable public var highlightedBorderColor: UIColor?
    @IBInspectable public var selectedBorderColor: UIColor?
    
    @IBInspectable public var normalTitleColor: UIColor?
    @IBInspectable public var disabledTitleColor: UIColor?
    @IBInspectable public var highlightedTitleColor: UIColor?
    @IBInspectable public var selectedTitleColor: UIColor?
    @IBInspectable public var titleSize: CGFloat = 14
    
    @IBInspectable public var rounded: Bool = false
    @IBInspectable public var border: Bool = false
    
    override public var isEnabled: Bool {
        didSet { updateIsEnabled() }
    }
    
    override public var isSelected: Bool {
        didSet { updateIsSelected() }
    }
    
    override public var isHighlighted: Bool {
        didSet { updateIsSelected() }
    }
    
    override public var buttonType: UIButton.ButtonType { .custom }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = rounded ? 6 : 0
        layer.borderWidth = border ? 1 : 0
        titleLabel?.font = .systemFont(ofSize: titleSize)
        updateIsSelected()
        updateIsHighlighted()
    }
    
    internal func updateIsEnabled() {
        if isEnabled {
            layer.borderColor = normalBgColor?.cgColor
            backgroundColor = normalBgColor
            setTitleColor(normalTitleColor, for: .normal)
        } else {
            layer.borderColor = disabledBorderColor?.cgColor
            backgroundColor = disabledBgColor
            setTitleColor(disabledTitleColor, for: .normal)
        }
    }
    
    internal func updateIsSelected() {
        if isEnabled && isSelected {
            layer.borderColor = selectedBorderColor?.cgColor
            backgroundColor = selectedBgColor
            setTitleColor(selectedTitleColor, for: .normal)
        } else {
            updateIsEnabled()
        }
    }
    
    internal func updateIsHighlighted() {
        if isEnabled && isHighlighted {
            layer.borderColor = highlightedBorderColor?.cgColor
            backgroundColor = highlightedBgColor
            setTitleColor(highlightedTitleColor, for: .normal)
        } else {
            updateIsEnabled()
        }
    }
}
