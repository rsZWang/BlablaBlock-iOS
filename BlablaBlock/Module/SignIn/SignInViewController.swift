//
//  SignInViewController.swift
//  BlablaBlock
//
//  Created by yhw on 2021/10/20.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxGesture
import Toast_Swift

final public class SignInViewController: BaseViewController {
    
    public weak var parentCoordinator: MainCoordinator?
    private let viewModel: SignInViewModelType
    
    init(viewModel: SignInViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userNameTextField.text = nil
        emailTextField.text = nil
        passwordTextField.text = nil
        passwordConfirmTextField.text = nil
        
        signInModeButtonView.isSelected = true
        signUpModeButtonView.isSelected = false
        
        privacyCancelButton.isEnabled = true
        privacyConfirmButton.isEnabled = true
        privacyContainerView.isHidden = true
        
        #if DEBUG
        emailTextField.text = "rex@huijun.org"
//        emailTextField.text = "cool890104@gmail.com"
        passwordTextField.text = "123456"
        #endif
        
        signInMode.accept(true)
        
        bindNextButton()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        bgView.backgroundColor = .black181C23_70
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        
        logoImageView.image = "ic_sign_in_logo".image()
        
        sloganLabel.text = "Connect everything about crypto trading."
        sloganLabel.font = .systemFont(ofSize: 12, weight: .medium)
        sloganLabel.textAlignment = .center
        
        signInModeButtonView.delegate = self
        signInModeButtonView.mode = .signIn
        
        signUpModeButtonView.delegate = self
        signUpModeButtonView.mode = .signUp
        
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = 24
        
        userNameInputView.isHidden = true
        userNameTextField.placeholder = "vc_sign_in_user_name".localized()
        userNameTextField.delegate = self
        userNameTextField.tag = 0
        userNameTextField.returnKeyType = .next
        
        emailTextField.placeholder = "vc_sign_in_email".localized()
        emailTextField.delegate = self
        emailTextField.tag = 1
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        
        passwordTextField.placeholder = "vc_sign_in_password".localized()
        passwordTextField.delegate = self
        passwordTextField.tag = 2
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .done
        
        passwordConfirmInputView.isHidden = true
        passwordConfirmTextField.placeholder = "vc_sign_in_password_confirm".localized()
        passwordConfirmTextField.delegate = self
        passwordConfirmTextField.tag = 3
        passwordConfirmTextField.isSecureTextEntry = true
        passwordConfirmTextField.returnKeyType = .done
        
        forgetPasswordBtn.setTitle("忘記密碼", for: .normal)
        forgetPasswordBtn.titleLabel?.font = .systemFont(ofSize: 12)
        
        nextButton.setTitle("vc_sign_in_next_step".localized(), for: .normal)
        nextButton.font = .boldSystemFont(ofSize: 16)
        
        privacyTitleLabel.text = "服務條款"
        privacyTitleLabel.textColor = .black2D2D2D
        privacyTitleLabel.font = .boldSystemFont(ofSize: 16)
        
        privacyTextView.isEditable = false
        if let path = Bundle.main.path(forResource: "privacy_agreement", ofType: "txt") {
            do {
                let text = try String(contentsOfFile: path, encoding: .utf8)
                privacyTextView.text = text
            } catch let error {
                // Handle error here
                Timber.e("Error: \(error.localizedDescription)")
            }
        }
        
        privacyContainerView.backgroundColor = .white
        privacyContainerView.layer.cornerRadius = 10
        
        privacyCancelButton.setImage("ic_navigation_back_arrow".image(),for: .normal)
        
        privacyConfirmButton.setTitle("同意並繼續", for: .normal)
        privacyConfirmButton.font = .boldSystemFont(ofSize: 16)
    }
    
