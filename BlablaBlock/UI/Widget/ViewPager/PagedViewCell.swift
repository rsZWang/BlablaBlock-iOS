//
//  PagedViewCell.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/21.
//

import UIKit
import SnapKit

final public class PagedViewCell: UICollectionViewCell {
    
    static let identifier = "PagedViewCell"
    
    private var left: CGFloat = 0
    private var top: CGFloat = 0
    private var right: CGFloat = 0
    private var bottom: CGFloat = 0
    
    private var isNotUpdated = true
    
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
    
    private func setupUI() {
        guard let view = view else { return }
        self.contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(left)
            make.trailing.equalToSuperview().offset(-right)
        }
    }
    
    func updateHeight(height: CGFloat) {
        view?.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
}
