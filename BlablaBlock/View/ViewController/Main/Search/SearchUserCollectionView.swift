//
//  SearchUserCollectionView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import UIKit

final class SearchUserCollectionView: UICollectionView {
    
    static var cellWidth: CGFloat { (UIScreen.main.bounds.width / 2) - 24 }
    static var cellHeight: CGFloat { 100 }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: Self.cellWidth, height: Self.cellHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.init(frame: .zero, collectionViewLayout: layout)
        contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 14, right: 14)
        register(
            SearchUserCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchUserCollectionViewCell.reuseIdentifier
        )
        alwaysBounceVertical = true
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
}
