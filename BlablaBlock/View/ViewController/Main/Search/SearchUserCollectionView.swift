//
//  SearchUserCollectionView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import UIKit

final class SearchUserCollectionView: UICollectionView {
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 14
        layout.minimumLineSpacing = 18
        self.init(frame: .zero, collectionViewLayout: layout)
        contentInset = UIEdgeInsets(top: 18, left: 14, bottom: 18, right: 14)
        register(SearchUserCollectionViewCell.self, forCellWithReuseIdentifier: SearchUserCollectionViewCell.reuseIdentifier)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
}
