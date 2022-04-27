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
        
        normalBgColor = .orangeFF9960
        normalTitleColor = .white
        normalBorderColor = .orangeFF9960
        
        highlightedBgColor = .orangeFF9960
        highlightedBgColor = .white
        highlightedBgColor = .orangeFF9960
        
        selectedBgColor = .white
        selectedTitleColor = .orangeFF9960
        selectedBorderColor = .orangeFF9960
    }
}
