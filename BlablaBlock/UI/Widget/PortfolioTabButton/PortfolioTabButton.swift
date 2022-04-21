//
//  PortfolioTabButton.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/21.
//

import UIKit

final class PortfolioTabButton: RadioButton {
    
    override var isSelected: Bool {
        didSet {
            setStatus()
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = CGFloat(6)
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        setTitleColor(.black2D2D2D, for: .selected)
        setTitleColor(.gray2D2D2D_40, for: .normal)
        setStatus()
    }
    
    private func setStatus() {
        if isSelected {
            backgroundColor = .white
            titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        } else {
            backgroundColor = nil
            titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        }
    }
}
