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
        view.backgroundColor = .black2D2D2D
        setupLayout()
        setupTabBarButton()
        setupContainer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBar()
    }
    
    private func setupLayout() {
        view.addSubview(backgroundColorView)
        view.addSubview(tabBarView)
        view.addSubview(containerView)
        containerView.addSubview(pageViewController.view)
        
        backgroundColorView.backgroundColor = .white
        backgroundColorView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(view.layoutMarginsGuide)
        }
        
        tabBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(50)
        }
        
        containerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(tabBarView.snp.top)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTabBar() {
        tabBarView.backgroundColor = .black2D2D2D
        let path = UIBezierPath(
            roundedRect: tabBarView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 12, height: 12)
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
            buttonStackView.addArrangedSubview(setupTabBarButton(index: index))
        }
    }
    
    private func setupContainer() {
        viewControllers.append(HomePageViewController(viewModel: HomePageViewModel()))
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
        
//        viewControllers.append(HomePageViewController(viewModel: homePageViewModel))
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
    
    private let backgroundColorView = UIView()
    private let tabBarView = UIView()
    private let radioGroup = RadioButtonGroup()
    private let tabBarButtons = [RadioButton(), RadioButton(), RadioButton(), RadioButton()]
    private let tabBarIcons = ["ic_main_tab_home", "ic_main_tab_search", "ic_main_tab_portfolio", "ic_main_tab_setting"]
    private let containerView = UIView()
    private let pageViewController = PageboyViewController()
    private var viewControllers: [UIViewController] = []
}

private extension MainTabBarController {
    
    func setupTabBarButton(index: Int) -> UIButton {
        let button = tabBarButtons[index]
        let image = tabBarIcons[index]
        button.setImage(image.image(), for: .normal)
        let selectedImage = "\(image)_selected"
        button.setImage(selectedImage.image(), for: .selected)
        button.setImage(selectedImage.image(), for: .highlighted)
        radioGroup.add(button)
        return button
    }
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
            pageViewController.scrollToPage(.at(index: index), animated: true)
        }
    }
}
