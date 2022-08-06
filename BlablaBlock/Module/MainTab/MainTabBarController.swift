//
//  MainTabBarController.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/20.
//

import UIKit
import SnapKit
import Tabman
import Pageboy

// MARK: - localization

final class MainTabBarController: BaseViewController {
    
    private weak var parentCoordinator: MainCoordinator?
//    private let homePageViewModel: HomePageViewModelType
//    private let exploreUserViewModel: ExploreUserViewModelType
//    private let portfolioViewModel: PortfolioViewModelType
//    private let followViewModel: FollowViewModelType
//    private let exchangeViewModel: ExchangeApiViewModel
    
    init(
        parentCoordinator: MainCoordinator
//        parentCoordinator: MainCoordinator,
//        homePageViewModel: HomePageViewModelType,
//        exploreUserViewModel: ExploreUserViewModelType,
//        portfolioViewModel: PortfolioViewModelType,
//        followViewModel: FollowViewModelType,
//        exchangeViewModel: ExchangeApiViewModel
    ) {
        self.parentCoordinator = parentCoordinator
//        self.homePageViewModel = homePageViewModel
//        self.exploreUserViewModel = exploreUserViewModel
//        self.portfolioViewModel = portfolioViewModel
//        self.followViewModel = followViewModel
//        self.exchangeViewModel = exchangeViewModel
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBar()
    }
    
    private func setupUI() {
        view.backgroundColor = .grayE5E5E5
        pageViewController.isScrollEnabled = false
        
        setupTabBarButton()
        setupContainer()
    }
    
    private func setupTabBar() {
        bottomPaddingView.backgroundColor = .black2D2D2D
        tabBarView.backgroundColor = .black2D2D2D
        let path = UIBezierPath(
            roundedRect: tabBarView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 16, height: 16)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        tabBarView.layer.mask = maskLayer
    }
    
    private func setupTabBarButton() {
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        tabBarView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tabBarButtons.first?.isSelected = true
        radioGroup.delegate = self
        for index in tabBarButtons.indices {
            buttonStackView.addArrangedSubview(addTabBarButton(index: index))
        }
    }
    
    private func addTabBarButton(index: Int) -> UIButton {
        let button = tabBarButtons[index]
        let image = tabBarIcons[index]
        button.setImage(image.image(), for: .normal)
        let selectedImage = "\(image)_selected"
        button.setImage(selectedImage.image(), for: .selected)
        button.setImage(selectedImage.image(), for: .highlighted)
        radioGroup.add(button)
        return button
    }
    
    private func setupContainer() {
        viewControllers.append(ExploreUserViewController(
            parentCoordinator: parentCoordinator,
            viewModel: ExploreUserViewModel()
        ))
        viewControllers.append(PortfolioViewController(
            parentCoordinator: parentCoordinator,
            viewModel: PortfolioViewModel(),
            followViewModel: FollowViewModel(),
            user: nil
        ))
        viewControllers.append(SettingViewController(
            parentCoordinator: parentCoordinator,
            viewModel: SettingViewModel()
        ))
        
//        viewControllers.append(ExploreUserViewController(viewModel: exploreUserViewModel))
//        viewControllers.append(PortfolioViewController(
//            parentCoordinator: parentCoordinator,
//            viewModel: portfolioViewModel,
//            followViewModel: followViewModel,
//            user: nil
//        ))
////        viewControllers.append(SettingViewController())
        
        addChild(pageViewController)
        pageViewController.dataSource = self
        pageViewController.didMove(toParent: self)
    }
    
    private func setupLayout() {
        view.addSubview(tabBarView)
        tabBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(50)
        }
        
        let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        if bottomPadding != 0 {
            view.addSubview(bottomPaddingView)
            bottomPaddingView.snp.makeConstraints { make in
                make.height.equalTo(bottomPadding)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(tabBarView.snp.top)
        }

        containerView.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private let tabBarView = UIView()
    private lazy var bottomPaddingView = UIView()
    private let radioGroup = RadioButtonGroup()
    private let tabBarButtons = [RadioButton(), RadioButton(), RadioButton()]
    private let tabBarIcons = ["ic_main_tab_search", "ic_main_tab_portfolio", "ic_main_tab_setting"]
    private let containerView = UIView()
    private let pageViewController = PageboyViewController()
    private var viewControllers: [UIViewController] = []
}

extension MainTabBarController: PageboyViewControllerDataSource, RadioButtonGroupDelegate {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers.count
    }

    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        .at(index: 0)
    }

    func onClicked(radioButton: RadioButton) {
        if let index = tabBarButtons.firstIndex(of: radioButton) {
            switch index {
            case 0, 1:
                view.backgroundColor = .grayE5E5E5
            default:
                view.backgroundColor = .white
            }
            pageViewController.scrollToPage(.at(index: index), animated: true)
        }
    }
}
