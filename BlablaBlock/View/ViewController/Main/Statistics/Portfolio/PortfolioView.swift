//
//  PortfolioView.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/21.
//

import UIKit
import RxSwift
import RxGesture

protocol PortfolioViewDelegate: NSObject {
    func onExchangeFiltered(exchange: String)
}

class PortfolioView: UIView, NibOwnerLoadable {

    @IBOutlet weak var exchangeFilterView: UIView!
    @IBOutlet weak var exchangeFilterTextField: UITextField!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var tableView: ExchangeListTableView!
    private lazy var pickerView: PickerView = {
        let pickerView = PickerView()
        pickerView.itemList = Exchange.exchangeTitleList
        pickerView.pickerViewDelegate = self
        return pickerView
    }()
    let refreshControl = UIRefreshControl()
    
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
        pickerView.bind(textField: exchangeFilterTextField)
        tableView.addSubview(refreshControl)
    }

}

extension PortfolioView: PickerViewDelegate {
    func onSelected(index: Int, item: String) {
        delegate?.onExchangeFiltered(exchange: Exchange.exchangeTypeList[index])
    }
}
