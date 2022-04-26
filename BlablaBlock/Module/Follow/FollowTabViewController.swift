//
//  FollowTabViewController.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import UIKit
import Resolver
import Tabman
import Pageboy

final class FollowTabViewController: BaseTabViewController {
    
    var isDefaultPageFollower: Bool!
    weak var viewModel: FollowViewModelType!
    
    init() {
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
        setupBinding()
        viewModel.inputs.viewWillAppear.accept(())
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        dataSource = self
        setupTab()
    }
    
    private func setupTab() {
        let bar = TMBarView<TMConstrainedHorizontalBarLayout, TMLabelBarButton, TMLineBarIndicator>()
        bar.backgroundView.style = .flat(color: .grayEDEDED)
        bar.layout.transitionStyle = .snap
        bar.indicator.tintColor = .black
        bar.buttons.customize { button in
            button.font = .boldSystemFont(ofSize: 18)
            button.tintColor = .gray
            button.selectedTintColor = .black2D2D2D
            button.snp.makeConstraints { make in
                make.height.equalTo(46)
            }
            let indicator = UIView()
            indicator.backgroundColor = .gray2D2D2D_40
            button.addSubview(indicator)
            indicator.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.width.equalToSuperview()
                make.bottom.equalToSuperview().offset(4)
            }
        }
        addBar(bar, dataSource: self, at: .top)
    }
    
    private func setupBinding() {
        viewModel.outputs
            .followers
            .asObservable()
            .bind(
                to: followerListViewController.tableView.rx.items(
                    cellIdentifier: FollowListTableViewCell.identifier,
                    cellType: FollowListTableViewCell.self
                ),
                curriedArgument: { [weak self] (row, element, cell) in
                    if let self = self {
                        cell.bind(
                            follow: element,
                            followBtnTap: self.viewModel.inputs.followerFollowBtnTap,
                            cellTap: self.viewModel.inputs.followCellTap
                        )
                    }
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .followings
            .asObservable()
            .bind(
                to: followingListViewController.tableView.rx.items(
                    cellIdentifier: FollowListTableViewCell.identifier,
                    cellType: FollowListTableViewCell.self
                ),
                curriedArgument: { [weak self] (row, element, cell) in
                    if let self = self {
                        cell.bind(
                            follow: element,
                            followBtnTap: self.viewModel.inputs.followingFollowBtnTap,
                            cellTap: self.viewModel.inputs.followCellTap
                        )
                    }
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .showUser
            .emit(onNext: { [weak self] user in
//                self?.coordinator.showPortfolioBy(user: user)
            })
            .disposed(by: disposeBag)
    }

    private let followerListViewController = FollowListViewController()
    private let followingListViewController = FollowListViewController()
    private var viewControllers: [UIViewController] {
        [followerListViewController, followingListViewController]
    }
}

extension FollowTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        PageboyViewController.Page.at(index: isDefaultPageFollower ? 0 : 1)
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        if index == 0 {
            return TMBarItem(title: "粉絲")
        } else {
            return TMBarItem(title: "追蹤中")
        }
    }
}
