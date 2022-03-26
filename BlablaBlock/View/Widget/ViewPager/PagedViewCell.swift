//
//  PagedViewCell.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/21.
//

import UIKit

class PagedViewCell: UICollectionViewCell {
    
    static let identifier = "PagedViewCell"
    
    private var leftOffSet: CGFloat = 0
    private var topOffSet: CGFloat = 0
    private var rightOffSet: CGFloat = 0
    private var bottomOffSet: CGFloat = 0
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 1
    var view: UIView? {
        didSet {
            self.setupUI()
        }
    }
    
    func setView(
        left: CGFloat = 0,
        top: CGFloat = 0,
        right: CGFloat = 0,
        bottom: CGFloat = 0,
        view: UIView
    ) {
        leftOffSet = left
        topOffSet = top
        rightOffSet = right
        bottomOffSet = bottom
        self.view = view
    }
    
    private func setupUI() {
        guard let view = view else { return }
        self.contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.left.equalTo(self.contentView).offset(leftOffSet)
            make.top.equalTo(self.contentView).offset(topOffSet)
            make.right.equalTo(self.contentView).offset(rightOffSet)
            make.bottom.equalTo(self.contentView).offset(bottomOffSet)
        }
    }
}
