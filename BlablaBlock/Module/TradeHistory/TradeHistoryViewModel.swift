//
//  TradeHistoryViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import RxCocoa
import RxSwift

public protocol TradeHistoryViewModelInputs {
    var viewDidLoad: PublishRelay<()> { get }
    var userId: BehaviorRelay<Int?> { get }
    var currencySelected: BehaviorRelay<String> { get }
}

public protocol TradeHistoryViewModelOutputs {
    var currencyList: Signal<[String]> { get }
    var selectedCurrency: Signal<String> { get }
    var historyData: Driver<[HistoryApiData]> { get }
}

public protocol TradeHistoryViewModelType {
    var inputs: TradeHistoryViewModelInputs { get }
    var outputs: TradeHistoryViewModelOutputs { get }
}

final class TradeHistoryViewModel:
    BaseViewModel,
    TradeHistoryViewModelInputs,
    TradeHistoryViewModelOutputs,
    TradeHistoryViewModelType
{
    
    public var inputs: TradeHistoryViewModelInputs { self }
    public var outputs: TradeHistoryViewModelOutputs { self }
    
    // MARK: - Inputs
    
    let viewDidLoad: PublishRelay<()>
    let userId: BehaviorRelay<Int?>
    let currencySelected: BehaviorRelay<String>
    
    // MARK: - Outputs
    
    let currencyList: Signal<[String]>
    let selectedCurrency: Signal<String>
    let historyData: Driver<[HistoryApiData]>
    
    // MARK: - Internals
    private let historyCache = BehaviorRelay<[HistoryApiData]>(value: [])
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let userId = BehaviorRelay<Int?>(value: nil)
        let currencySelected = BehaviorRelay<String>(value: "所有幣別")
        
        let currencyList = PublishRelay<[String]>()
        let selectedCurrency = PublishRelay<String>()
        let historyData = PublishRelay<[HistoryApiData]>()
        
        self.viewDidLoad = viewDidLoad
        self.userId = userId
        self.currencySelected = currencySelected
        
        self.currencyList = currencyList.asSignal()
        self.selectedCurrency = selectedCurrency.asSignal()
        self.historyData = historyData.asDriver(onErrorJustReturn: [])
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: { [weak self] in
                let userId = userId.value ?? Int(keychainUser[.userId]!)!
                self?.loadHistoryByID(userId, currencyList: currencyList)
            })
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                currencySelected,
                historyCache,
                resultSelector: { currency, history in
                    selectedCurrency.accept(currency)
                    if currency == "所有幣別" {
                        return history.sorted(by: { $0.timestamp > $1.timestamp })
                    } else {
                        return history.filter({ $0.baseCurrency == currency }).sorted(by: { $0.timestamp > $1.timestamp })
                    }
                }
            )
            .bind(to: historyData)
            .disposed(by: disposeBag)
    }
    
    private func loadHistoryByID(_ id: Int, currencyList: PublishRelay<[String]>) {
        UserService.getTradeHistoryByID(userId: id)
            .request()
            .subscribe(onSuccess: { [weak self] response in
                switch response {
                case let .success(historyApiResponse):
                    var currencies = historyApiResponse.data
                        .map { $0.baseCurrency }
                        .unique()
                        .sorted(by: { $0 < $1 })
                    currencies.insert("所有幣別", at: 0)
                    currencyList.accept(currencies)
                    self?.historyCache.accept(historyApiResponse.data)
                case let .failure(responseFailure):
                    self?.errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
                }
            },
            onFailure: { [weak self] error in
                self?.errorHandler(error: error)
            }
        )
        .disposed(by: disposeBag)
    }
}
