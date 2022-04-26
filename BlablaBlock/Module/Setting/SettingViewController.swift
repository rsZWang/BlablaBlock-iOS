//
//  SettingViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/24.
//

import UIKit
import SnapKit
import RxSwift

final class SettingViewController: BaseViewController {
    
//    @Injected var mainCoordinator: MainCoordinator
//    @Injected var authViewModel: AuthViewModel
//    @Injected var exchangeApiViewModel: ExchangeApiViewModel
//    
//    private lazy var linkCardList = [
//        LinkCardView(self, type: .binance),
//        LinkCardView(self, type: .ftx)
//    ]
    
    private weak var parentCoordinator: MainCoordinator!
    private let viewModel: SettingViewModelType
    
    init(
        parentCoordinator: MainCoordinator?,
        viewModel: SettingViewModelType
    ) {
        self.parentCoordinator = parentCoordinator
        self.viewModel = viewModel
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
        setupLayout()
    
//        linkCardViewListStackView.spacing = 20
//        for card in linkCardList {
//            linkCardViewListStackView.addArrangedSubview(card)
//        }
//
//        nameLabel.text = keychainUser[.userName]
//
//        signOutButton.rx
//            .tap
//            .subscribe(onNext: { [weak self] in
//                self?.signOutButton.isEnabled = false
//                self?.authViewModel.signOut()
//            })
//            .disposed(by: disposeBag)
//
//        authViewModel.successObservable
//            .observe(on: MainScheduler.asyncInstance)
//            .subscribe(onNext: { [weak self] success in
//                if success {
////                    self?.mainCoordinator.popToSignIn()
//                }
//                self?.signOutButton.isEnabled = true
//            })
//            .disposed(by: disposeBag)
//
//        authViewModel.errorMessageObservable
//            .observe(on: MainScheduler.asyncInstance)
//            .subscribe(onNext: { [weak self] msg in
//                self?.signOutButton.isEnabled = true
//            })
//            .disposed(by: disposeBag)
//
//        exchangeApiViewModel.exhangeListObservable
//            .observe(on: MainScheduler.asyncInstance)
//            .subscribe(onNext: { [weak self] exchangeList in
//                self?.refreshList(exchangeList: exchangeList)
//            })
//            .disposed(by: disposeBag)
//
//        exchangeApiViewModel.errorMessageObservable
//            .observe(on: MainScheduler.asyncInstance)
//            .subscribe(onNext: { [weak self] msg in
//                self?.promptAlert(message: msg)
//            })
//            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        avatarImageView.image = "ic_profile_avatar_placeholder".image()
        avatarImageView.makeCircle(base: 74)
        avatarImageView.contentMode = .scaleAspectFit
        
        userNameLabel.text = keychainUser[.userName] ?? keychainUser[.userEmail]
        userNameLabel.font = .boldSystemFont(ofSize: 18)
        userNameLabel.textColor = .black2D2D2D
        userNameLabel.autoFontSize()
    }
    
    private func setupLayout() {
        view.addSubview(statusBarSection)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        statusBarSection.snp.makeConstraints { make in
            make.height.equalTo(statusBarHeight)
            make.leading.top.trailing.equalToSuperview()
        }
        
        view.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(74)
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(statusBarSection.snp.bottom).offset(16)
        }
        
        view.addSubview(infoSectionView)
        infoSectionView.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(32)
            make.top.bottom.equalTo(avatarImageView)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        infoSectionView.addSubview(userNameSectionView)
        userNameSectionView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.leading.top.trailing.equalToSuperview()
        }
        
        userNameSectionView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        infoSectionView.addSubview(editButtonSectionView)
        editButtonSectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(userNameSectionView.snp.bottom).offset(12)
        }
        
        editButtonSectionView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.width.equalTo(85)
            make.height.equalTo(22)
            make.leading.top.equalToSuperview()
        }
        
        view.addSubview(exchangeSectionView)
        exchangeSectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
        }
        
        exchangeSectionView.addSubview(scrollView)
        exchangeSectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(24)
        }
        
        scrollView.addSubview(scrollContainerView)
        scrollContainerView.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

//    private func refreshList(exchangeList: [ExchangeApiData]) {
//        Timber.i("refresh list: \(exchangeList)")
//        for card in linkCardList {
//            card.exchange = exchangeList.first { $0.exchange == card.type.rawValue }
//        }
//    }
//
//    func onTap(type: ExchangeType, exchange: ExchangeApiData?) {
//        if let exchange = exchange {
//            promptActionSheetAlert(type: type, exchange: exchange)
//        } else {
//            promptLinkViewController(type: type, exchange: exchange)
//        }
//    }
//
//    private func promptLinkViewController(type: ExchangeType, exchange: ExchangeApiData?) {
//        let vc = LinkExchangeViewController()
//        vc.exchangeType = type
//        vc.exchange = exchange
//        present(vc, animated: true)
//    }
//
//    private func promptActionSheetAlert(type: ExchangeType, exchange: ExchangeApiData) {
//        AlertBuilder()
//            .setStyle(.actionSheet)
//            .setButton(title: "修改") { [weak self] in
//                self?.promptLinkViewController(type: type, exchange: exchange)
//            }
//            .setButton(title: "刪除") { [weak self] in
//                self?.promptDeleteAlert(exchange: exchange)
//            }
//            .setButton(title: "取消", style: .cancel)
//            .show(self)
//    }
//
//    private func promptDeleteAlert(exchange: ExchangeApiData) {
//        AlertBuilder()
//            .setTitle("確定要刪除嗎？")
//            .setButton(title: "確定") { [weak self] in
//                self?.exchangeApiViewModel.delete(id: exchange.id)
//            }
//            .setButton(title: "取消", style: .cancel)
//            .show(self)
//    }
    
    private let statusBarSection = UIView()
    private let avatarImageView = UIImageView()
    private let infoSectionView = UIView()
    private let userNameSectionView = UIView()
    private let userNameLabel = UILabel()
    private let editButtonSectionView = UIView()
    private let editButton = OrangeButton()
    private let exchangeSectionView = UIView()
    private let scrollView = UIScrollView()
    private let scrollContainerView = UIView()
}

extension SettingViewController: ExchangeCardViewDelegate {
    
    func onTap(type: ExchangeType, exchange: ExchangeApiData?) {
        
    }
}
