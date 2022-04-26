//
//  FollowViewController.swift
//  BlablaBlock
//
//  Created by Harry@rooit on 2022/4/26.
//

import UIKit

final class FollowViewController: BaseViewController {
    
    private var isDefaultPageFollower: Bool!
    private weak var viewModel: FollowViewModelType!
    
    init(
        isDefaultPageFollower: Bool,
        viewModel: FollowViewModelType?
    ) {
        self.isDefaultPageFollower = isDefaultPageFollower
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        view.backgroundColor = .grayEDEDED
        addChild(tabViewController)
        tabViewController.isDefaultPageFollower = isDefaultPageFollower
        tabViewController.viewModel = viewModel
        tabViewController.didMove(toParent: self)
    }
    
    private func setupLayout() {
        view.addSubview(statusBarSection)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        statusBarSection.snp.makeConstraints { make in
            make.height.equalTo(statusBarHeight)
            make.leading.top.trailing.equalToSuperview()
        }
        
        view.addSubview(navigationSectionView)
        navigationSectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(statusBarSection.snp.bottom)
        }
        
        view.addSubview(tabViewControllerContainerView)
        tabViewControllerContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navigationSectionView.snp.bottom)
        }
        
        tabViewControllerContainerView.addSubview(tabViewController.view)
        tabViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private let statusBarSection = UIView()
    private let navigationSectionView = BlablaBlockNavigationBarView()
    private let tabViewControllerContainerView = UIView()
    private let tabViewController = FollowTabViewController()
}
