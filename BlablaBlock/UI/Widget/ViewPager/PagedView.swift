//
//  PagedView.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/21.
//

import UIKit
import SnapKit

public protocol PagedViewDelegate: AnyObject {
    func didMoveToPage(index: Int)
}

final public class PagedView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private var pages: [UIView] = []
    
    // MARK: - Initialization
    init(pages: [UIView]) {
        super.init(frame: .zero)
        self.setPages(pages: pages)
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Properties
    public weak var delegate: PagedViewDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PagedViewCell.self, forCellWithReuseIdentifier: PagedViewCell.identifier)
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    // MARK: - UI Setup
    func setPages(pages: [UIView]) {
        self.pages.append(contentsOf: pages)
        self.setupUI()
    }
    
    private func setupUI() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    public func moveToPage(at index: Int) {
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    // MARK: - Delegate
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(self.collectionView.contentOffset.x / self.collectionView.frame.size.width)
        self.delegate?.didMoveToPage(index: page)
    }
    
    // MARK: - Data Source
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pages.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PagedViewCell", for: indexPath) as! PagedViewCell
        let page = self.pages[indexPath.item]
        cell.view = page
        cell.updateHeight(height: collectionView.contentSize.height)
        return cell
    }
    
    // MARK: - Layout Delegate
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: collectionView.frame.width,
            height: collectionView.frame.height
        )
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
}