    private func setupLayout() {
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.trailing.equalToSuperview().offset(-34)
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(containerPaddingView)
        containerPaddingView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 32, left: 24, bottom: 32, right: 24))
        }
        
        containerPaddingView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        containerPaddingView.addSubview(sloganLabel)
        sloganLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
        }
        
        containerPaddingView.addSubview(modeButtonSectionView)
        modeButtonSectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(sloganLabel.snp.bottom).offset(24)
        }
        
        modeButtonSectionView.addSubview(signInModeButtonView)
        signInModeButtonView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.leading.top.bottom.equalToSuperview()
        }
        
        modeButtonSectionView.addSubview(signUpModeButtonView)
        signUpModeButtonView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.top.trailing.bottom.equalToSuperview()
        }
        
        containerPaddingView.addSubview(textFieldStackView)
        textFieldStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(signUpModeButtonView.snp.bottom).offset(32)
        }
        
        textFieldStackView.addArrangedSubview(userNameInputView)
        textFieldStackView.addArrangedSubview(emailInputView)
        textFieldStackView.addArrangedSubview(passwordInputView)
        textFieldStackView.addArrangedSubview(passwordConfirmInputView)
        
        containerPaddingView.addSubview(forgetPasswordBtn)
        forgetPasswordBtn.snp.makeConstraints { make in
            make.top.equalTo(textFieldStackView.snp.bottom).offset(-2)
            make.trailing.equalTo(textFieldStackView.snp.trailing)
        }
        
        containerPaddingView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(textFieldStackView.snp.bottom).offset(40)
        }
        
        view.addSubview(privacyContainerView)
        privacyContainerView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        
        privacyContainerView.addSubview(privacyTitleLabel)
        privacyTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        privacyContainerView.addSubview(privacyCancelButton)
        privacyCancelButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
        }
        
        privacyContainerView.addSubview(privacyConfirmButton)
        privacyConfirmButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-24)
            make.leading.equalTo(privacyCancelButton.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        privacyContainerView.addSubview(privacyTextView)
        privacyTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(privacyTitleLabel.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(privacyConfirmButton.snp.top).offset(-12)
        }
    }
    
    private func setupBinding() {
        forgetPasswordBtn.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.promptForgetPasswordAlert()
            })
            .disposed(by: disposeBag)
        
        nextButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.signInMode.value {
                    self.nextButton.isEnabled = false
                    self.viewModel
                        .inputs
                        .signIn
                        .accept((self.emailTextField.text!, self.passwordTextField.text!))
                } else {
                    self.privacyContainerView.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        privacyCancelButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.privacyContainerView.isHidden = true
            })
            .disposed(by: disposeBag)
        
        privacyConfirmButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.privacyCancelButton.isEnabled = false
                self.privacyConfirmButton.isEnabled = false
                self.viewModel
                    .inputs
                    .signUp
                    .accept((
                        self.userNameTextField.text!,
                        self.emailTextField.text!,
                        self.passwordTextField.text!
                    ))
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .uiEvent
            .emit(onNext: { [weak self] uiEvent in
                self?.handleUiEvent(uiEvent)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .errorMessage
            .asSignal()
            .emit(onNext: { [weak self] msg in
                self?.nextButton.isEnabled = true
                self?.privacyCancelButton.isEnabled = true
                self?.privacyConfirmButton.isEnabled = true
                self?.promptAlert(message: msg)
            })
            .disposed(by: disposeBag)
    }
    
    private let bgView = UIView()
    private let containerView = UIView()
    private let containerPaddingView = UIView()
    private let logoImageView = UIImageView()
    private let sloganLabel = UILabel()
    private let modeButtonSectionView = UIView()
    private let modeButtonSeparatorView = UIView()
    private let signInModeButtonView = SignInModeButtonView()
    private let signUpModeButtonView = SignInModeButtonView()
    private let textFieldStackView = UIStackView()
    private let userNameInputView = NormalInputView()
    private let emailInputView = NormalInputView()
    private let passwordInputView = NormalInputView()
    private let passwordConfirmInputView = NormalInputView()
    private let forgetPasswordBtn = UIButton(type: .system)
    private let nextButton = BlablaBlockOrangeButtonView()
    
    private let privacyContainerView = UIView()
    private let privacyTitleLabel = UILabel()
    private let privacyTextView = UITextView()
    private let privacyCancelButton = BlablaBlockOrangeButtonView()
    private let privacyConfirmButton = BlablaBlockOrangeButtonView()
    
    private var userNameTextField: UITextField { userNameInputView.textField }
    private var emailTextField: UITextField { emailInputView.textField }
    private var passwordTextField: UITextField { passwordInputView.textField }
    private var passwordConfirmTextField: UITextField { passwordConfirmInputView.textField }
    private var forgetPasswordInputAlert: InputAlertBuilder? = nil
    private let signInMode = BehaviorRelay<Bool>(value: true)
    private var resetPasswordInputAlert: InputAlertBuilder? = nil
}

