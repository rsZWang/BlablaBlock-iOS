//
//  BlablaBlockOrangeButtonView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/28.
//

import UIKit
import SnapKit

final public class BlablaBlockOrangeButtonView: UIView {
    
    var isSelected: Bool = false {
        didSet {
            button.isSelected = isSelected
            update()
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            button.isEnabled = isEnabled
            update()
        }
    }
    
    var font: UIFont? {
        didSet {
            button.font = font
        }
    }
    
    public func setTitle(_ title: String?, for state: UIControl.State) {
        button.setTitle(title, for: state)
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        shadowView.backgroundColor = .orangeFF9960_25
        shadowView.layer.cornerRadius = 4
        
        button.isUserInteractionEnabled = false
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: -2, right: 0))
        }
        
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    private let shadowView = UIView()
    private let button = OrangeButton()
    
    private func update() {
        if isSelected && isEnabled {
            shadowView.isHidden = true
        } else {
            shadowView.isHidden = false
        }
    }
}
