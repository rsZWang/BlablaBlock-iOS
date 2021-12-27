//
//  SettingViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/24.
//

import UIKit
import RxSwift
import Resolver

class SettingViewController: BaseViewController, LinkCardViewDelegate {
    
    @Injected var mainCoordinator: MainCoordinator
    @Injected var authViewModel: AuthViewModel
    @Injected var statisticsViewModel: StatisticsViewModel
    @Injected var exchangeApiViewModel: ExchangeApiViewModel
    
    private lazy var binanceLinkCard = LinkCardView(self, type: .Binance)
    private lazy var ftxLinkCard = LinkCardView(self, type: .FTX)

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var signOutButton: ColorButton!
    @IBOutlet weak var linkCardViewListStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        linkCardViewListStackView.spacing = 20
        linkCardViewListStackView.addArrangedSubview(binanceLinkCard)
        linkCardViewListStackView.addArrangedSubview(ftxLinkCard)

        let exchangeList = statisticsViewModel.exhangesObservable.value!
        refreshList(exchangeList: exchangeList)
        
        signOutButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.signOutButton.isEnabled = false
                self?.authViewModel.signOut()
            })
            .disposed(by: disposeBag)
        
        authViewModel.successObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.mainCoordinator.popToSignIn()
                }
                self?.signOutButton.isEnabled = true
            })
            .disposed(by: disposeBag)
        
        authViewModel.errorMessageObservable
            .subscribe(onNext: { [weak self] msg in
                self?.signOutButton.isEnabled = true
            })
            .disposed(by: disposeBag)

        exchangeApiViewModel.exhangeListObservable
            .subscribe(onNext: { [weak self] exchangeList in
                self?.refreshList(exchangeList: exchangeList)
            })
            .disposed(by: disposeBag)

        exchangeApiViewModel.errorMessageObservable
            .subscribe(onNext: { [weak self] msg in
                self?.promptAlert(message: msg)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.makeCircle()
    }
    
    private func refreshList(exchangeList: [ExchangeApiData]) {
        if exchangeList.isEmpty {
            binanceLinkCard.exchange = nil
            ftxLinkCard.exchange = nil
        } else {
            if let binance = exchangeList.first(where: { $0.exchange == "binance" }) {
                binanceLinkCard.exchange = binance
            }
            if let ftx = exchangeList.first(where: { $0.exchange == "ftx" }) {
                ftxLinkCard.exchange = ftx
            }
        }
    }
    
    func onTap(type: Exchange.ExchangeType, exchange: ExchangeApiData?) {
        if let exchange = exchange {
            promptActionSheetAlert(type: type, exchange: exchange)
        } else {
            promptLinkViewController(type: type, exchange: exchange)
        }
    }
    
    private func promptLinkViewController(type: Exchange.ExchangeType, exchange: ExchangeApiData?) {
        let vc = LinkExchangeViewController()
        vc.exchangeType = type
        vc.exchange = exchange
        present(vc, animated: true)
    }
    
    private func promptActionSheetAlert(type: Exchange.ExchangeType, exchange: ExchangeApiData) {
        AlertBuilder()
            .setStyle(.actionSheet)
            .setButton(title: "修改") { [weak self] in
                self?.promptLinkViewController(type: type, exchange: exchange)
            }
            .setButton(title: "刪除") { [weak self] in
                self?.promptDeleteAlert(exchange: exchange)
            }
            .setButton(title: "取消", style: .cancel)
            .show(self)
    }
    
    private func promptDeleteAlert(exchange: ExchangeApiData) {
        AlertBuilder()
            .setTitle("確定要刪除嗎？")
            .setButton(title: "確定") { [weak self] in
                self?.exchangeApiViewModel.delete(id: exchange.id)
            }
            .setButton(title: "取消", style: .cancel)
            .show(self)
    }

}
