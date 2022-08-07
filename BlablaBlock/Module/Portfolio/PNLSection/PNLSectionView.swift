//
//  PNLSectionView.swift
//  BlablaBlock
//
//  Created by Harry on 2022/4/24.
//

import UIKit
import SwiftCharts
import SnapKit
import RxSwift
import RxRelay
import SwiftUI

final class PNLSectionView: UIView {
    
    private let disposeBag = DisposeBag()
    weak var viewModel: PortfolioViewModelType? {
        didSet {
            setupBinding()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        periodPickerView.delegate = self
        periodPickerView.itemList = PNLPeriod.titleList
        
        dateTimeFormatter.dateFormat = "yyyy/MM/dd\nHH:mm:ss"
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        
        separatorView.backgroundColor = .black2D2D2D
        
        roiTitleLabel.text = "vc_portfolio_pnl_total_profit".localized()
        setupLabel(roiTitleLabel)
        setupLabel(roiLabel)
        
        roiAnnualTitleLabel.text = "vc_portfolio_pnl_annual_profit".localized()
        setupLabel(roiAnnualTitleLabel)
        setupLabel(roiAnnualLabel)
        
        mddTitleLabel.text = "vc_portfolio_pnl_drawndown".localized()
        setupLabel(mddTitleLabel)
        setupLabel(mddLabel)
        
        sharpeRatioTitleLabel.text = "vc_portfolio_pnl_sharpe_ratio".localized()
        setupLabel(sharpeRatioTitleLabel)
        setupLabel(sharpeRatioLabel)
    }
    
    private func setupLabel(_ label: UILabel) {
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black2D2D2D
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview()
        }
        
        containerView.addSubview(pickerSectionView)
        pickerSectionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        pickerSectionView.addSubview(periodPickerView)
        periodPickerView.snp.makeConstraints { make in
            make.width.equalTo(92)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        pickerSectionView.isHidden = true
        
        containerView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(pickerSectionView.snp.bottom)
        }
        
        scrollView.addSubview(scrollContainerView)
        scrollContainerView.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        scrollContainerView.addSubview(chartSectionView)
        chartSectionView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
        }

