//
//  PNLView.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/23.
//

import UIKit
import SwiftCharts
import SnapKit

protocol PNLViewDelegate: NSObject {
    func onPeriodFiltered(period: String)
}

class PNLView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var exchangePickerTextField: UITextField!
    @IBOutlet weak var chartSectionView: UIView!
    @IBOutlet weak var roiLabel: UILabel!
    @IBOutlet weak var roiAnnualLabel: UILabel!
    @IBOutlet weak var mddLabel: UILabel!
    @IBOutlet weak var dailyWinRateLabel: UILabel!
    @IBOutlet weak var sharpeRatio: UILabel!
    private lazy var pickerView: PickerView = {
        let pickerView = PickerView()
        pickerView.itemList = PNLPeriod.periodTitleList
        pickerView.pickerViewDelegate = self
        return pickerView
    }()
    
    weak var delegate: PNLViewDelegate?
    private lazy var displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    private lazy var xAxisLabelSettings = ChartLabelSettings(font: .systemFont(ofSize: 8))
    private lazy var yAxisLabelSettings = ChartLabelSettings(font: .systemFont(ofSize: 8))
    private var chart: Chart!
    private let semaphore = DispatchSemaphore(value: 1)
    override var bounds: CGRect {
        didSet {
            semaphore.signal()
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
        semaphore.wait()
        loadNibContent()
        pickerView.bind(textField: exchangePickerTextField)
    }
    
    func bind(data: PNLData) {
        DispatchQueue.global().async { [unowned self] in
            semaphore.wait()
            DispatchQueue.main.async {
                drawChart(data: data)
            }
            semaphore.signal()
        }
        roiLabel.text = "\(data.roi.toPrettyPrecisedString())%"
        roiAnnualLabel.text = "\(data.roiAnnual.toPrettyPrecisedString())%"
        mddLabel.text = "\(data.mdd.toPrettyPrecisedString())%"
        dailyWinRateLabel.text = "\(data.dailyWinRate.toPrettyPrecisedString())%"
        sharpeRatio.text = "\(data.sharpeRatio.toPrettyPrecisedString())"
    }
    
}

extension PNLView: PickerViewDelegate {
    func onSelected(index: Int, item: String) {
        delegate?.onPeriodFiltered(period: PNLPeriod.periodList[index])
    }
}

extension PNLView {
    
    func drawChart(data: PNLData) {
        
        if let chart = chart {
            chart.view.removeFromSuperview()
            self.chart = nil
        }
        
        let dataList = data.getChartDataList()
        
        var chartPoints = [ChartPoint]()
        
        for entry in dataList {
            chartPoints.append(createChartPoint(timestamp: entry.timestamp, value: entry.value))
        }
        
        let minX = data.getMinX()
        let maxX = data.getMaxX()
        let diff = maxX - minX
        let distance = Int(Double(diff)/5)
        
        var xValues = [ChartAxisValue]()
        for i in stride(from: minX, through: maxX, by: distance) {
            xValues.append(createDateAxisValue(timestamp: i))
        }
        if xValues.count == 5 {
            xValues.append(createDateAxisValue(timestamp: maxX + distance))
        }
        let xModel = ChartAxisModel(axisValues: xValues)
        
        let minY = Int(ceil(data.getMinY()))
        let maxY = Int(ceil(data.getMaxY()))
        
        
        let yValues = stride(from: minY, through: maxY, by: 1).map { ChartYAxisValue($0, labelSettings: yAxisLabelSettings) }
        let yModel = ChartAxisModel(axisValues: yValues)
        
        let bounds = chartSectionView.bounds
        let chartFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        let chartSettings = createChartSettings()

        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(
            chartSettings: chartSettings,
            chartFrame: chartFrame,
            xModel: xModel,
            yModel: yModel
        )
        
        let lineModel = ChartLineModel(
            chartPoints: chartPoints,
            lineColor: .red,
            lineWidth: 2,
            animDuration: 1,
            animDelay: 0
        )
        
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        // delayInit parameter is needed by some layers for initial zoom level to work correctly. Setting it to true allows to trigger drawing of layer manually (in this case, after the chart is initialized). This obviously needs improvement. For now it's necessary.
        let chartPointsLineLayer = ChartPointsLineLayer(
            xAxis: xAxisLayer.axis,
            yAxis: yAxisLayer.axis,
            lineModels: [lineModel],
            delayInit: true
        )
        
        let guidelinesLayerSettings = ChartGuideLinesLayerSettings(
            linesColor: UIColor.black,
            linesWidth: 0.3
        )
        
        let guidelinesLayer = ChartGuideLinesLayer(
            xAxisLayer: xAxisLayer,
            yAxisLayer: yAxisLayer,
            settings: guidelinesLayerSettings
        )
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartPointsLineLayer
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
    
    private func createChartPoint(timestamp: Int, value: Double) -> ChartPoint {
        ChartPoint(
            x: createDateAxisValue(timestamp: timestamp),
            y: ChartAxisValueDouble(value)
        )
    }
    
    private func createDateAxisValue(timestamp: Int) -> ChartAxisValue {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: xAxisLabelSettings)
    }
    
    private class ChartYAxisValue: ChartAxisValueDouble {
        override var description: String {
            "\(NSNumber(value: scalar))%"
        }
    }
    
}
