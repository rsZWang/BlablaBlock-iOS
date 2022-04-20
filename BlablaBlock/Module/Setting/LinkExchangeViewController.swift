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
    
    @Injected var exchangeApiViewModel: ExchangeApiViewModel
    
    var exchangeType: ExchangeType!
    var exchange: ExchangeApiData?
    
    private let containerHeight = UIScreen.main.bounds.height * 0.4
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    private let imageView = UIImageView()
    private let closeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.textColor = .gray
        label.text = "x"
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    private let apiSecretInputView: NormalInputView = {
        let inputView = NormalInputView()
        inputView.placeholder = "Secret Key"
        return inputView
    }()
    private let apiKeyInputView: NormalInputView = {
        let inputView = NormalInputView()
        inputView.placeholder = "API Key"
        return inputView
    }()
    private let submitButton: ColorButton = {
        let button = ColorButton()
        button.rounded = true
        button.normalBgColor = .black
        button.disabledBgColor = .darkGray
        button.highlightedBgColor = .darkGray
        button.normalTitleColor = .white
        button.disabledTitleColor = .white
        button.highlightedTitleColor = .white
        button.setTitle("提交", for: .normal)
        return button
    }()
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
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
        setupUI()
        bindView()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 6)
        imageView.roundCorners(corners: .allCorners, radius: 4)
//        closeLabel.makeCircle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slide(up: true)
    }
    
    private func setupUI() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.height.equalTo(containerHeight)
            make.bottom.equalTo(view).offset(containerHeight)
        }
        
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
        
        let topSectionHeight = containerHeight*0.2
        let topSectionView = UIView()
        topSectionView.backgroundColor = UIColor(named: "gray_tab_bar")
        containerView.addSubview(topSectionView)
        topSectionView.snp.makeConstraints { make in
            make.left.top.right.equalTo(containerView)
            make.height.equalTo(topSectionHeight)
        }
        
        let imageViewHeight = topSectionHeight*0.5
        imageView.image = UIImage(named: exchangeIcon)
        imageView.backgroundColor = .white
        topSectionView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalTo(topSectionView).offset(15)
            make.centerY.equalTo(topSectionView)
            make.width.height.equalTo(imageViewHeight)
        }
        
        topSectionView.addSubview(closeLabel)
        closeLabel.snp.makeConstraints { make in
            make.right.equalTo(topSectionView).offset(-15)
            make.centerY.equalTo(topSectionView)
            make.width.equalTo(closeLabel.snp.height)
        }
        
        let textSectionView = UIView()
        topSectionView.addSubview(textSectionView)
        textSectionView.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalTo(closeLabel.snp.left).offset(-10)
            make.top.bottom.equalTo(imageView)
        }
        
        let exchangeNameLabel = UILabel()
        exchangeNameLabel.text = exchangeName
        exchangeNameLabel.autoResize(font: .boldSystemFont(ofSize: 16))
        textSectionView.addSubview(exchangeNameLabel)
        exchangeNameLabel.snp.makeConstraints { make in
            make.left.top.right.equalTo(textSectionView)
            make.height.equalTo(textSectionView.snp.height).multipliedBy(0.6)
        }
        
        let explanationLabel = UILabel()
        explanationLabel.text = "如何使用 >"
        explanationLabel.textColor = .systemBlue
        explanationLabel.autoResize(font: .systemFont(ofSize: 12))
        textSectionView.addSubview(explanationLabel)
        explanationLabel.snp.makeConstraints { make in
            make.left.equalTo(textSectionView.snp.left)
            make.height.equalTo(textSectionView.snp.height).multipliedBy(0.4)
            make.top.equalTo(exchangeNameLabel.snp.bottom)
            make.bottom.equalTo(textSectionView.snp.bottom)
        }
        
        let bottomSectionView = UIView()
        containerView.addSubview(bottomSectionView)
        bottomSectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(containerView)
            make.top.equalTo(topSectionView.snp.bottom)
        }
        
        let inputSectionView = UIView()
        bottomSectionView.addSubview(inputSectionView)
        inputSectionView.snp.makeConstraints { make in
            make.width.equalTo(bottomSectionView).multipliedBy(0.9)
            make.centerX.equalTo(bottomSectionView)
            make.height.equalTo(bottomSectionView).multipliedBy(0.7)
            make.centerY.equalTo(bottomSectionView)
        }

        inputSectionView.addSubview(apiKeyInputView)
        apiKeyInputView.snp.makeConstraints { make in
            make.left.top.right.equalTo(inputSectionView)
        }
        
        let spearatorView1 = UIView()
        inputSectionView.addSubview(spearatorView1)
        spearatorView1.snp.makeConstraints { make in
            make.height.equalTo(inputSectionView).multipliedBy(0.15)
            make.left.right.equalTo(inputSectionView)
            make.top.equalTo(apiKeyInputView.snp.bottom)
        }

        
        inputSectionView.addSubview(apiSecretInputView)
        apiSecretInputView.snp.makeConstraints { make in
            make.left.right.equalTo(inputSectionView)
            make.top.equalTo(spearatorView1.snp.bottom)
        }
        
        let separatorView2 = UIView()
        inputSectionView.addSubview(separatorView2)
        separatorView2.snp.makeConstraints { make in
            make.height.equalTo(inputSectionView).multipliedBy(0.2)
            make.left.right.equalTo(inputSectionView)
            make.top.equalTo(apiSecretInputView.snp.bottom)
        }
        
        if let exchange = exchange {
            apiKeyInputView.textField.text = exchange.apiKey
            apiSecretInputView.textField.text = exchange.apiSecret
        }
        
        inputSectionView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.right.equalTo(inputSectionView)
            make.top.equalTo(separatorView2.snp.bottom)
            make.height.equalTo(40)
        }
    }
    
    private func bindView() {
        closeLabel.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss()
            })
            .disposed(by: disposeBag)
        
        submitButton.rx
            .tap
            .subscribe(onNext: { [unowned self] in
                let apiKey = apiKeyInputView.textField.text ?? ""
                let apiSecret = apiSecretInputView.textField.text ?? ""
                if let exchange = exchange {
                    exchangeApiViewModel.edit(
                        id: exchange.id,
                        exchange: exchangeType!.rawValue,
                        apiKey: apiKey,
                        apiSecret: apiSecret,
                        subaccount: ""
                    )
                } else {
                    exchangeApiViewModel.create(
                        exchange: exchangeType!.rawValue,
                        apiKey: apiKey,
                        apiSecret: apiSecret
                    )
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        exchangeApiViewModel.completeObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] completed in
                if completed {
                    self?.dismiss()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func slide(up: Bool) {
        containerView.snp.updateConstraints { make in
            make.bottom.equalTo(view).offset(up ? 0 : containerHeight)
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