//
//  PortfolioView.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/21.
//

import UIKit
import RxSwift
import RxGesture

protocol PortfolioViewDelegate {
    func filterExchange(callback: (String) -> Void)
}

class PortfolioView: UIView, NibOwnerLoadable {

    @IBOutlet weak var exchangeFilterView: UIView!
    @IBOutlet weak var exchangeFilterLabel: UILabel!
    @IBOutlet weak var tableView: ExchangeListTableView!
    
    private let disposeBag = DisposeBag()
    var delegate: PortfolioViewDelegate?
    
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
        exchangeFilterView.rx
            .tapGesture()
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.filterExchange { text in
                    self?.exchangeFilterLabel.text = text
                }
            })
            .disposed(by: disposeBag)
    }

}
