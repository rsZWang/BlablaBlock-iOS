//
//  LauncherViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/30.
//

import Resolver
import RxCocoa
import RxSwift

public protocol LauncherViewModelInputs {
    var onLogin: PublishRelay<String> { get }
}

public protocol LauncherViewModelOutputs {
    
}

public protocol LauncherViewModelType {
    var inputs: LauncherViewModelInputs { get }
    var outputs: LauncherViewModelOutputs { get }
}

final class LauncherViewModel:
    BaseViewModel,
    LauncherViewModelInputs,
    LauncherViewModelOutputs,
    LauncherViewModelType
{
    
    // MARK: - inputs
    
    var onLogin: PublishRelay<String> = PublishRelay<String>()
    
    var inputs: LauncherViewModelInputs { self }
    var outputs: LauncherViewModelOutputs { self }
    
    override init() {
        
        super.init()
        
        onLogin
            .subscribe(onNext: { userId in
                EventTracker.setUser(id: userId)
            })
            .disposed(by: disposeBag)
    }
}
