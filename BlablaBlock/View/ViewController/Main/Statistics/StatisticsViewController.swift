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

class StatisticsViewController: BaseViewController {
    
    @Injected private var statisticsViewModel: StatisticsViewModel

    private let radioGroup = RadioButtonGroup()
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var assetProfitLabel: UILabel!
    @IBOutlet weak var assetSumLabel: UILabel!
    @IBOutlet weak var followerSection: UIView!
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
        Timber.i("StatisticsViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radioGroup.delegate = self
        radioGroup.add(protfolioButton)
        radioGroup.add(pnlButton)
        radioGroup.add(followingButton)
        
        portfolioView.delegate = statisticsViewModel
        pnlView.delegate = statisticsViewModel
        
        pagerSectionView.addSubview(pagedView)
        pagerSectionView.snp.makeConstraints { make in
            make.edges.equalTo(pagedView)
        }
        
        nameLabel.text = keychainUser[.userName]
        
        portfolioView.refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.statisticsViewModel.getPortfolio()
            })
            .disposed(by: disposeBag)
        
        statisticsViewModel.assetProfitObservable
            .bind(to: assetProfitLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        statisticsViewModel.assetSumObservable
            .bind(to: assetSumLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        Observable.merge(
            followerSection.rx.tapGesture().when(.recognized),
            shareButton.rx.tapGesture().when(.recognized),
            followingButton.rx.tapGesture().when(.recognized)
        ).subscribe(onNext: { [weak self] _ in
            self?.promptAlert(message: "此功能尚未開放")
        }).disposed(by: disposeBag)
        
        shareButton.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.promptAlert(message: "此功能尚未開放")
            }).disposed(by: disposeBag)
        
        statisticsViewModel.portfolioViewDataListObservable
            .subscribe(onNext: { [weak self] viewDataList in
                self?.portfolioView.refreshControl.endRefreshing()
                if let viewDataList = viewDataList {
                    self?.tableView.bind(data: viewDataList)
                }
            })
            .disposed(by: disposeBag)
        
        statisticsViewModel.pnlObservable
            .subscribe(onNext: { [weak self] pnlData in
                if let data = pnlData {
                    self?.pnlView.bind(data: data)
                }
            })
            .disposed(by: disposeBag)
        
        statisticsViewModel.pnlRefreshObservable
            .bind(to: pnlView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        statisticsViewModel.errorMessageObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] msg in
                self?.portfolioView.refreshControl.endRefreshing()
                self?.promptAlert(message: msg)
            })
            .disposed(by: disposeBag)
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
//            let index: Int
//            if radioGroup.lastButton == protfolioButton {
//                index = 0
//            } else {
//                index = 1
//            }
            radioGroup.lastButton.sendActions(for: .touchUpInside)
        }
    }
}
