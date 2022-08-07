//
//  SettingViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import RxCocoa
import RxSwift

public protocol SettingViewModelInputs: AnyObject {
    var viewDidLoad: PublishRelay<()> { get }
    var onCreate: PublishRelay<(FilterExchange, String, String)> { get }
    var onDelete: PublishRelay<ExchangeApiData> { get }
    var onSignOut: PublishRelay<()> { get }
}

public protocol SettingViewModelOutputs: BaseViewModelOutputs {
    var exchanges: BehaviorRelay<[ExchangeApiData]> { get }
    var signOut: Signal<()> { get }
}

public protocol SettingViewModelType: AnyObject {
    var inputs: SettingViewModelInputs { get }
    var outputs: SettingViewModelOutputs { get }
}

public final class SettingViewModel:
    BaseViewModel,
    SettingViewModelInputs,
    SettingViewModelOutputs,
    SettingViewModelType
{
    // MARK: - inputs
    public var viewDidLoad: PublishRelay<()>
    public var onCreate: PublishRelay<(FilterExchange, String, String)>
    public var onEdit: PublishRelay<(ExchangeApiData, FilterExchange, String, String)>
    public var onDelete: PublishRelay<ExchangeApiData>
    public var onSignOut: PublishRelay<()>
    
    // MARK: - outputs
    public var exchanges: BehaviorRelay<[ExchangeApiData]>
    public var signOut: Signal<()>
    
    public var inputs: SettingViewModelInputs { self }
    public var outputs: SettingViewModelOutputs { self }
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let onCreate = PublishRelay<(FilterExchange, String, String)>()
        let onEdit = PublishRelay<(ExchangeApiData, FilterExchange, String, String)>()
        let onDelete = PublishRelay<ExchangeApiData>()
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
                self?.getExchangeStatus(exchanges: exchanges)
            })
            .disposed(by: disposeBag)
        
        onCreate
            .subscribe(onNext: { [weak self] tuple in
                self?.create(exchange: tuple.0.rawValue, apiKey: tuple.1, secretKey: tuple.2, exchanges: exchanges)
            })
            .disposed(by: disposeBag)
        
        onDelete
            .subscribe(onNext: { [weak self] exchangeApiData in
                self?.delete(exchange: exchangeApiData, exchanges: exchanges)
            })
            .disposed(by: disposeBag)
        
        onSignOut
            .subscribe(onNext: { [weak self] in
                self?.doSignOut(signOut: signOut)
            })
            .disposed(by: disposeBag)
        
        viewDidLoad.accept(())
    }
    
    private func getExchangeStatus(exchanges: BehaviorRelay<[ExchangeApiData]>) {
        ExchangeService.getStatus()
            .subscribe(
                onSuccess: { [weak self] response in
                    switch response {
                    case let .success(exchange):
                        exchanges.accept(exchange.data)
                    case let .failure(responseFailure):
//                        self?.errorCodeHandler(responseFailure)
                        exchanges.accept([])
                    }
                },
                onFailure: { [weak self] error in
//                    self?.errorHandler(error: error)
                    exchanges.accept([])
                }
            )
            .disposed(by: disposeBag)
    }

    private func create(
        exchange: String,
        apiKey: String,
        secretKey: String,
        exchanges: BehaviorRelay<[ExchangeApiData]>
    ) {
        ExchangeService.create(exchange: exchange, apiKey: apiKey, secretKey: secretKey)
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.getExchangeStatus(exchanges: exchanges)
                },
                onFailure: { [weak self] error in
                    self?.errorHandler(error: error)
                }
            )
            .disposed(by: disposeBag)
    }

    private func delete(
        exchange: ExchangeApiData,
        exchanges: BehaviorRelay<[ExchangeApiData]>
    ) {
        ExchangeService.delete(exchange: exchange.exchange, apiKey: exchange.apiKey)
            .subscribe(
                onSuccess: { [weak self] response in
                    self?.getExchangeStatus(exchanges: exchanges)
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
