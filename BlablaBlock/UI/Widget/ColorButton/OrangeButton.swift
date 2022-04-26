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
        normalTitleColor = .orangeFF9960
        normalBorderColor = .orangeFF9960
        
        selectedBgColor = .orangeFF9960
        selectedTitleColor = .white
        selectedBorderColor = .orangeFF9960
        
        highlightedBgColor = .white
        highlightedTitleColor = .orangeFF9960
        highlightedBorderColor = .orangeFF9960
    }
}