extension SignInViewController: SignInModeButtonViewDelegate {
    
    public func signModeButtonView(_ view: SignInModeButtonView, mode: SignInModeButtonView.Mode) {
        if mode == .signIn {
            signInModeButtonView.isSelected = true
            signUpModeButtonView.isSelected = false
            passwordTextField.returnKeyType = .done
            passwordConfirmTextField.tag = -1
            userNameInputView.fadeIn { [weak self] in
                self?.userNameInputView.isHidden = true
            }
            passwordConfirmInputView.fadeIn { [weak self] in
                self?.passwordConfirmInputView.isHidden = true
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        self?.textFieldStackView.layoutIfNeeded()
                        self?.containerView.layoutIfNeeded()
                    }
                )
            }
            signInMode.accept(true)
        } else {
            signInModeButtonView.isSelected = false
            signUpModeButtonView.isSelected = true
            userNameInputView.isHidden = false
            passwordConfirmInputView.isHidden = false
            passwordTextField.returnKeyType = .next
            passwordConfirmTextField.tag = 3
            UIView.animate(
                withDuration: 0.2,
                animations: { [weak self] in
                    self?.textFieldStackView.layoutIfNeeded()
                    self?.containerView.layoutIfNeeded()
                },
                completion: { [weak self] completed in
                    if completed {
                        self?.userNameInputView.fadeOut()
                        self?.passwordConfirmInputView.fadeOut()
                    }
                }
            )
            signInMode.accept(false)
       }
    }
}

extension SignInViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = view?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

public extension SignInViewController {
    
    private func bindNextButton() {
        let userNameValid = userNameTextField.rx
            .text.orEmpty
            .map { !$0.isEmpty }
            .share(replay: 1)

        let emailValid = emailTextField.rx
            .text.orEmpty
            .map { $0.isEmail }
            .share(replay: 1)

        let passwordValid = passwordTextField.rx
            .text.orEmpty
            .map { $0.isValidPassword }
            .share(replay: 1)

        let passwordConfirmValid = passwordConfirmTextField.rx
            .text.orEmpty
            .map { [weak self] in $0 == self?.passwordTextField.text }
            .share(replay: 1)

        Observable.combineLatest(
            signInMode,
            userNameValid,
            emailValid,
            passwordValid,
            passwordConfirmValid,
            resultSelector: { ($0 || ($1 && $4)) && $2 && $3 }
        )
        .bind(to: nextButton.rx.isEnabled)
        .disposed(by: shortLifecycleOwner)
    }
    
    private func handleUiEvent(_ event: SignInUiEvent) {
        switch event {
        case .success:
            parentCoordinator?.main()
            
        case .resetPassword:
            AlertBuilder()
                .setTitle("重設密碼的信件已寄出")
                .setMessage("快去信箱收信喔！")
                .setOkButton()
                .show(self)
            
        case .passwordReset:
            view.makeToast("重設成功🥳\n請再嘗試登入", duration: 2.0)
        }
    }
    
    private func promptForgetPasswordAlert() {
        if forgetPasswordInputAlert == nil {
            forgetPasswordInputAlert = InputAlertBuilder()
                .setTitle("忘記密碼")
                .setMessage("輸入註冊時的信箱，我們將寄送驗證信件給您")
                .addTextField(tag: 1, placeholder: "電子信箱")
                .setConfirmButton(title: "確定") { [weak self] texts in
                    if let email = texts[1], email.isEmail {
                        self?.viewModel
                            .inputs
                            .forgetPassword
                            .accept(email)
                    } else {
                        self?.promptAlert(message: "電子信箱似乎輸入錯誤@@")
                    }
                }.build()
        }
        forgetPasswordInputAlert?.show(self)
    }
    
    func resetPassword(token: String) {
        if resetPasswordInputAlert == nil {
            resetPasswordInputAlert = InputAlertBuilder()
                .setTitle("重設密碼")
                .setMessage("")
                .addTextField(tag: 1, placeholder: "新密碼")
                .setConfirmButton(title: "送出") { [weak self] result in
                    if let password = result[1] {
                        self?.viewModel
                            .inputs
                            .resetPassword
                            .accept((token, password))
                    }
                }
                .build()
        }
        resetPasswordInputAlert?.show(self)
    }
}
