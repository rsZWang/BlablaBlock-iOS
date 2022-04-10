//
//  FollowingPortfolio.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/10.
//

import UIKit
import RxSwift
import RxGesture

public protocol FollowingPortfolioViewDelegate: NSObject {
    func followingPortfolioView(_ view: FollowingPortfolioView, filteredExchange exchange: String)
    func followingPortfolioView(_ view: FollowingPortfolioView, filteredType type: String)
}

public final class FollowingPortfolioView: UIView, NibOwnerLoadable {

    @IBOutlet weak var exchangeFilterView: UIView!
    @IBOutlet weak var exchangeFilterTextField: UITextField!
    @IBOutlet weak var typeFilterView: UIView!
    @IBOutlet weak var typeFilterTextField: UITextField!
    @IBOutlet weak var adjustWeightLabel: UILabel!
    @IBOutlet weak var tableView: FollowingPortfolioAssetTableView!
    private lazy var pickerView: PickerView = {
        let pickerView = PickerView()
        pickerView.pickerViewDelegate = self
        return pickerView
    }()
    let refreshControl = UIRefreshControl()
    
    private let disposeBag = DisposeBag()
    private var selector = 0
    weak var delegate: FollowingPortfolioViewDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init(_ delegate: LinkCardViewDelegate, image: UIImage, title: String) {
        self.init(frame: .zero)
    }
    
    func commonInit() {
        loadNibContent()
        tableView.addSubview(refreshControl)
        
        exchangeFilterView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [unowned self] _ in
                selector = 0
                pickerView.itemList = ExchangeType.titleList
                pickerView.bind(textField: exchangeFilterTextField)
                exchangeFilterTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        typeFilterView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [unowned self] _ in
                selector = 1
                pickerView.itemList = PortfolioType.titleList
                pickerView.bind(textField: typeFilterTextField)
                typeFilterTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
    }
}

extension FollowingPortfolioView: PickerViewDelegate {
    public func onSelected(index: Int, item: String) {
        if selector == 0 {
            delegate?.followingPortfolioView(self, filteredExchange: ExchangeType.typeList[index])
        } else {
            delegate?.followingPortfolioView(self, filteredType: PortfolioType.typeList[index])
        }
    }
}
