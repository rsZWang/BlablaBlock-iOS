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

public protocol BlablaBlockPickerViewDelegate: AnyObject {
    func blablaBlockPickerView(_ view: BlablaBlockPickerView, selectedIndex: Int)
}

public final class BlablaBlockPickerView: UIView {
    
    public enum Style {
        case bordered
        case normal
    }
    
    private let disposeBag = DisposeBag()
    private var style: Style = .normal
    var itemList: [String]? {
        didSet {
            if itemList?.isNotEmpty == true {
                pickerView.itemList = itemList!
                label.text = itemList!.first
            }
        }
    }
    var delegate: BlablaBlockPickerViewDelegate?
    
    convenience init(style: BlablaBlockPickerView.Style) {
        self.init(frame: .zero)
        self.style = style
        self.commonInit()
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
        if style == .normal {
            contentView.backgroundColor = .grayEDEDED
        } else {
            contentView.backgroundColor = nil
            contentView.borderColor = .black2D2D2D
            contentView.borderWidth = 1
        }
        
        contentView.layer.cornerRadius = 4
        
        imageView.image = "ic_drop_down_arrow".image()
        imageView.contentMode = .center
        
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black2D2D2D
        label.autoFontSize()
        
        pickerView.bind(textField: textField)
        pickerView.pickerViewDelegate = self
        
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
        label.text = selectedItem
        delegate?.blablaBlockPickerView(self, selectedIndex: selectedIndex)
    }
}
