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
    
    let viewDidLoad: PublishRelay<()>
    let userId: BehaviorRelay<Int?>
    
    // MARK: - Outputs
    
    let historyData: Driver<[HistoryApiData]>
    
    deinit {
        Timber.i("\(type(of: self)) deinit")
    }
    
    override init() {
        let viewDidLoad = PublishRelay<()>()
        let userId = BehaviorRelay<Int?>(value: nil)
        let historyData = BehaviorRelay<[HistoryApiData]>(value: [])
        
        self.viewDidLoad = viewDidLoad
        self.userId = userId
        self.historyData = historyData.asDriver()
        
        super.init()
        
        viewDidLoad
            .subscribe(onNext: { [weak self] in
                if let userId = userId.value {
                    self?.loadHistoryByID(userId, historyData: historyData)
                } else {
                    self?.loadHistory(historyData: historyData)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func loadHistory(historyData: BehaviorRelay<[HistoryApiData]>) {
        StatisticsService.getTradeHistory()
            .request()
            .subscribe(onSuccess: { [weak self] response in
                switch response {
                case let .success(historyApiResponse):
                    historyData.accept(historyApiResponse.data)
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
    
    private func loadHistoryByID(_ id: Int, historyData: BehaviorRelay<[HistoryApiData]>) {
        UserService.getTradeHistoryByID(userId: id)
            .request()
            .subscribe(onSuccess: { [weak self] response in
                switch response {
                case let .success(historyApiResponse):
                    historyData.accept(historyApiResponse.data)
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
