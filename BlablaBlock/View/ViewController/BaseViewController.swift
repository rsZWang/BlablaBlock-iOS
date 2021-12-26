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
    internal var shortLifeCycleOwner: DisposeBag!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shortLifeCycleOwner = DisposeBag()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        shortLifeCycleOwner = nil
    }
    
    func promptAlert(message: String) {
        AlertBuilder()
            .setMessage(message)
            .setOkButton()
            .show(self)
    }
    
}
