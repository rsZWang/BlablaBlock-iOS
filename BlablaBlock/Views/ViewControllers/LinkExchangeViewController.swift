//
//  LinkExchangeViewController.swift
//  BlablaBlock
//
//  Created by Harry@rooit on 2021/11/6.
//

import UIKit
import SnapKit

class LinkExchangeViewController: UIViewController {
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let closeLabel = UILabel()
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let containerHeight = UIScreen.main.bounds.height * 0.4
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(containerHeight)
            make.bottom.equalTo(view).offset(containerHeight)
        }
        
        let topSectionHeight = containerHeight*0.2
        let topSectionView = UIView()
        topSectionView.backgroundColor = UIColor(named: "gray_tab_bar")
        containerView.addSubview(topSectionView)
        topSectionView.snp.makeConstraints { make in
            make.left.equalTo(containerView)
            make.top.equalTo(containerView)
            make.right.equalTo(containerView)
            make.height.equalTo(topSectionHeight)
        }
        
        let imageViewHeight = topSectionHeight*0.5
        imageView.image = UIImage(named: "ic_setting_binance")
        imageView.backgroundColor = .white
        topSectionView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalTo(topSectionView).offset(15)
            make.centerY.equalTo(topSectionView)
            make.width.equalTo(imageViewHeight)
            make.height.equalTo(imageViewHeight)
        }
        
        closeLabel.backgroundColor = .lightGray
        closeLabel.textColor = .gray
        closeLabel.text = "x"
        closeLabel.font = .boldSystemFont(ofSize: 16)
        closeLabel.textAlignment = .center
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
            make.top.equalTo(imageView)
            make.right.equalTo(closeLabel.snp.left).offset(-10)
            make.bottom.equalTo(imageView)
        }
        
        let exchangeNameLabel = UILabel()
        exchangeNameLabel.text = "連結XX帳戶"
        exchangeNameLabel.font = .boldSystemFont(ofSize: 16)
        exchangeNameLabel.numberOfLines = 0
        exchangeNameLabel.minimumScaleFactor = 0.5
        exchangeNameLabel.adjustsFontSizeToFitWidth = true
        exchangeNameLabel.lineBreakMode = .byClipping
        textSectionView.addSubview(exchangeNameLabel)
        exchangeNameLabel.snp.makeConstraints { make in
            make.left.equalTo(textSectionView)
            make.top.equalTo(textSectionView)
            make.right.equalTo(textSectionView)
            make.height.equalTo(textSectionView.snp.height).multipliedBy(0.6)
        }
        
        let explanationLabel = UILabel()
        explanationLabel.text = "如何使用 >"
        explanationLabel.textColor = .systemBlue
        explanationLabel.font = .systemFont(ofSize: 12)
        explanationLabel.numberOfLines = 0
        explanationLabel.minimumScaleFactor = 0.5
        explanationLabel.adjustsFontSizeToFitWidth = true
        explanationLabel.lineBreakMode = .byClipping
        textSectionView.addSubview(explanationLabel)
        explanationLabel.snp.makeConstraints { make in
            make.left.equalTo(textSectionView.snp.left)
            make.height.equalTo(textSectionView.snp.height).multipliedBy(0.4)
            make.top.equalTo(exchangeNameLabel.snp.bottom)
            make.bottom.equalTo(textSectionView.snp.bottom)
        }
        
        let inputSectionView = UIView()
        containerView.addSubview(inputSectionView)
        inputSectionView.snp.makeConstraints { make in
            make.width.equalTo(containerView).multipliedBy(0.8)
            make.centerX.equalTo(containerView)
            make.height.equalTo(containerView).multipliedBy(0.6)
            make.top.equalTo(<#T##other: ConstraintRelatableTarget##ConstraintRelatableTarget#>)
        }
        
        let apiKeyInputField = InputTextField()
        apiKeyInputField.placeholder = "API Key"
        inputSectionView.addSubview(apiKeyInputField)
        apiKeyInputField.snp.makeConstraints { make in
            make.left.top.right.equalTo(inputSectionView)
        }
        
        let secretKeyInputField = InputTextField()
        secretKeyInputField.placeholder = "Secret Key"
        inputSectionView.addSubview(secretKeyInputField)
        secretKeyInputField.snp.makeConstraints { make in
            make.left.right.equalTo(inputSectionView)
            make.top.equalTo(apiKeyInputField.snp.bottom)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        imageView.roundCorners(corners: .allCorners, radius: 4)
        closeLabel.makeCircle()
        
        containerView.snp.updateConstraints { make in
            make.bottom.equalTo(view).offset(0)
        }
        UIView.animate(
            withDuration: 0.1,
            animations: { [unowned self] in
                view.layoutIfNeeded()
            }
        )
    }
    
}
