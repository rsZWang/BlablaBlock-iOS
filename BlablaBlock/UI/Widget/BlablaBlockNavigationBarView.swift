//
//  BlablaBlockNavigationBarView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/25.
//

import UIKit
import SnapKit
import RxSwift
import RxGesture

public protocol BlablaBlockNavigationBarViewDelegate: AnyObject {
    func onBack()
}

final public class BlablaBlockNavigationBarView: UIView {
    
    private let disposeBag = DisposeBag()
    public weak var delegate: BlablaBlockNavigationBarViewDelegate?
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    convenience public init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        backImageView.image = "ic_navigation_back_arrow".image()
        
        backLabel.text = "上一頁"
        backLabel.font = .systemFont(ofSize: 14, weight: .medium)
        backLabel.textColor = .black2D2D2D_80
        
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black2D2D2D
        
        clickAreaView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.onBack()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        containerView.addSubview(backImageView)
        backImageView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(backLabel)
        backLabel.snp.makeConstraints { make in
            make.leading.equalTo(backImageView.snp.trailing).offset(9)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        containerView.addSubview(clickAreaView)
        clickAreaView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(backLabel)
        }
    }
    
    private let containerView = UIView()
    private let backImageView = UIImageView()
    private let backLabel = UILabel()
    private let titleLabel = UILabel()
    private let clickAreaView = UIView()
}
