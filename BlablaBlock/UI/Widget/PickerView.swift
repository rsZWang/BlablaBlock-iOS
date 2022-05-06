//
//  PickerView.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/27.
//

import UIKit

public protocol PickerViewDelegate: AnyObject {
    func pickerView(_ pickerView: PickerView, selectedIndex: Int, selectedItem: String)
}

public final class PickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    public private(set) var toolbar: UIToolbar?
    private weak var textField: UITextField?
    public weak var pickerViewDelegate: PickerViewDelegate?
    public var itemList = [String]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        dataSource = self
        delegate = self
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(
            title: "取消",
            style: .plain,
            target: self,
            action: #selector(cancel)
        )
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(
            title: "確定",
            style: .done,
            target: self,
            action: #selector(done)
        )
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        self.toolbar = toolbar
    }
    
    public func bind(textField: UITextField) {
        textField.inputView = self
        textField.inputAccessoryView = toolbar
        textField.tintColor = .clear
        self.textField = textField
    }

    @objc
    private func cancel() {
        textField?.endEditing(true)
    }

    @objc
    private func done() {
        let index = selectedRow(inComponent: 0)
        pickerViewDelegate?.pickerView(self, selectedIndex: index, selectedItem: itemList[index])
        textField?.text = itemList[index]
        textField?.endEditing(true)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        itemList.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        itemList[row]
    }
}
