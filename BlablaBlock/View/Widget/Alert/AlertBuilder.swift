//
//  AlertBuilder.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/13.
//

import UIKit

class AlertBuilder {
    
    private var title: String!
    private var message: String!
    private var action: UIAlertAction!
    
    func setTitle(_ title: String) -> AlertBuilder {
        self.title = title
        return self
    }
    
    func setMessage(_ message: String) -> AlertBuilder {
        self.message = message
        return self
    }
    
    func setButton(title: String, action: (() -> Void)? = nil) -> AlertBuilder {
        self.action = UIAlertAction(title: title, style: .default) { alertAction in
            action?()
        }
        return self
    }
    
    func setOkButton(title: String = "好的") -> AlertBuilder {
        self.action = UIAlertAction(title: title, style: .default)
        return self
    }
    
    @discardableResult
    func show(_ parent: UIViewController? = Utils.findMostTopViewController()) -> UIAlertController {
        let alertController = UIAlertController(title: title ?? "訊息", message: message, preferredStyle: .alert)
        if let buttonAction = action {
            alertController.addAction(buttonAction)
        }
        parent?.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
}
