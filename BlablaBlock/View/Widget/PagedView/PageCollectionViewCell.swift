//
//  PageCollectionViewCell.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/21.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 1
    public var view: UIView? {
        didSet {
            self.setupUI()
        }
    }
    
    private func setupUI() {
        guard let view = view else { return }
        self.contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
//        view.snp.makeConstraints { make in
//            make.edges.equalTo(self.contentView)
//        }
    }
}
