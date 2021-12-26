//
//  StatisticsViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/23.
//

import UIKit
import Resolver
import RxSwift

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
        
        statisticsViewModel.errorMessageObservable
            .subscribe(onNext: { [weak self] msg in
                self?.promptAlert(message: msg)
            })
            .disposed(by: disposeBag)
        
        statisticsViewModel.portfolioObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] portfolioData in
                if let data = portfolioData {
                    tableView.bind(data: data)
                }
            })
            .disposed(by: disposeBag)
        
        statisticsViewModel.pnlObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] pnlData in
                if let data = pnlData {
                    pnlView.bind(data: data)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.makeCircle()
    }
    
    func onClicked(radioButton: RadioButton) {
        if radioButton == listBtn {
            pagedView.moveToPage(at: 0)
        } else {
            pagedView.moveToPage(at: 1)
        }
    }
    
}
