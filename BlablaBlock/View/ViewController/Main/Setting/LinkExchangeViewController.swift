//
//  LinkExchangeViewController.swift
//  BlablaBlock
//
//  Created by Harry@rooit on 2021/11/6.
//

import UIKit
import SnapKit
import RxSwift
import RxGesture

class LinkExchangeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let containerHeight = UIScreen.main.bounds.height * 0.4
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
        setContainerView()
        let topSectionView = setTopSection()
        setBottomSection(topSectionView: topSectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slide(up: true)
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 6)
        imageView.roundCorners(corners: .allCorners, radius: 4)
        closeLabel.makeCircle()
    }
    
    private func setContainerView() {
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.height.equalTo(containerHeight)
            make.bottom.equalTo(view).offset(containerHeight)
        }
    }
    
    private func setTopSection() -> UIView {
        let topSectionHeight = containerHeight*0.2
        let topSectionView = UIView()
        topSectionView.backgroundColor = UIColor(named: "gray_tab_bar")
        containerView.addSubview(topSectionView)
        topSectionView.snp.makeConstraints { make in
            make.left.top.right.equalTo(containerView)
            make.height.equalTo(topSectionHeight)
        }
        
        let imageViewHeight = topSectionHeight*0.5
        imageView.image = UIImage(named: "ic_setting_binance")
        imageView.backgroundColor = .white
        topSectionView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalTo(topSectionView).offset(15)
            make.centerY.equalTo(topSectionView)
            make.width.height.equalTo(imageViewHeight)
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
            make.right.equalTo(closeLabel.snp.left).offset(-10)
            make.top.bottom.equalTo(imageView)
        }
        
        let exchangeNameLabel = UILabel()
        exchangeNameLabel.text = "連結XX帳戶"
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
        
        closeLabel.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss()
            })
            .disposed(by: disposeBag)
        
        return topSectionView
    }
    
    private func setBottomSection(topSectionView: UIView) {
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

        let apiKeyInputView = NormalInputView()
        apiKeyInputView.placeholder = "API Key"
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

        let secretKeyInputView = NormalInputView()
        secretKeyInputView.placeholder = "Secret Key"
        inputSectionView.addSubview(secretKeyInputView)
        secretKeyInputView.snp.makeConstraints { make in
            make.left.right.equalTo(inputSectionView)
            make.top.equalTo(spearatorView1.snp.bottom)
        }
        
        let separatorView2 = UIView()
        inputSectionView.addSubview(separatorView2)
        separatorView2.snp.makeConstraints { make in
            make.height.equalTo(inputSectionView).multipliedBy(0.2)
            make.left.right.equalTo(inputSectionView)
            make.top.equalTo(secretKeyInputView.snp.bottom)
        }
        
        let submitButton = ColorButton()
        submitButton.rounded = true
        submitButton.normalBgColor = .black
        submitButton.setTitle("提交", for: .normal)
        inputSectionView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.right.equalTo(inputSectionView)
            make.top.equalTo(separatorView2.snp.bottom)
            make.height.equalTo(40)
        }
    }
    
    private func slide(up: Bool) {
        containerView.snp.updateConstraints { make in
            make.bottom.equalTo(view).offset(up ? 0 : containerHeight)
        }
        UIView.animate(
            withDuration: 0.1,
            animations: { [unowned self] in
                view.layoutIfNeeded()
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
