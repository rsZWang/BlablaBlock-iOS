//
//  StatisticsViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/23.
//

import UIKit
import Resolver
import RxSwift

class StatisticsViewController: BaseViewController {
    
    @Injected private var statisticsViewModel: StatisticsViewModel

    private let radioGroup = RadioButtonGroup()
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var assetProfitLabel: UILabel!
    @IBOutlet weak var assetSumLabel: UILabel!
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
    private lazy var pagedView: PagedView = {
        let pagedView = PagedView(pages: [portfolioViewCell, pnlViewCell])
//        let pagedView = PagedView(pages: [pnlViewCell, portfolioViewCell])
        pagedView.translatesAutoresizingMaskIntoConstraints = false
        return pagedView
    }()
    
    deinit {
        Timber.i("StatisticsViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radioGroup.delegate = self
        radioGroup.add(protfolioButton)
        radioGroup.add(pnlButton)
        radioGroup.add(followingButton)
        
        portfolioView.delegate = self
        portfolioView.counterLabel.isHidden = true
        pnlView.delegate = self
        
        pagerSectionView.addSubview(pagedView)
        pagerSectionView.snp.makeConstraints { make in
            make.edges.equalTo(pagedView)
        }
        
        statisticsViewModel.errorMessageObservable
            .subscribe(onNext: { [weak self] msg in
                self?.portfolioView.refreshControl.endRefreshing()
                self?.promptAlert(message: msg)
            })
            .disposed(by: disposeBag)
        
        portfolioView.refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.statisticsViewModel.getPortfolio(exchange: "")
            })
            .disposed(by: disposeBag)
        
        statisticsViewModel.portfolioObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] portfolio in
                self?.portfolioView.refreshControl.endRefreshing()
                if let portfolio = portfolio {
                    self?.assetProfitLabel.attributedText = portfolio.data.getProfitString()
                    self?.assetSumLabel.attributedText = portfolio.data.getTotalValueString()
                    self?.tableView.bind(data: portfolio.getViewData())
                }
            })
            .disposed(by: disposeBag)
        
        statisticsViewModel.pnlObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pnlData in
                if let data = pnlData {
                    self?.pnlView.bind(data: data)
                }
            })
            .disposed(by: disposeBag)
        
        statisticsViewModel.getPortfolio(exchange: "")
        statisticsViewModel.getPNL(period: "")
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

extension StatisticsViewController: PortfolioViewDelegate {
    func onExchangeFiltered(exchange: String) {
        statisticsViewModel.getPortfolio(exchange: exchange)
    }
}

extension StatisticsViewController: PNLViewDelegate {
    func onPeriodFiltered(period: String) {
        statisticsViewModel.getPNL(period: period)
    }
}
