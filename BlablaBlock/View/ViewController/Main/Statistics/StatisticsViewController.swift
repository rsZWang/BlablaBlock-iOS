//
//  StatisticsViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/23.
//

import UIKit
import Resolver
import RxCocoa
import RxSwift

final class StatisticsViewController: BaseViewController {
    
    @Injected var mainCoordinator: MainCoordinator
    var userId: String!
    var viewModel: StatisticsViewModelType!

    private let radioGroup = RadioButtonGroup()
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var assetProfitLabel: UILabel!
    @IBOutlet weak var assetSumLabel: UILabel!
    @IBOutlet weak var followerSection: UIView!
    @IBOutlet weak var followingSection: UIView!
    @IBOutlet weak var shareButton: ColorButton!
    @IBOutlet weak var protfolioButton: ColorButton!
    @IBOutlet weak var pnlButton: ColorButton!
    @IBOutlet weak var followingButton: ColorButton!
    @IBOutlet weak var pagerSectionView: UIView!
    private lazy var portfolioView = PortfolioView()
    private var tableView: ExchangeListTableView { portfolioView.tableView }
    private lazy var portfolioViewCell: PagedViewCell = {
        let cell = PagedViewCell()
        cell.setView(view: portfolioView)
        return cell
    }()
    private lazy var pnlView = PNLView()
    private lazy var pnlViewCell: PagedViewCell = {
        let cell = PagedViewCell()
        cell.setView(view: pnlView)
        return cell
    }()
    private lazy var pagedView = PagedView(pages: [portfolioViewCell, pnlViewCell])
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
//    init(viewModel: StatisticsViewModelType) {
//        self.viewModel = viewModel
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userId = userId {
            let viewModel = FollowerViewModel(userId: userId)
            portfolioView.delegate = viewModel
            pnlView.delegate = viewModel
            self.viewModel = viewModel
        } else {
            let viewModel = StatisticsViewModel()
            portfolioView.delegate = viewModel
            pnlView.delegate = viewModel
            self.viewModel = viewModel
        }
        
        radioGroup.delegate = self
        radioGroup.add(protfolioButton)
        radioGroup.add(pnlButton)
        radioGroup.add(followingButton)
        
        pagerSectionView.addSubview(pagedView)
        pagerSectionView.snp.makeConstraints { make in
            make.edges.equalTo(pagedView)
        }
        
        nameLabel.text = keychainUser[.userName]
        
        setupBinding()
        viewModel.inputs.viewDidLoad.accept(())

//        statisticsViewModel.historyBtnObservable
//            .subscribe(onNext: { [weak self] in
//                self?.mainCoordinator.showTradeHistory()
//            })
//            .disposed(by: disposeBag)
    }
    
    private func setupBinding() {
//        Observable.merge(
//            followerSection.rx.tapGesture().when(.recognized),
//            followingButton.rx.tapGesture().when(.recognized)
//        ).subscribe(
//            onNext: { [weak self] _ in
//                self?.mainCoordinator.showFollow()
//            }
//        )
//        .disposed(by: disposeBag)
        
        followerSection.rx
            .tapGesture()
            .when(.recognized)
            .map { _ in true }
            .subscribe(onNext: mainCoordinator.showFollow)
            .disposed(by: disposeBag)
        
        followingSection.rx
            .tapGesture()
            .when(.recognized)
            .map { _ in false }
            .subscribe(onNext: mainCoordinator.showFollow)
            .disposed(by: disposeBag)
        
        shareButton.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.promptAlert(message: "此功能尚未開放")
            }).disposed(by: disposeBag)
        
        portfolioView.refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.refresh)
            .disposed(by: disposeBag)
        
        pnlView.refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.refresh)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .portfolio
            .map { $0.profit }
            .emit(to: assetProfitLabel.rx.attributedText)
            .disposed(by: disposeBag)
            
        viewModel.outputs
            .portfolio
            .map { $0.sum }
            .emit(to: assetSumLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .portfolio
            .asObservable()
            .map { $0.assets }
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: "ExchangeListTableViewCell",
                    cellType: ExchangeListTableViewCell.self
                ),
                curriedArgument: { (row, element, cell) in
                    cell.bind(element)
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .pnl
            .emit(onNext: pnlView.bind)
            .disposed(by: disposeBag)
        
        viewModel
            .outputs
            .portfolioRefresh
            .emit(to: portfolioView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel
            .outputs
            .pnlRefresh
            .emit(to: pnlView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
//        statisticsViewModel.errorMessageObservable
//            .observe(on: MainScheduler.asyncInstance)
//            .subscribe(onNext: { [weak self] msg in
//                self?.portfolioView.refreshControl.endRefreshing()
//                self?.promptAlert(message: msg)
//            })
//            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.makeCircle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension StatisticsViewController: RadioButtonGroupDelegate {
    func onClicked(radioButton: RadioButton) {
        if radioButton == protfolioButton {
            pagedView.moveToPage(at: 0)
        } else if radioButton == pnlButton {
            pagedView.moveToPage(at: 1)
        } else {
            radioGroup.lastButton.sendActions(for: .touchUpInside)
        }
    }
}
