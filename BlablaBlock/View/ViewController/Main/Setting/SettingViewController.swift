//
//  SettingViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/24.
//

import UIKit
import RxSwift
import Resolver

final class SettingViewController: BaseViewController, LinkCardViewDelegate {
    
    @Injected var mainCoordinator: MainCoordinator
    @Injected var authViewModel: AuthViewModel
    @Injected var exchangeApiViewModel: ExchangeApiViewModel
    
    private lazy var linkCardList = [
        LinkCardView(self, type: .binance),
        LinkCardView(self, type: .ftx)
    ]

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signOutButton: ColorButton!
    @IBOutlet weak var linkCardViewListStackView: UIStackView!
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        linkCardViewListStackView.spacing = 20
        for card in linkCardList {
            linkCardViewListStackView.addArrangedSubview(card)
        }
        
        nameLabel.text = keychainUser[.userName]
        
        signOutButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.signOutButton.isEnabled = false
                self?.authViewModel.signOut()
            })
            .disposed(by: disposeBag)
        
        authViewModel.successObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.mainCoordinator.popToSignIn()
                }
                self?.signOutButton.isEnabled = true
            })
            .disposed(by: disposeBag)
        
        authViewModel.errorMessageObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] msg in
                self?.signOutButton.isEnabled = true
            })
            .disposed(by: disposeBag)

        exchangeApiViewModel.exhangeListObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] exchangeList in
                self?.refreshList(exchangeList: exchangeList)
            })
            .disposed(by: disposeBag)

        exchangeApiViewModel.errorMessageObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] msg in
                self?.promptAlert(message: msg)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.makeCircle()
    }
    
    private func refreshList(exchangeList: [ExchangeApiData]) {
        for card in linkCardList {
            card.exchange = exchangeList.first { $0.exchange == card.type.rawValue }
        }
    }
    
    func onTap(type: ExchangeType, exchange: ExchangeApiData?) {
        if let exchange = exchange {
            promptActionSheetAlert(type: type, exchange: exchange)
        } else {
            promptLinkViewController(type: type, exchange: exchange)
        }
    }
    
    private func promptLinkViewController(type: ExchangeType, exchange: ExchangeApiData?) {
        let vc = LinkExchangeViewController()
        vc.exchangeType = type
        vc.exchange = exchange
        present(vc, animated: true)
    }
    
    private func promptActionSheetAlert(type: ExchangeType, exchange: ExchangeApiData) {
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
