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
}

public protocol TradeHistoryViewModelOutputs {
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
    
    public let viewDidLoad: PublishRelay<()>
    
    // MARK: - Outputs
    
    public let historyData: Driver<[HistoryApiData]>
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let historyData = BehaviorRelay<[HistoryApiData]>(value: [])
        
        self.viewDidLoad = viewDidLoad
        self.historyData = historyData.asDriver()
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.loadHistory(historyData: historyData)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadHistory(historyData: BehaviorRelay<[HistoryApiData]>) {
//        StatisticsService.getTradeHistory()
//            .request()
//            .subscribe(onSuccess: { [weak self] response in
//                switch response {
//                case let .success(historyApiResponse):
//                    historyData.accept(historyApiResponse.data)
//                case let .failure(responseFailure):
//                    self?.errorCodeHandler(code: responseFailure.code, msg: responseFailure.msg)
//                }
//            },
//            onFailure: { [weak self] error in
//                self?.errorHandler(error: error)
//            }
//        )
//        .disposed(by: disposeBag)
        
        let data = [
            HistoryApiData(
                exchange: "binance",
                currency: "ETH",
                type: "spot",
                timestamp: 1637901093,
                side: "BUY",
                price: "2925.2",
                executedQty: "1.2"
            ),
            HistoryApiData(
                exchange: "ftx",
                currency: "ETH",
                type: "spot",
                timestamp: 1637901093,
                side: "SELL",
                price: "2925.2",
                executedQty: "1.2"
            )
        ]
        historyData.accept(data)
    }
}
