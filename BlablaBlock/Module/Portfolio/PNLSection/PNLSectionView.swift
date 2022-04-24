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

final class PNLSectionView: UIView {
    
    private let disposeBag = DisposeBag()
    weak var viewModel: PortfolioViewModelType?
    
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
        displayFormatter.dateFormat = "yyyy/MM/dd"
        
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        
        separatorView.backgroundColor = .black2D2D2D
        
        roiTitleLabel.text = "總報酬率"
        setupLabel(roiTitleLabel)
        setupLabel(roiLabel)
        
        roiAnnualTitleLabel.text = "年化報酬率"
        setupLabel(roiAnnualTitleLabel)
        setupLabel(roiAnnualLabel)
        
        mddTitleLabel.text = "最大回撤"
        setupLabel(mddTitleLabel)
        setupLabel(mddLabel)
        
        dailyWinRateTitleLabel.text = "每日勝率"
        setupLabel(dailyWinRateTitleLabel)
        setupLabel(dailyWinRateLabel)
        
        sharpeRatioTitleLabel.text = "Sharp ratio"
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
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
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

        textSectionView.addSubview(dailyWinRateTitleLabel)
        dailyWinRateTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(mddTitleLabel.snp.bottom).offset(8)
        }

        textSectionView.addSubview(dailyWinRateLabel)
        dailyWinRateLabel.snp.makeConstraints { make in
            make.top.equalTo(mddLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
        }

        textSectionView.addSubview(sharpeRatioTitleLabel)
        sharpeRatioTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(dailyWinRateTitleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }

        textSectionView.addSubview(sharpeRatioLabel)
        sharpeRatioLabel.snp.makeConstraints { make in
            make.top.equalTo(dailyWinRateLabel.snp.bottom).offset(8)
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
    private let periodPickerView = BlablaBlockPickerView()
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
    private let dailyWinRateTitleLabel = UILabel()
    private let dailyWinRateLabel = UILabel()
    private let sharpeRatioTitleLabel = UILabel()
    private let sharpeRatioLabel = UILabel()
    
    private let displayFormatter = DateFormatter()
    private var chart: Chart!
    private var currentPositionLabels: [UIView] = []
    private let xAxisLabelSettings = ChartLabelSettings(font: .systemFont(ofSize: 8))
    private let yAxisLabelSettings = ChartLabelSettings(font: .systemFont(ofSize: 8))
}

extension PNLSectionView: PickerViewDelegate {
    public func pickerView(_ pickerView: PickerView, selectedIndex: Int, selectedItem: String) {
        guard let viewModel = viewModel else { return }
        
        if let period = PNLPeriod.init(rawValue: selectedItem) {
            viewModel.inputs
                .pnlPeriod.accept(period)
        }
    }
}


extension PNLSectionView {
    
    func bind(data: PNLApiData) {
//        if data.chartData.compactMap({ $0.value }).isNotEmpty {
//            DispatchQueue.global().async { [weak self] in
//                self?.semaphore.wait()
//                DispatchQueue.main.async {
//                    if self?.scrollView == nil {
//                        self?.makeRefreshable()
//                    }
//                    self?.drawChart(data: data)
//                }
//                self?.semaphore.signal()
//            }
//        }
        roiLabel.text = "\(data.roi?.toPrettyPrecisedString() ?? "0.0")%"
        roiAnnualLabel.text = "\(data.roiAnnual?.toPrettyPrecisedString() ?? "0.0")%"
        mddLabel.text = "\(data.mdd?.toPrettyPrecisedString() ?? "0.0")%"
        dailyWinRateLabel.text = "\(data.dailyWinRate?.toPrettyPrecisedString() ?? "0.0")%"
        sharpeRatioLabel.text = "\(data.sharpeRatio?.toPrettyPrecisedString() ?? "0.0")"
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
        let bounds = chartSectionView.bounds
        let chartFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        
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
        let thumbSettings = ChartPointsLineTrackerLayerThumbSettings(thumbSize: 10, thumbBorderWidth: 1)
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
                let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 69, height: 30))
                stackView.sizeToFit()
                stackView.layer.borderWidth = 1
                stackView.layer.borderColor = UIColor.systemBlue.cgColor
                stackView.layer.cornerRadius = 4
                stackView.axis = .vertical
                stackView.center = CGPoint(
                    x: chartPointWithScreenLoc.screenLoc.x + stackView.frame.width / 2,
                    y: chartPointWithScreenLoc.screenLoc.y + chartFrame.minY - stackView.frame.height / 2
                )
                
                let dateLabel = UILabel()
                dateLabel.sizeToFit()
                dateLabel.text = " \(chartPointWithScreenLoc.chartPoint.x.description) "
                dateLabel.font = .systemFont(ofSize: 12)
                dateLabel.adjustsFontSizeToFitWidth = true
                dateLabel.numberOfLines = 1
                dateLabel.textColor = .systemBlue
                stackView.addArrangedSubview(dateLabel)
                
                let profitLabel = UILabel()
                profitLabel.sizeToFit()
                profitLabel.text = " \(chartPointWithScreenLoc.chartPoint.y.description)% "
                profitLabel.font = .systemFont(ofSize: 12)
                profitLabel.adjustsFontSizeToFitWidth = true
                profitLabel.numberOfLines = 1
                profitLabel.textColor = .systemBlue
                stackView.addArrangedSubview(profitLabel)
                self?.currentPositionLabels.append(stackView)
                self?.chartSectionView.addSubview(stackView)
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
            x: createDateAxisValue(timestamp: point.timestamp),
            y: ChartAxisValueDouble(point.value)
        )
    }
    
    private func createDateAxisValue(timestamp: Int) -> ChartAxisValue {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: xAxisLabelSettings)
    }
    
    private class ChartYAxisValue: ChartAxisValueDouble {
        override var description: String {
            "\(scalar)%"
        }
    }
}
