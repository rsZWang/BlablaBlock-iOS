//
//  SignInModeButtonView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/28.
//

import UIKit
import RxSwift

public protocol SignInModeButtonViewDelegate: AnyObject {
    func signModeButtonView(_ view: SignInModeButtonView, mode: SignInModeButtonView.Mode)
}

final public class SignInModeButtonView: UIView {
    
    private let disposeBag = DisposeBag()
    
    public enum Mode {
        case signIn
        case signUp
    }
    
    weak var delegate: SignInModeButtonViewDelegate?
    var mode: Mode! {
        didSet {
            setupMode()
        }
    }
    var isSelected = false {
        didSet {
            setStatus()
        }
    }
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        containerView.axis = .vertical
        containerView.spacing = 4
        
        titleLabel.textAlignment = .center
        
        self.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if !self.isSelected {
                    self.delegate?.signModeButtonView(self, mode: self.mode)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupMode() {
        if mode == .signIn {
            titleLabel.text = "登入"
        } else {
            titleLabel.text = "註冊"
        }
    }
    
    private func setStatus() {
        if isSelected {
            titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
            titleLabel.textColor = .black2D2D2D
            
            indicatorView.backgroundColor = .black2D2D2D
            indicatorView.snp.updateConstraints { make in
                make.height.equalTo(4)
            }
        } else {
            titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
            titleLabel.textColor = .gray2D2D2D_40
            
            indicatorView.backgroundColor = .gray2D2D2D_40
            indicatorView.snp.updateConstraints { make in
                make.height.equalTo(1)
            }
        }
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        containerView.addArrangedSubview(titleLabel)
        containerView.addArrangedSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { make in
            make.height.equalTo(4)
        }
    }
    
    private let containerView = UIStackView()
    private let titleLabel = UILabel()
    private let indicatorView = UIView()
}
