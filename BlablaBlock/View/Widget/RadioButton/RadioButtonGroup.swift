//
//  RadioButtonGroup.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/22.
//

import UIKit

public protocol RadioButtonGroupDelegate: NSObject {
    func onClicked(radioButton: RadioButton)
}

public class RadioButtonGroup: RadioButtonDelegate {
    
    private var buttons = [RadioButton]()
    public var selectedButton: RadioButton! {
        get {
            for button in buttons {
                if button.isSelected {
                    return button
                }
            }
            return nil
        }
    }
    private var _lastButton: RadioButton!
    public var lastButton: RadioButton! {
        _lastButton ?? selectedButton
    }
    public weak var delegate: RadioButtonGroupDelegate?
    
    public func add(_ button: RadioButton) {
        button.delegate = self
        buttons.append(button)
    }

    public func onClicked(radioButton: RadioButton) {
        if !radioButton.isSelected {
            for button in buttons {
                if button.isSelected {
                    _lastButton = button
                    break
                }
            }
            for button in buttons {
                let isThis = button == radioButton
                button.isSelected = isThis
                if isThis {
                    delegate?.onClicked(radioButton: radioButton)
                }
            }
        }
    }
    
}

