//
//  PickerView.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/27.
//

import UIKit

protocol PickerViewDelegate: NSObject {
    func onSelected(index: Int, item: String)
}

class PickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    public private(set) var toolbar: UIToolbar?
    private weak var textField: UITextField?
    weak var pickerViewDelegate: PickerViewDelegate?
    var itemList = [String]()

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
    
    func bind(textField: UITextField) {
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
        pickerViewDelegate?.onSelected(index: index, item: itemList[index])
        textField?.text = itemList[index]
        textField?.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        itemList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        itemList[row]
    }
    
}
