//
//  PNLView.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/23.
//

import UIKit
import SwiftCharts
import SnapKit

public protocol PNLViewDelegate: NSObject {
    func onPeriodFiltered(period: String)
}

final class PNLView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var exchangePickerTextField: UITextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var graphSectionView: UIView!
    @IBOutlet weak var chartSectionView: UIView!
    @IBOutlet weak var roiLabel: UILabel!
    @IBOutlet weak var roiAnnualLabel: UILabel!
    @IBOutlet weak var mddLabel: UILabel!
    @IBOutlet weak var dailyWinRateLabel: UILabel!
    @IBOutlet weak var sharpeRatio: UILabel!
    private lazy var pickerView: PickerView = {
        let pickerView = PickerView()
        pickerView.itemList = PNLPeriod.titleList
        pickerView.pickerViewDelegate = self
        return pickerView
    }()
    private var scrollView: UIScrollView!
    let refreshControl = UIRefreshControl()
    
    weak var delegate: PNLViewDelegate?
    private lazy var displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    private lazy var xAxisLabelSettings = ChartLabelSettings(font: .systemFont(ofSize: 8))
    private lazy var yAxisLabelSettings = ChartLabelSettings(font: .systemFont(ofSize: 8))
    private var chart: Chart!
    private var currentPositionLabels: [UIView] = []
    var semaphore: DispatchSemaphore!
    override var bounds: CGRect {
        didSet {
            DispatchQueue.global().async { [unowned self] in
                semaphore.signal()
            }
        }
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func commonInit() {
        DispatchQueue.global().async { [unowned self] in
            semaphore = DispatchSemaphore(value: 1)
            semaphore.wait()
        }
        loadNibContent()
        pickerView.bind(textField: exchangePickerTextField)
    }
    
    func bind(data: PNLApiData) {
        if data.chartData.compactMap({ $0.value }).isNotEmpty {
            DispatchQueue.global().async { [weak self] in
                self?.semaphore.wait()
                DispatchQueue.main.async {
                    if self?.scrollView == nil {
                        self?.makeRefreshable()
                    }
                    self?.drawChart(data: data)
                }
                self?.semaphore.signal()
            }
        }
        roiLabel.text = "\(data.roi?.toPrettyPrecisedString() ?? "0.0")%"
        roiAnnualLabel.text = "\(data.roiAnnual?.toPrettyPrecisedString() ?? "0.0")%"
        mddLabel.text = "\(data.mdd?.toPrettyPrecisedString() ?? "0.0")%"
        dailyWinRateLabel.text = "\(data.dailyWinRate.toPrettyPrecisedString())%"
        sharpeRatio.text = "\(data.sharpeRatio?.toPrettyPrecisedString() ?? "0.0")"
    }
    
    private func makeRefreshable() {
        scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        containerView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        let contentView = UIView()
        contentView.backgroundColor = .red
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(containerView)
            make.top.bottom.equalToSuperview()
        }
        
        let height = graphSectionView.bounds.height
        graphSectionView.removeFromSuperview()
        contentView.addSubview(graphSectionView)
        graphSectionView.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
}

extension PNLView: PickerViewDelegate {
    func onSelected(index: Int, item: String) {
        delegate?.onPeriodFiltered(period: PNLPeriod.periodList[index])
    }
}

extension PNLView {
    
    func drawChart(data: PNLApiData) {
        
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
