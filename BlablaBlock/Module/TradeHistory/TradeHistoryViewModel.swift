//
//  TradeHistoryViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2022/2/27.
//

import RxCocoa
import RxSwift

public protocol TradeHistoryViewModelInputs: AnyObject {
    var viewDidLoad: PublishRelay<()> { get }
    var userId: BehaviorRelay<Int?> { get }
    var selectedCurrencyIndex: BehaviorRelay<Int> { get }
}

public protocol TradeHistoryViewModelOutputs: AnyObject {
    var currencyList: Driver<[String]> { get }
    var historyData: Driver<[HistoryApiData]> { get }
}

public protocol TradeHistoryViewModelType: AnyObject {
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
    let selectedCurrencyIndex: BehaviorRelay<Int>
    
    // MARK: - Outputs
    
    let currencyList: Driver<[String]>
    let historyData: Driver<[HistoryApiData]>
    
    // MARK: - Internals
    private let historyCache = BehaviorRelay<[HistoryApiData]>(value: [])
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let userId = BehaviorRelay<Int?>(value: nil)
        let selectedCurrencyIndex = BehaviorRelay<Int>(value: 0)
        
        let currencyList = BehaviorRelay<[String]>(value: [])
        let historyData = PublishRelay<[HistoryApiData]>()
        
        self.viewDidLoad = viewDidLoad
        self.userId = userId
        self.selectedCurrencyIndex = selectedCurrencyIndex
        
        self.currencyList = currencyList.asDriver()
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
                selectedCurrencyIndex,
                historyCache,
                resultSelector: { index, history in
                    if currencyList.value.isEmpty {
                        return []
                    } else {
                        let currency = currencyList.value[index]
                        if currency == TradeHistoryViewController.filterAll {
                            return history.sorted(by: { $0.timestamp > $1.timestamp })
                        } else {
                            return history.filter({ $0.baseCurrency == currency }).sorted(by: { $0.timestamp > $1.timestamp })
                        }
                    }
                }
            )
            .bind(to: historyData)
            .disposed(by: disposeBag)
    }
    
    private func loadHistoryByID(_ id: Int, currencyList: BehaviorRelay<[String]>) {
        UserService.getTradeHistoryByID(userId: id)
            .request()
            .subscribe(onSuccess: { [weak self] response in
                switch response {
                case let .success(historyApiResponse):
                    var currencies = historyApiResponse.data
                        .map { $0.baseCurrency }
                        .unique()
                        .sorted(by: { $0 < $1 })
                    currencies.insert(TradeHistoryViewController.filterAll, at: 0)
                    currencyList.accept(currencies)
                    self?.historyCache.accept(historyApiResponse.data)
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
}
