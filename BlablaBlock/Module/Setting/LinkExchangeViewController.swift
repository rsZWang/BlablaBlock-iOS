//
//  LinkExchangeViewController.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/6.
//

import UIKit
import SnapKit
import RxSwift
import RxGesture
import SafariServices

final public class LinkExchangeViewController: BaseViewController {
    
    public weak var viewModel: SettingViewModelType!
    public var exchangeType: FilterExchange!
    public var exchange: ExchangeApiData?
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }

    deinit {
        Timber.i("\(type(of: self)) deinit")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupBinding()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
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
        case .Binance:
            exchangeIcon = "ic_setting_binance"
            exchangeName = "vc_setting_connect".localized(arguments: "幣安")
        case .FTX:
            exchangeIcon = "ic_setting_ftx"
            exchangeName = "vc_setting_connect".localized(arguments: "FTX")
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
            secretKeyInputView.textField.text = exchange.secretKey
        } else {
            apiKeyInputView.placeholder = "API Key"
            secretKeyInputView.placeholder = "Secret Key"
        }
        
        submitButton.setTitle("提交", for: .normal)
    }

    private func setupLayout() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(height)
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
        
        paddingContainerView.addSubview(secretKeyInputView)
        secretKeyInputView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(apiKeyInputView.snp.bottom).offset(24)
        }
        
        paddingContainerView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(secretKeyInputView.snp.bottom).offset(32)
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
        
        howToUseLabel.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let safariVC = SFSafariViewController(url: URL(string: "https://medium.com/blablablock2021/24ff8fc81770")!)
                self?.present(safariVC, animated: true, completion: nil)
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
                if let apiKey = self?.apiKeyInputView.textField.text,
                   let apiSecret = self?.secretKeyInputView.textField.text,
                   let exchangeType = self?.exchangeType
                {
                    self?.viewModel.inputs
                        .onCreate
                        .accept((exchangeType, apiKey, apiSecret))
                    self?.dismiss()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private let height = 260 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
    private let containerView = UIView()
    private let paddingContainerView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let closeImageView = UIImageView()
    private let howToUseLabel = UILabel()
    private let apiKeyInputView = NormalInputView()
    private let secretKeyInputView = NormalInputView()
    private let submitButton = BlablaBlockOrangeButtonView()
}

public extension LinkExchangeViewController {
    
    private func slide(up: Bool) {
        containerView.snp.updateConstraints { make in
            make.bottom.equalTo(view).offset(up ? 0 : height)
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
