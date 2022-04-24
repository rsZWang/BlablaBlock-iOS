//
//  FollowingPortfolioSectionView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/21.
//

import UIKit
import SnapKit
import RxSwift
import RxDataSources

public final class FollowingPortfolioSectionView: UIView {
    
    static let currencySectionWidth = 0.38
    static let balanceSectionWidth = 0.38
    
    private let disposeBag = DisposeBag()
    weak var viewModel: PortfolioViewModelType? {
        didSet {
            setupBinding()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        headerSectionSeparatorView.backgroundColor = .black2D2D2D
        
        setupLabel(currencyTitleLabel)
        currencyTitleLabel.text = "代幣"
        currencyTitleLabel.textAlignment = .left
        
        setupLabel(balanceTitleLabel)
        balanceTitleLabel.text = "曝險"
        balanceTitleLabel.textAlignment = .right
        
        setupLabel(dayChangeTitleLabel)
        dayChangeTitleLabel.text = "24h漲跌"
        dayChangeTitleLabel.textAlignment = .right
        
        adjustWeightButton.setTitle("調整權重", for: .normal)
        adjustWeightButton.setTitleColor(.black2D2D2D, for: .normal)
        adjustWeightButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        adjustWeightButton.titleLabel?.autoFontSize()
        adjustWeightButton.layer.cornerRadius = 4
        adjustWeightButton.backgroundColor = .grayEDEDED
    }
    
    private func setupLabel(_ label: UILabel) {
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .black2D2D2D_80
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview()
        }
        
        containerView.addSubview(pickerSectionView)
        pickerSectionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        pickerSectionView.addSubview(exchangePicker)
        exchangePicker.snp.makeConstraints { make in
            make.width.equalTo(92)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        pickerSectionView.addSubview(typePicker)
        typePicker.snp.makeConstraints { make in
            make.width.equalTo(104)
            make.leading.equalTo(exchangePicker.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        
        pickerSectionView.addSubview(adjustWeightButton)
        adjustWeightButton.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(24)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(headerSectionView)
        headerSectionView.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.top.equalTo(pickerSectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        headerSectionView.addSubview(currencyTitleLabel)
        currencyTitleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(FollowingPortfolioSectionView.currencySectionWidth)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        headerSectionView.addSubview(balanceTitleLabel)
        balanceTitleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(FollowingPortfolioSectionView.balanceSectionWidth)
            make.leading.equalTo(currencyTitleLabel.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        headerSectionView.addSubview(dayChangeTitleLabel)
        dayChangeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(balanceTitleLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(headerSectionSeparatorView)
        headerSectionSeparatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerSectionView.snp.bottom)
        }
        
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerSectionSeparatorView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        guard let viewModel = viewModel else { return }

        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.followingPortfolioPull)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .followingPortfolio
            .map { [AnimatableSectionModel<String, PortfolioAssetViewData>(model: "", items: $0)] }
            .drive(
                tableView.rx.items(
                    dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, PortfolioAssetViewData>>(
                        configureCell: { dataSource, tableView, indexPath, item in
                            let cell = tableView.dequeueReusableCell(
                                withIdentifier: FollowingPortfolioTableViewCell.identifier,
                                for: indexPath
                            ) as! FollowingPortfolioTableViewCell
                            cell.bind(item)
                            return cell
                        }
                    )
                )
            )
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .followingPortfolioRefresh
            .emit(onNext: { [weak self] bool in
                guard let self = self else { return }
                if bool {
                    self.refreshControl.beginRefreshing(in: self.tableView)
                } else {
                    self.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private let containerView = UIView()
    private let pickerSectionView = UIView()
    private let exchangePicker = BlablaBlockPickerView()
    private let typePicker = BlablaBlockPickerView()
    private let adjustWeightButton = UIButton()
    private let headerSectionView = UIView()
    private let currencyTitleLabel = UILabel()
    private let balanceTitleLabel = UILabel()
    private let dayChangeTitleLabel = UILabel()
    private let headerSectionSeparatorView = UIView()
    private let tableView = FollowingPortfolioTableView()
    private let refreshControl = UIRefreshControl()
}

extension FollowingPortfolioSectionView: PickerViewDelegate {
    public func pickerView(_ pickerView: PickerView, selectedIndex: Int, selectedItem: String) {
        guard let viewModel = viewModel else { return }
        
        switch pickerView {
        case exchangePicker.pickerView:
            if let exchangeType = ExchangeType.init(rawValue: selectedItem) {
                viewModel.inputs
                    .followingPortfolioExchangeFilter
                    .accept(exchangeType)
            }
            break
        case typePicker.pickerView:
            if let  filterType = PortfolioType.init(rawValue: selectedItem) {
                viewModel.inputs
                    .followingPortfolioType
                    .accept(filterType)
            }
            break
        default:
            break
        }
    }
}
