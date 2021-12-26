//
//  AlertBuilder.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/13.
//

import UIKit

class AlertBuilder {
    
    private var style: UIAlertController.Style = .alert
    private var title: String!
    private var message: String!
    private var actionList = [UIAlertAction]()
    
    func setStyle(_ style: UIAlertController.Style) -> AlertBuilder{
        self.style = style
        return self
    }
    
    func setTitle(_ title: String) -> AlertBuilder {
        self.title = title
        return self
    }
    
    func setMessage(_ message: String) -> AlertBuilder {
        self.message = message
        return self
    }
    
    func setButton(title: String, style: UIAlertAction.Style = .default, action: (() -> Void)? = nil) -> AlertBuilder {
        self.actionList.append(UIAlertAction(title: title, style: style) { alertAction in
            action?()
        })
        return self
    }
    
    func setOkButton(title: String = "OK") -> AlertBuilder {
        self.actionList.append(UIAlertAction(title: title, style: .default))
        return self
    }
    
    @discardableResult
    func show(_ parent: UIViewController? = Utils.findMostTopViewController()) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style
        )
        for action in actionList {
            alertController.addAction(action)
        }
        parent?.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
}
