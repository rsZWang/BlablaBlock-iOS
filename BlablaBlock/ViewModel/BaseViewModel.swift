//
//  BaseViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/19.
//

import RxSwift

public class BaseViewModel {
    
    internal var disposeBag: DisposeBag!
    
    init() {
        disposeBag = DisposeBag()
    }
    
    func refreshBag() {
        disposeBag = nil
        disposeBag = DisposeBag()
    }
    
}
