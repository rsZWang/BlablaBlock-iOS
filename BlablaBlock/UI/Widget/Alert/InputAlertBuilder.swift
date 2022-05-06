//
//  InputAlertBuilder.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/19.
//

import UIKit

final public class InputAlertBuilder {
    
    private lazy var alertController = UIAlertController(
        title: "標題",
        message: "訊息",
        preferredStyle: .alert
    )
    
    func setTitle(_ title: String) -> InputAlertBuilder {
        alertController.title = title
        return self
    }
    
    func setMessage(_ message: String) -> InputAlertBuilder {
        alertController.message = message
        return self
    }
    
    func addTextField(tag: Int, placeholder: String) -> InputAlertBuilder {
        alertController.addTextField(configurationHandler: { textField in
            textField.tag = tag
            textField.placeholder = placeholder
        })
        return self
    }
    
    func setConfirmButton(title: String, action: @escaping ([Int : String]) -> Void) -> InputAlertBuilder {
        alertController.addAction(UIAlertAction(title: title, style: .default) { [weak self] _ in
            var result = [Int : String]()
            if let textFields = self?.alertController.textFields {
                for textField in textFields {
                    result[textField.tag] = textField.text
                }
            }
            action(result)
        })
        return self
    }
    
    func build() -> InputAlertBuilder {
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        return self
    }
    
    @discardableResult
    func show(_ parent: UIViewController? = Utils.findMostTopViewController()) -> UIAlertController {
        parent?.present(alertController, animated: true, completion: nil)
        return alertController
    }
}
