//
//  LinkExchangeViewController.swift
//  BlablaBlock
//
//  Created by Harry@rooit on 2021/11/6.
//

import UIKit
import Resolver
import SnapKit
import RxSwift
import RxGesture

final class LinkExchangeViewController: BaseViewController {
    
    weak var viewModel: SettingViewModelType!
    var exchangeType: ExchangeType!
    var exchange: ExchangeApiData?
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }

    deinit {
        Timber.i("\(type(of: self)) deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slide(up: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .black181C23_70
        
        containerView.backgroundColor = .white
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        
        let exchangeIcon: String
        let exchangeName: String
        switch exchangeType! {
        case .binance:
            exchangeIcon = "ic_setting_binance"
            exchangeName = "連結幣安"
        case .ftx:
            exchangeIcon = "ic_setting_ftx"
            exchangeName = "連結FTX"
        default:
            exchangeIcon = ""
            exchangeName = "UNKNOWN"
        }
       
        imageView.image = exchangeIcon.image()
        
        titleLabel.text = exchangeName
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        closeImageView.image = "ic_link_exchange_closse".image()
        
        howToUseLabel.text = "如何使用 >"
        howToUseLabel.textColor = .orangeFF9960
        howToUseLabel.font = .boldSystemFont(ofSize: 13)
        howToUseLabel.textAlignment = .center
        
        if let exchange = exchange {
            apiKeyInputView.textField.text = exchange.apiKey
            apiSecretInputView.textField.text = exchange.apiSecret
        } else {
            apiKeyInputView.placeholder = "API Key"
            apiSecretInputView.placeholder = "Secret Key"
        }
        
        submitButton.setTitle("提交", for: .normal)
    }

    private func setupLayout() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.height.equalTo(260)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(260)
        }
        
        containerView.addSubview(paddingContainerView)
        paddingContainerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 20, left: 24, bottom: 16, right: 24))
        }
        
        paddingContainerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leading.top.equalToSuperview()
        }
        
        paddingContainerView.addSubview(closeImageView)
        closeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.trailing.equalToSuperview().offset(-2)
            make.centerY.equalTo(imageView)
        }
        
        paddingContainerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.top.bottom.equalTo(imageView)
            make.trailing.equalTo(closeImageView.snp.leading).offset(-12)
        }
        
        paddingContainerView.addSubview(howToUseLabel)
        howToUseLabel.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.leading.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
        }
        
        paddingContainerView.addSubview(apiKeyInputView)
        apiKeyInputView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(howToUseLabel.snp.bottom).offset(24)
        }
        
        paddingContainerView.addSubview(apiSecretInputView)
        apiSecretInputView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(apiKeyInputView.snp.bottom).offset(24)
        }
        
        paddingContainerView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(apiSecretInputView.snp.bottom).offset(32)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        view.rx
            .tapGesture(configuration: { _, delegate in
                delegate.touchReceptionPolicy = .custom { [unowned self] _, touch in
                    touch.view == view
                }
            })
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss()
            })
            .disposed(by: disposeBag)
        
        closeImageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss()
            })
            .disposed(by: disposeBag)
        
        submitButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if let apiKey = self.apiKeyInputView.textField.text, let apiSecret = self.apiSecretInputView.textField.text {
                    if let exchange = self.exchange {
                        self.viewModel.inputs
                            .onEdit
                            .accept((exchange.id, self.exchangeType!, apiKey, apiSecret))
                    } else {
                        self.viewModel.inputs
                            .onCreate
                            .accept((self.exchangeType!, apiKey, apiSecret))
                    }
                    self.dismiss()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private let containerView = UIView()
    private let paddingContainerView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let closeImageView = UIImageView()
    private let howToUseLabel = UILabel()
    private let apiKeyInputView = NormalInputView()
    private let apiSecretInputView = NormalInputView()
    private let submitButton = BlablaBlockOrangeButtonView()
}

extension LinkExchangeViewController {
    
    private func slide(up: Bool) {
        containerView.snp.updateConstraints { make in
            make.bottom.equalTo(view).offset(up ? 0 : 260)
        }
        UIView.animate(
            withDuration: 0.1,
            animations: { [weak self] in
                self?.view.layoutIfNeeded()
            },
            completion: { [weak self] completed in
                if completed && !up {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        )
    }
    
    private func dismiss() {
        slide(up: false)
    }
}
