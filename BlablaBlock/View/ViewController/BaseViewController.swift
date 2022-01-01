//
//  BaseViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/12.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    internal let disposeBag = DisposeBag()
    internal var shortLifecycleOwner: DisposeBag!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shortLifecycleOwner = DisposeBag()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        shortLifecycleOwner = nil
    }
    
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
