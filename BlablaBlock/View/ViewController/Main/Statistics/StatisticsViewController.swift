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
    @IBOutlet weak var assetTitleLabel: UILabel!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var listBtn: ColorButton!
    @IBOutlet weak var historyBtn: ColorButton!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radioGroup.delegate = self
        radioGroup.add(listBtn)
        radioGroup.add(historyBtn)
        
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
                if let portfolio = portfolio {
                    self?.portfolioView.refreshControl.endRefreshing()
                    self?.assetLabel.text = portfolio.data.totalValue
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
        if radioButton == listBtn {
            pagedView.moveToPage(at: 0)
        } else {
            pagedView.moveToPage(at: 1)
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
