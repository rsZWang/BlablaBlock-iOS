//
//  ExploreUserTableViewCell.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/3.
//

import UIKit
import RxSwift

final class ExploreUserTableViewCell: UITableViewCell {
    
    static let identifier = "ExploreUserTableViewCell"
    
    private var disposeBag = DisposeBag()
    weak var viewModel: ExploreUserViewModelType?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bind(_ data: UserApiData) {
        userNameLabel.text = data.name ?? " "
        totalAssetLabel.text = "$\(data.totalValue.toPrettyPrecisedString()) USDT"
        followButton.isSelected = data.isFollow
        roiLabel.text = "\(data.roi?.toPrettyPrecisedString() ?? "")％"
        annualRoiLabel.text = "\(data.roiAnnual?.toPrettyPrecisedString() ?? "")％"
        mDDLabel.text = "\(data.mdd?.toPrettyPrecisedString() ?? "")％"
        winRateLabel.text = "\(data.dailyWinRate?.toPrettyPrecisedString() ?? "")％"
        sharpRatioLabel.text = "\(data.sharpeRatio?.toPrettyPrecisedString() ?? "")"
        
        followButton.rx
            .tapGesture()
            .when(.recognized)
            .map { _ in data.userId }
            .bind(to: viewModel!.inputs.followBtnTap)
//            .subscribe(onNext: { [weak self] _ in
//                Timber.i("followButton followButton")
//                self?.viewModel?.inputs.followBtnTap.accept(data.userId)
//            })
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        contentView.backgroundColor = .grayE5E5E5
    }
    
    private func setupLayout() {
        contentView.addSubview(bgBottomView)
        bgBottomView.addSubview(bgView)
        bgView.addSubview(contentMarginView)
        contentMarginView.addSubview(avatarImageView)
        contentMarginView.addSubview(followButton)
        contentMarginView.addSubview(totalAssetLabel)
        contentMarginView.addSubview(userNameLabel)
        contentMarginView.addSubview(bottomSectionView)
        
        bgBottomView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 24, bottom: 10, right: 24))
        }
        
        bgView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(bgBottomView.snp.bottom).offset(-3)
        }
    
        contentMarginView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.leading.top.equalToSuperview()
        }
        
        followButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(22)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(avatarImageView)
        }
        
        totalAssetLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.top.equalTo(followButton)
            make.trailing.equalTo(followButton.snp.leading).offset(4)
            make.bottom.equalTo(followButton)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.bottom.equalTo(followButton.snp.top).offset(-4)
        }
        
        bottomSectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
        
        bottomSectionView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        bottomSectionView.addSubview(leftSectionView)
        leftSectionView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(separatorView.snp.leading).offset(-8)
        }
        
        bottomSectionView.addSubview(rightSectionView)
        rightSectionView.snp.makeConstraints { make in
            make.leading.equalTo(separatorView.snp.trailing).offset(8)
            make.top.trailing.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        
        leftSectionView.addArrangedSubview(roiView)
        roiView.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        roiView.addSubview(roiTitleLabel)
        roiTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        roiView.addSubview(roiLabel)
        roiLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(roiTitleLabel.snp.trailing)
        }
        
        leftSectionView.addArrangedSubview(annualRoiView)
        annualRoiView.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        annualRoiView.addSubview(annualRoiTitleLabel)
        annualRoiTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        annualRoiView.addSubview(annualRoiLabel)
        annualRoiLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(annualRoiTitleLabel.snp.trailing)
        }
        
        leftSectionView.addArrangedSubview(sharpRatioView)
        sharpRatioView.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        sharpRatioView.addSubview(sharpRatioTitleLabel)
        sharpRatioTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        sharpRatioView.addSubview(sharpRatioLabel)
        sharpRatioLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(sharpRatioTitleLabel.snp.trailing)
        }

        rightSectionView.addArrangedSubview(mDDView)
        mDDView.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        mDDView.addSubview(mDDTitleLabel)
        mDDTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        mDDView.addSubview(mDDLabel)
        mDDLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(mDDTitleLabel.snp.trailing)
        }
        
        rightSectionView.addArrangedSubview(winRateView)
        winRateView.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        winRateView.addSubview(winRateTitleLabel)
        winRateTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        winRateView.addSubview(winRateLabel)
        winRateLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(winRateTitleLabel.snp.trailing)
        }
    }
    
    private let bgBottomView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = .black
        return view
    }()
    
    private let bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = .white
        return view
    }()
    
    private let contentMarginView = UIView()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = "ic_profile_avatar_placeholder".image()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let followButton: BlablaBlockOrangeButtonView = {
        let button = BlablaBlockOrangeButtonView()
        button.setTitle("追蹤", for: .normal)
        button.setTitle("追蹤中", for: .selected)
        button.font = .boldSystemFont(ofSize: 12)
        return button
    }()
    
    private let totalAssetLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 10)
        label.textColor = .black2D2D2D_80
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black2D2D2D
        return label
    }()
    
    private let bottomSectionView = UIView()
    
    private let leftSectionView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2D2D2D_40
        return view
    }()
    
    private let rightSectionView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private let roiView = UIView()
    
    private let roiTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "總報酬率"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .black2D2D2D_80
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let roiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black2D2D2D
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    private let annualRoiView = UIView()
    
    private let annualRoiTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "年化報酬率"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .black2D2D2D_80
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let annualRoiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black2D2D2D
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    private let mDDView = UIView()
    
    private let mDDTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "最大回撤"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .black2D2D2D_80
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let mDDLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black2D2D2D
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    private let winRateView = UIView()
    
    private let winRateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "勝率"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .black2D2D2D_80
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let winRateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black2D2D2D
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    private let sharpRatioView = UIView()
    
    private let sharpRatioTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sharp Ratio"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .black2D2D2D_80
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let sharpRatioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black2D2D2D
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
}
