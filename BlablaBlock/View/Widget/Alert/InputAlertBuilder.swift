//
//  InputAlertBuilder.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/19.
//

import UIKit

class InputAlert {
    
    private lazy var alertController = UIAlertController(title: "標題", message: "訊息", preferredStyle: .alert)
    
    deinit {
        Timber.i("FUCKFUCKFUCK")
    }
    
    func setTitle(_ title: String) -> InputAlert {
        alertController.title = title
        return self
    }
    
    func setMessage(_ message: String) -> InputAlert {
        alertController.message = message
        return self
    }
    
    func addTextField(tag: Int, placeholder: String) -> InputAlert {
        alertController.addTextField(configurationHandler: { textField in
            textField.tag = tag
            textField.placeholder = placeholder
        })
        return self
    }
    
    func setConfirmButton(title: String, action: @escaping ([Int : String]) -> Void) -> InputAlert {
        alertController.addAction(UIAlertAction(title: title, style: .default) { [unowned self] _ in
            var result = [Int : String]()
            if let textFields = alertController.textFields {
                for textField in textFields {
                    result[textField.tag] = textField.text
                }
            }
            action(result)
        })
        return self
    }
    
    func build() -> InputAlert {
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        return self
    }
    
    @discardableResult
    func show(_ parent: UIViewController? = Utils.findMostTopViewController()) -> UIAlertController {
        parent?.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
}
