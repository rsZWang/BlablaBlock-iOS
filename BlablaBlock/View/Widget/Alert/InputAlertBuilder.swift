//
//  InputAlertBuilder.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/19.
//

import UIKit

class InputAlertBuilder {
    
    private lazy var alertController = UIAlertController(title: title ?? "訊息", message: message, preferredStyle: .alert)
    private var title: String!
    private var message: String!
    private var confirmAction: UIAlertAction!
    private var textFieldList: [Int : String] = [:]
    
    func setTitle(_ title: String) -> InputAlertBuilder {
        self.title = title
        return self
    }
    
    func setMessage(_ message: String) -> InputAlertBuilder {
        self.message = message
        return self
    }
    
    func setTextField(tag: Int, placeholder: String) -> InputAlertBuilder {
        self.textFieldList[tag] = placeholder
        return self
    }
    
    func setConfirmButton(title: String, action: (([Int : String?]) -> Void)? = nil) -> InputAlertBuilder {
        self.confirmAction = UIAlertAction(title: title, style: .default) { [unowned self] alertAction in
            var result = [Int : String?]()
            for textField in self.textFieldList {
                if let field = alertController.view?.viewWithTag(textField.key) as? UITextField {
                    result[textField.key] = field.text
                }
            }
            action?(result)
        }
        return self
    }
    
    @discardableResult
    func show(_ parent: UIViewController? = Utils.findMostTopViewController()) -> UIAlertController {
        if let buttonAction = confirmAction {
            alertController.addAction(buttonAction)
        }
        for textFeild in textFieldList {
            alertController.addTextField { field in
                field.tag = textFeild.key
                field.placeholder = textFeild.value
            }
        }
        parent?.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
}
