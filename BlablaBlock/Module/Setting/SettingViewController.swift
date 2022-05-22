//
//  SettingViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxGesture

final class SettingViewController: BaseViewController {
    
    private weak var parentCoordinator: MainCoordinator?
    private let viewModel: SettingViewModelType
    private var cardViewList: [ExchangeCardView] = []
    private let exchageList = [
        ExchangeType.binance,
        ExchangeType.ftx
    ]
    
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
        setupBinding()
//        viewModel.inputs.viewDidLoad.accept(())
    }
    
    private func setupUI() {
        view.backgroundColor = .grayE5E5E5
        
        avatarImageView.image = "ic_profile_avatar_placeholder".image()
        avatarImageView.makeCircle(base: 74)
        avatarImageView.contentMode = .scaleAspectFit
        
        userNameLabel.text = keychainUser[.userName] ?? keychainUser[.userEmail]
        userNameLabel.font = .boldSystemFont(ofSize: 18)
        userNameLabel.textColor = .black2D2D2D
        userNameLabel.autoFontSize()
        
//        editButton.setImage("ic_button_edit".image(), for: .normal)
//        if #available(iOS 15.0, *) {
//            var configuration = UIButton.Configuration.filled()
//            configuration.imagePadding = 4
//            editButton.configuration = configuration
//        } else {
//            editButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
//        }
//        editButton.setTitle("編輯資訊", for: .normal)
        editButton.setTitle("vc_setting_sign_out".localized(), for: .normal)
        
        exchangeSectionView.backgroundColor = .white
        
        cardSectionStackView.axis = .vertical
        cardSectionStackView.spacing = 20
        
        questionSectionView.borderColor = .black2D2D2D
        questionSectionView.layer.borderWidth = 1
        questionSectionView.layer.cornerRadius = 4
        questionSectionView.layer.masksToBounds = true
        
        questionImageView.image = "ic_setting_question_mark".image()
        
        questionLabel.text = "vc_setting_faq".localized()
        questionLabel.font = .boldSystemFont(ofSize: 18)
        questionLabel.textColor = .black2D2D2D
        
        logoImageView.image = "ic_gray_logo".image()
    }
    
    private func setupLayout() {
        view.addSubview(statusBarSection)
        statusBarSection.snp.makeConstraints { make in
            make.height.equalTo(Utils.statusBarHeight)
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
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(6)
        }

        infoSectionView.addSubview(editButtonSectionView)
        editButtonSectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(userNameSectionView.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
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
        scrollView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-24)
        }

        scrollView.addSubview(scrollContainerView)
        scrollContainerView.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        scrollContainerView.addSubview(cardSectionStackView)
        cardSectionStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(24)
        }
        
        for exchage in exchageList {
            let cardView = ExchangeCardView(self, type: exchage)
            cardViewList.append(cardView)
            cardSectionStackView.addArrangedSubview(cardView)
        }
        
        scrollContainerView.addSubview(questionSectionView)
        questionSectionView.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(cardSectionStackView.snp.bottom).offset(20)
        }
        
        questionSectionView.addSubview(questionImageView)
        questionImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
        
        questionSectionView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.leading.equalTo(questionImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(24)
        }
        
        scrollContainerView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalTo(questionSectionView.snp.bottom).offset(36)
            make.bottom.equalToSuperview().offset(-36)
        }
    }
    
    private func setupBinding() {
        editButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.editButton.isEnabled = false
                self?.viewModel.inputs.onSignOut.accept(())
            })
            .disposed(by: disposeBag)
        
        questionSectionView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                Timber.i("questionSectionView")
            })
            .disposed(by: disposeBag)
        
        logoImageView.rx
            .longPressGesture()
            .when(.began)
            .subscribe(onNext: { [weak self] _ in
                self?.changeLanguage()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .exchanges
            .asDriver()
            .drive(onNext: { [weak self] exchanges in
                self?.refreshList(exchanges: exchanges)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .signOut
            .emit(onNext: { [weak self] _ in
                self?.parentCoordinator?.loguot()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .errorMessage
            .subscribe(onNext: { [weak self] msg in
                self?.editButton.isEnabled = true
                self?.promptAlert(message: msg)
            })
            .disposed(by: disposeBag)
    }
    
    func changeLanguage() {
        let current = UserDefaults.standard.string(forKey: "current_language") ?? "en"
        let new = current == "en" ? "zh-Hant" : "en"
        
        Timber.i("Set language: \(new)")

        UserDefaults.standard.set([new], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Update the language by swaping bundle
        Bundle.setLanguage(new)
        UserDefaults.standard.set(new, forKey: "current_language")
        parentCoordinator?.changeLanguage()
    }
    
    private let statusBarSection = UIView()
    private let avatarImageView = UIImageView()
    private let infoSectionView = UIView()
    private let userNameSectionView = UIView()
    private let userNameLabel = UILabel()
    private let editButtonSectionView = UIView()
    private let editButton = BlablaBlockOrangeButtonView()
    private let exchangeSectionView = UIView()
    private let scrollView = UIScrollView()
    private let scrollContainerView = UIView()
    private let cardSectionStackView = UIStackView()
    private let questionSectionView = UIView()
    private let questionImageView = UIImageView()
    private let questionLabel = UILabel()
    private let logoImageView = UIImageView()
}

extension SettingViewController {
    
    private func refreshList(exchanges: [ExchangeApiData]) {
        for card in cardViewList {
            card.exchange = exchanges.first { $0.exchange == card.type.rawValue }
        }
    }
    
    private func promptLinkView(type: ExchangeType, exchange: ExchangeApiData?) {
        let vc = LinkExchangeViewController()
        vc.viewModel = viewModel
        vc.exchangeType = type
        vc.exchange = exchange
        present(vc, animated: true)
    }

    private func promptActionSheetAlert(type: ExchangeType, exchange: ExchangeApiData) {
        AlertBuilder()
            .setStyle(.actionSheet)
            .setButton(title: "修改") { [weak self] in
                self?.promptLinkView(type: type, exchange: exchange)
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
                self?.viewModel.inputs.onDelete.accept(exchange.id)
            }
            .setButton(title: "取消", style: .cancel)
            .show(self)
    }
}

extension SettingViewController: ExchangeCardViewDelegate {
    
    func onTap(type: ExchangeType, exchange: ExchangeApiData?) {
        if let exchange = exchange {
            promptActionSheetAlert(type: type, exchange: exchange)
        } else {
            promptLinkView(type: type, exchange: exchange)
        }
    }
}
