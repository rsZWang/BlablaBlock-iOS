//
//  PortfolioView.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/21.
//

import UIKit
import RxSwift
import RxGesture

public protocol PortfolioViewDelegate: NSObject {
    func onExchangeFiltered(_ view: PortfolioView, exchange: String)
    func onPortfolioTypeFiltered(_ view: PortfolioView, type: String)
    func onTapHistory(_ view: PortfolioView)
}

public final class PortfolioView: UIView, NibOwnerLoadable {

    @IBOutlet weak var exchangeFilterView: UIView!
    @IBOutlet weak var exchangeFilterTextField: UITextField!
    @IBOutlet weak var typeFilterView: UIView!
    @IBOutlet weak var typeFilterTextField: UITextField!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var tableView: ExchangeListTableView!
    private lazy var pickerView: PickerView = {
        let pickerView = PickerView()
        pickerView.pickerViewDelegate = self
        return pickerView
    }()
    let refreshControl = UIRefreshControl()
    
    private let disposeBag = DisposeBag()
    private var selector = 0
    weak var delegate: PortfolioViewDelegate?
    
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
        
        historyButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [unowned self] _ in
                delegate?.onTapHistory(self)
            })
            .disposed(by: disposeBag)
    }
}

extension PortfolioView: PickerViewDelegate {
    func onSelected(index: Int, item: String) {
        if selector == 0 {
            delegate?.onExchangeFiltered(self, exchange: ExchangeType.typeList[index])
        } else {
            delegate?.onPortfolioTypeFiltered(self, type: PortfolioType.typeList[index])
        }
    }
}
