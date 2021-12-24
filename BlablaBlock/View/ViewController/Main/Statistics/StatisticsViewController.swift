//
//  StatisticsViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/23.
//

import UIKit
import Resolver
import SwiftCharts

class StatisticsViewController: BaseViewController, RadioButtonGroupDelegate {
    
    @Injected private var statisticsViewModel: StatisticsViewModel

    private let radioGroup = RadioButtonGroup()
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var assetTitleLabel: UILabel!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var listBtn: ColorButton!
    @IBOutlet weak var historyBtn: ColorButton!
    @IBOutlet weak var pagerSectionView: UIView!
    private let portfolioView = PortfolioView()
    private var tableView: ExchangeListTableView { portfolioView.tableView }
    private lazy var portfolioViewCell: PagedViewCell = {
        let cell = PagedViewCell()
        cell.view = portfolioView
        return cell
    }()
    private let pnlView = PNLView()
    private lazy var pnlViewCell: PagedViewCell = {
        let cell = PagedViewCell()
        cell.view = pnlView
        return cell
    }()
    private lazy var pagedView: PagedView = {
//        let pagedView = PagedView(pages: [statisticsCell])
        let pagedView = PagedView(pages: [pnlView, portfolioViewCell])
        pagedView.translatesAutoresizingMaskIntoConstraints = false
        return pagedView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radioGroup.delegate = self
        radioGroup.add(listBtn)
        radioGroup.add(historyBtn)
        
        pagerSectionView.addSubview(pagedView)
        pagerSectionView.snp.makeConstraints { make in
            make.edges.equalTo(pagedView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.makeCircle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statisticsViewModel.getPortfolio()
            .subscribe(
                onSuccess: { [unowned self] portfolio in
                    tableView.setData(portfolio.data)
                },
                onFailure: { [unowned self] error in
                    promptAlert(message: "\(error)")
                }
            )
            .disposed(by: disposeBag)
        
        statisticsViewModel.getPNL()
            .subscribe(
                onSuccess: { [unowned self] pnl in
                    pnlView.drawChart()
                },
                onFailure: { [unowned self] error in
                    pnlView.drawChart()
                    promptAlert(message: "\(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func onClicked(radioButton: RadioButton) {
        if radioButton == listBtn {
            pagedView.moveToPage(at: 0)
        } else {
            pagedView.moveToPage(at: 1)
        }
    }
    
}
