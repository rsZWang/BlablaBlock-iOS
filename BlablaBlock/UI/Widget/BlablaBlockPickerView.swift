//
//  BlablaBlockPickerView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/21.
//

import UIKit
import SnapKit
import RxSwift
import RxGesture

public final class BlablaBlockPickerView: UIView {
    
    var itemList: [String]? {
        didSet {
            pickerView.itemList = itemList ?? []
        }
    }
    
    private let disposeBag = DisposeBag()
    
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
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = .grayEDEDED
        
        imageView.image = "ic_drop_down_arrow".image()
        imageView.contentMode = .center
        
        label.text = "WTFWTFWTF"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black2D2D2D
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        
        pickerView.pickerViewDelegate = self
        pickerView.bind(textField: textField)
        
        self.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.textField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(6)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(imageView.snp.leading)
        }
        
        contentView.addSubview(textField)
    }
    
    private let contentView = UIView()
    private let label = UILabel()
    private let imageView = UIImageView()
    private let textField = UITextField()
    private let pickerView = PickerView()
}

extension BlablaBlockPickerView: PickerViewDelegate {
    public func pickerView(_ pickerView: PickerView, selectedIndex: Int, selectedItem: String) {
        Timber.i("Selected: \(selectedItem)")
    }
}