        scrollContainerView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(6)
            make.top.equalTo(chartSectionView.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-6)
        }

        scrollContainerView.addSubview(textSectionView)
        textSectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(6)
            make.top.equalTo(separatorView.snp.bottom).offset(24)
            make.trailing.equalToSuperview().offset(-6)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        textSectionView.addSubview(roiTitleLabel)
        roiTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }

        textSectionView.addSubview(roiLabel)
        roiLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        textSectionView.addSubview(roiAnnualTitleLabel)
        roiAnnualTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(roiTitleLabel.snp.bottom).offset(8)
        }

        textSectionView.addSubview(roiAnnualLabel)
        roiAnnualLabel.snp.makeConstraints { make in
            make.top.equalTo(roiLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
        }

        textSectionView.addSubview(mddTitleLabel)
        mddTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(roiAnnualTitleLabel.snp.bottom).offset(8)
        }

        textSectionView.addSubview(mddLabel)
        mddLabel.snp.makeConstraints { make in
            make.top.equalTo(roiAnnualLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
        }

        textSectionView.addSubview(sharpeRatioTitleLabel)
        sharpeRatioTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(mddTitleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }

        textSectionView.addSubview(sharpeRatioLabel)
        sharpeRatioLabel.snp.makeConstraints { make in
            make.top.equalTo(mddLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        guard let viewModel = viewModel else { return }

        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.pnlPull)
            .disposed(by: disposeBag)

        viewModel.outputs
            .pnl
            .emit(onNext: bind)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .pnlRefresh
            .emit(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private let containerView = UIView()
    private let pickerSectionView = UIView()
    private let periodPickerView = BlablaBlockPickerView(style: .normal)
    private let scrollView = UIScrollView()
    private let refreshControl = UIRefreshControl()
    private let scrollContainerView = UIView()
    private let chartSectionView = UIView()
    private let separatorView = UIView()
    private let textSectionView = UIView()
    private let roiTitleLabel = UILabel()
    private let roiLabel = UILabel()
    private let roiAnnualTitleLabel = UILabel()
    private let roiAnnualLabel = UILabel()
    private let mddTitleLabel = UILabel()
    private let mddLabel = UILabel()
    private let sharpeRatioTitleLabel = UILabel()
    private let sharpeRatioLabel = UILabel()
    private let dateTimeFormatter = DateFormatter()
    private let dateFormatter = DateFormatter()
    private var chart: Chart!
    private var currentPositionLabels: [UIView] = []
    private let xAxisLabelSettings = ChartLabelSettings(font: .systemFont(ofSize: 8))
    private let yAxisLabelSettings = ChartLabelSettings(font: .systemFont(ofSize: 8))
}

extension PNLSectionView: BlablaBlockPickerViewDelegate {
    public func blablaBlockPickerView(_ view: BlablaBlockPickerView, selectedIndex: Int) {
        guard let viewModel = viewModel else { return }
        
        if let period = PNLPeriod.init(index: selectedIndex) {
            viewModel.inputs
                .pnlPeriodFilter
                .accept(period)
        }
    }
}

extension PNLSectionView {
    
    func bind(data: PNLApiData) {
        drawChart(data: data)
        roiLabel.text = "\(data.roi.toPrettyPrecisedString())%"
        roiAnnualLabel.text = "\(data.roiAnnual.toPrettyPrecisedString())%"
        mddLabel.text = "\(data.mdd.toPrettyPrecisedString())%"
        sharpeRatioLabel.text = "\(data.sharpeRatio.toPrettyPrecisedString())"
    }
    
    func drawChart(data: PNLApiData) {
        
        if data.chartData.count <= 1 {
            return
        }
        
        if let chart = chart {
            currentPositionLabels.forEach { $0.removeFromSuperview() }
            chart.view.removeFromSuperview()
            self.chart = nil
        }
        
        let chartSettings = createChartSettings()
        let chartFrame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width - 48,
            height: 200
        )
        
        // Chart points line layer
        let chartPoints = data.getChartDataList().map { createChartPoint(point: $0) }
        let lineModel = ChartLineModel(
            chartPoints: chartPoints,
            lineColor: .red,
            lineWidth: 2,
            animDuration: 1,
            animDelay: 0
        )
        
        let xValues = data.getXAxis().map { createDateAxisValue(timestamp: $0) }
        let xModel = ChartAxisModel(axisValues: xValues)
        
        let yValues = data.getYAxis().map { ChartYAxisValue($0, labelSettings: yAxisLabelSettings) }
        let yModel = ChartAxisModel(axisValues: yValues)

        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(
            chartSettings: chartSettings,
            chartFrame: chartFrame,
            xModel: xModel,
            yModel: yModel
        )
        
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        // delayInit parameter is needed by some layers for initial zoom level to work correctly. Setting it to true allows to trigger drawing of layer manually (in this case, after the chart is initialized). This obviously needs improvement. For now it's necessary.
        let chartPointsLineLayer = ChartPointsLineLayer(
            xAxis: xAxisLayer.axis,
            yAxis: yAxisLayer.axis,
            lineModels: [lineModel],
            delayInit: true
        )
        
        // Guidelines layer
        let guidelinesLayerSettings = ChartGuideLinesLayerSettings(
            linesColor: UIColor.black,
            linesWidth: 0.3
        )
        
        let guidelinesLayer = ChartGuideLinesLayer(
            xAxisLayer: xAxisLayer,
            yAxisLayer: yAxisLayer,
            settings: guidelinesLayerSettings
        )
        
        // Touch tracker layer
        let thumbSettings = ChartPointsLineTrackerLayerThumbSettings(thumbSize: 5, thumbBorderWidth: 1)
        let trackerLayerSettings = ChartPointsLineTrackerLayerSettings(thumbSettings: thumbSettings)
        let chartPointsTrackerLayer = ChartPointsLineTrackerLayer<ChartPoint, Any>(
            xAxis: xAxisLayer.axis,
            yAxis: yAxisLayer.axis,
            lines: [chartPoints],
            lineColor: UIColor.black,
            animDuration: 1,
            animDelay: 2,
            settings: trackerLayerSettings
        ) { [weak self] chartPointsWithScreenLoc in
            self?.currentPositionLabels.forEach { $0.removeFromSuperview() }
            for (_, chartPointWithScreenLoc) in chartPointsWithScreenLoc.enumerated() {
                
                let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 50))
                let dateLabel = UILabel()
                let profitLabel = UILabel()
                
                let x: CGFloat
                if chartPointWithScreenLoc.screenLoc.x > chartFrame.width / 2 {
                    x = chartPointWithScreenLoc.screenLoc.x - 38
                    dateLabel.textAlignment = .right
                    profitLabel.textAlignment = .right
                } else {
                    x = chartPointWithScreenLoc.screenLoc.x + 38
                    dateLabel.textAlignment = .left
                    profitLabel.textAlignment = .left
                }
                
                let y: CGFloat
                if chartPointWithScreenLoc.screenLoc.y > 100 {
                    y = chartPointWithScreenLoc.screenLoc.y - 25
                } else {
                    y = chartPointWithScreenLoc.screenLoc.y + 25
                }
            
                containerView.center = CGPoint(
                    x: x,
                    y: y
                )
                
                containerView.layer.borderWidth = 1
                containerView.layer.borderColor = UIColor.systemBlue.cgColor
                containerView.layer.cornerRadius = 4
               
                dateLabel.sizeToFit()
                dateLabel.text = chartPointWithScreenLoc.chartPoint.x.description
                dateLabel.font = .systemFont(ofSize: 12)
                dateLabel.adjustsFontSizeToFitWidth = true
                dateLabel.numberOfLines = 2
                dateLabel.textColor = .systemBlue
               
                profitLabel.sizeToFit()
                profitLabel.text = "\(chartPointWithScreenLoc.chartPoint.y.description)%"
                profitLabel.font = .systemFont(ofSize: 12)
                profitLabel.adjustsFontSizeToFitWidth = true
                profitLabel.numberOfLines = 1
                profitLabel.textColor = .systemBlue
                
                containerView.addSubview(dateLabel)
                dateLabel.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(2)
                    make.trailing.equalToSuperview().offset(-2)
                    make.top.equalToSuperview().offset(2)
                }
                containerView.addSubview(profitLabel)
                profitLabel.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(2)
                    make.trailing.equalToSuperview().offset(-2)
                    make.top.equalTo(dateLabel.snp.bottom).offset(2)
                    make.bottom.equalToSuperview().offset(-2)
                }
                
                self?.currentPositionLabels.append(containerView)
                self?.chartSectionView.addSubview(containerView)
            }
        }
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartPointsLineLayer,
                chartPointsTrackerLayer
            ]
        )
        
        chartSectionView.addSubview(chart.view)
        chartPointsLineLayer.initScreenLines(chart)
        self.chart = chart
    }
    
    private func createChartSettings() -> ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 15
        chartSettings.trailing = 30
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 3
        chartSettings.axisTitleLabelsToLabelsSpacing = 0
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        chartSettings.labelsSpacing = 1
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        chartSettings.zoomPan.maxZoomX = 1
        chartSettings.zoomPan.minZoomX = 1
        chartSettings.zoomPan.minZoomY = 1
        chartSettings.zoomPan.maxZoomY = 1
        return chartSettings
    }
    
    private func createChartPoint(point: PNLCharData) -> ChartPoint {
        ChartPoint(
            x: createDateTimeAxisValue(timestamp: point.timestamp),
            y: ChartAxisValueDouble(point.value)
        )
    }
    
    private func createDateTimeAxisValue(timestamp: Int) -> ChartAxisValue {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return ChartAxisValueDate(date: date, formatter: dateTimeFormatter, labelSettings: xAxisLabelSettings)
    }
    
    private func createDateAxisValue(timestamp: Int) -> ChartAxisValue {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return ChartAxisValueDate(date: date, formatter: dateFormatter, labelSettings: xAxisLabelSettings)
    }
    
    private class ChartYAxisValue: ChartAxisValueDouble {
        override var description: String {
            "\(scalar)%"
        }
    }
}
