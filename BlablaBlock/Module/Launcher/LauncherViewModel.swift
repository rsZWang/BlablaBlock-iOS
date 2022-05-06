//
//  LauncherViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/3/30.
//

import RxCocoa
import RxSwift

public protocol LauncherViewModelInputs {
    var viewDidAppear: PublishRelay<()> { get }
}

public protocol LauncherViewModelOutputs {
    var login: PublishRelay<()> { get }
    var preload: PublishRelay<String> { get }
}

public protocol LauncherViewModelType {
    var inputs: LauncherViewModelInputs { get }
    var outputs: LauncherViewModelOutputs { get }
}

final public class LauncherViewModel:
    BaseViewModel,
    LauncherViewModelInputs,
    LauncherViewModelOutputs,
    LauncherViewModelType
{
    
    // MARK: - inputs
    
    public var viewDidAppear: PublishRelay<()>
    
    // MARK: - outpus
    
    public var login: PublishRelay<()>
    public var preload: PublishRelay<String>
    
    public var inputs: LauncherViewModelInputs { self }
    public var outputs: LauncherViewModelOutputs { self }
    
    override init() {
        let viewDidAppear = PublishRelay<()>()
        
        let login = PublishRelay<()>()
        let preload = PublishRelay<String>()
        
        self.viewDidAppear = viewDidAppear
        
        self.login = login
        self.preload = preload
        
        super.init()
        
        viewDidAppear
            .subscribe(onNext: { [weak self] in
                self?.checkLogin(preload: preload, login: login)
            })
            .disposed(by: disposeBag)
    }
}

public extension LauncherViewModel {
    
    func checkLogin(
        preload: PublishRelay<String>,
        login: PublishRelay<()>
    ) {
        if let _ = keychainUser[.userToken], let userId = keychainUser[.userId] {
            preload.accept(userId)
        } else {
            login.accept(())
        }
    }
}
