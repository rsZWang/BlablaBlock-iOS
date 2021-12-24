//
//  StatisticsViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/20.
//

import Resolver
import RxCocoa
import RxSwift

class StatisticsViewModel: BaseViewModel {
    
    @Injected private var statisticsService: StatisticsService
    
    func getPortfolio() -> Single<Portfolio> {
        StatisticsService.getPortfolio(exchange: "all")
            .request()
    }
    
    func getPNL() -> Single<PNL> {
        StatisticsService.getPNL(exchange: "all", period: "1y")
            .request()
    }
    
}
