//
//  LinkCardView.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/24.
//

import UIKit

protocol LinkCardViewDelegate {
    func onTap()
}

class LinkCardView: UIView, NibOwnerLoadable {
    
    private var delegate: LinkCardViewDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var connectionStateBtn: ColorButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init(_ delegate: LinkCardViewDelegate, image: UIImage, title: String) {
        self.init(frame: .zero)
        self.delegate = delegate
        imageView.image = image
        titleLabel.text = title
    }
    
    func commonInit() {
        loadNibContent()
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/12).isActive = true
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }
    
    func setConnection(state: Bool) {
        connectionStateBtn.isSelected = state
        connectionStateBtn.setTitle("已連結", for: .normal)
    }
    
    @objc
    private func onTap() {
        delegate?.onTap()
    }
    
}
