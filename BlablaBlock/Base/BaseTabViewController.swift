//
//  BaseTabViewController.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/5.
//

import Tabman
import RxSwift

open class BaseTabViewController: TabmanViewController {
    
    internal let disposeBag = DisposeBag()
    
    internal func promptAlert(error: Error, action: (() -> Void)? = nil) {
        promptAlert(message: "\(error)", action: action)
    }
    
    internal func promptAlert(message: String, action: (() -> Void)? = nil) {
        AlertBuilder()
            .setMessage(message)
            .setOkButton(action: action)
            .show(self)
    }
    
}
