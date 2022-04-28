//
//  SettingViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Resolver
import RxCocoa
import RxSwift

protocol SettingViewModelInputs: AnyObject {
    var viewDidLoad: PublishRelay<()> { get }
    var onCreate: PublishRelay<(ExchangeType, String, String)> { get }
    var onEdit: PublishRelay<(Int, ExchangeType, String, String)> { get }
    var onDelete: PublishRelay<Int> { get }
    var onSignOut: PublishRelay<()> { get }
}

protocol SettingViewModelOutputs: BaseViewModelOutputs {
    var exchanges: BehaviorRelay<[ExchangeApiData]> { get }
    var signOut: Signal<()> { get }
}

protocol SettingViewModelType: AnyObject {
    var inputs: SettingViewModelInputs { get }
    var outputs: SettingViewModelOutputs { get }
}

final class SettingViewModel:
    BaseViewModel,
    SettingViewModelInputs,
    SettingViewModelOutputs,
    SettingViewModelType
{
    // MARK: - inputs
    var viewDidLoad: PublishRelay<()>
    var onCreate: PublishRelay<(ExchangeType, String, String)>
    var onEdit: PublishRelay<(Int, ExchangeType, String, String)>
    var onDelete: PublishRelay<Int>
    var onSignOut: PublishRelay<()>
    
    // MARK: - outputs
    var exchanges: BehaviorRelay<[ExchangeApiData]>
    var signOut: Signal<()>
    
    var inputs: SettingViewModelInputs { self }
    var outputs: SettingViewModelOutputs { self }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let onCreate = PublishRelay<(ExchangeType, String, String)>()
        let onEdit = PublishRelay<(Int, ExchangeType, String, String)>()
        let onDelete = PublishRelay<Int>()
        let onSignOut = PublishRelay<()>()
        
        self.viewDidLoad = viewDidLoad
        self.onCreate = onCreate
        self.onEdit = onEdit
        self.onDelete = onDelete
        self.onSignOut = onSignOut
        
        let exchanges = BehaviorRelay<[ExchangeApiData]>(value: [])
        let signOut = PublishRelay<()>()
        
        self.exchanges = exchanges
        self.signOut = signOut.asSignal()
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.getExchangeStatus(exchages: exchanges)
            })
            .disposed(by: disposeBag)
        
        onCreate
            .subscribe(onNext: { [weak self] tuple in
                self?.create(exchange: tuple.0.rawValue, apiKey: tuple.1, apiSecret: tuple.2, exchanges: exchanges)
            })
            .disposed(by: disposeBag)
        
        onEdit
            .subscribe(onNext: { [weak self] tuple in
                self?.edit(id: tuple.0, exchange: tuple.1.rawValue, apiKey: tuple.2, apiSecret: tuple.3, subaccount: "", exchanges: exchanges)
            })
            .disposed(by: disposeBag)
        
        onDelete
            .subscribe(onNext: { [weak self] id in
                self?.delete(id: id, exchanges: exchanges)
            })
            .disposed(by: disposeBag)
        
        onSignOut
            .subscribe(onNext: { [weak self] in
                self?.doSignOut(signOut: signOut)
            })
            .disposed(by: disposeBag)
        
        viewDidLoad.accept(())
    }
    
    private func getExchangeStatus(exchages: BehaviorRelay<[ExchangeApiData]>) {
        ExchangeService.getStatus()
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(exchange):
                        exchages.accept(exchange.data)
                    case let .failure(responseFailure):
                        self?.errorCodeHandler(responseFailure)
                    }
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }

    private func create(
        exchange: String,
        apiKey: String,
        apiSecret: String,
        exchanges: BehaviorRelay<[ExchangeApiData]>
    ) {
        ExchangeService.create(exchange: exchange, apiKey: apiKey, apiSecret: apiSecret)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.newExchangeHandler(response: response, exchanges: exchanges)
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }

    private func edit(
        id: Int,
        exchange: String,
        apiKey: String,
        apiSecret: String,
        subaccount: String,
        exchanges: BehaviorRelay<[ExchangeApiData]>
    ) {
        ExchangeService.edit(id: id, exchange: exchange, apiKey: apiKey, apiSecret: apiSecret, subAccount: subaccount)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.newExchangeHandler(response: response, exchanges: exchanges)
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }

    private func delete(
        id: Int,
        exchanges: BehaviorRelay<[ExchangeApiData]>
    ) {
        ExchangeService.delete(id: id)
            .request()
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.newExchangeHandler(response: response, exchanges: exchanges)
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }

    private func newExchangeHandler(
        response: HttpResponse<ExchangeApi, ResponseFailure>,
        exchanges: BehaviorRelay<[ExchangeApiData]>
    ) {
        switch response {
        case let .success(exchange):
            exchanges.accept(exchange.data)
        case let .failure(responseFailure):
            errorCodeHandler(responseFailure)
        }
    }
    
    private func doSignOut(signOut: PublishRelay<()>) {
        AuthService.logout()
            .request()
            .subscribe(
                onSuccess: { response in
                    do {
                        try keychainUser.removeAll()
                    } catch {
                        Timber.e("Sign out error: \(error)")
                    }
                    signOut.accept(())
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }
}
