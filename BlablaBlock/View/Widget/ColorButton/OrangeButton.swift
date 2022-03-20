//
//  OrangeButton.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/20.
//

import UIKit

final class OrangeButton: ColorButton {
    
    convenience init() {
        self.init(type: .custom)
        rounded = true
        border = true
        borderWidth = 1
        titleSize = 12
        titleBold = true
        
        normalBgColor = .white
        selectedBgColor = .orangeFF9960
        normalTitleColor = .orangeFF9960
        selectedTitleColor = .white
        normalBorderColor = .orangeFF9960
        selectedBorderColor = .orangeFF9960
    }
}
