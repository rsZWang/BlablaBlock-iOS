//
//  PNLView.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/23.
//

import UIKit
import SwiftCharts
import SnapKit

class PNLView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var chartSectionView: UIView!
    
    private lazy var readFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    private lazy var displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    private lazy var xAxisLabelSettings = ChartLabelSettings(font: .systemFont(ofSize: 8))
    private lazy var yAxisLabelSettings = ChartLabelSettings(font: .systemFont(ofSize: 8))
    private var chart: Chart!
        
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
        loadNibContent()
    }
    
    func drawChart() {
        
        let chartPoints = [
            createChartPoint(dateStr: "01.10.2015", percent: 5),
            createChartPoint(dateStr: "04.10.2015", percent: 10),
            createChartPoint(dateStr: "05.10.2015", percent: 30),
            createChartPoint(dateStr: "06.10.2015", percent: 70),
            createChartPoint(dateStr: "08.10.2015", percent: 79),
            createChartPoint(dateStr: "10.10.2015", percent: 90),
            createChartPoint(dateStr: "12.10.2015", percent: 47),
            createChartPoint(dateStr: "14.10.2015", percent: 60),
            createChartPoint(dateStr: "15.10.2015", percent: 70),
            createChartPoint(dateStr: "16.10.2015", percent: 80),
            createChartPoint(dateStr: "19.10.2015", percent: 90),
            createChartPoint(dateStr: "21.10.2015", percent: 100)
        ]

        let xValues = [
            createDateAxisValue("01.10.2015"),
            createDateAxisValue("03.10.2015"),
            createDateAxisValue("05.10.2015"),
            createDateAxisValue("07.10.2015"),
            createDateAxisValue("09.10.2015"),
            createDateAxisValue("11.10.2015"),
            createDateAxisValue("13.10.2015"),
            createDateAxisValue("15.10.2015"),
            createDateAxisValue("17.10.2015"),
            createDateAxisValue("19.10.2015"),
            createDateAxisValue("21.10.2015")
        ]
        let xModel = ChartAxisModel(axisValues: xValues)
        
        let yValues = stride(from: 0, through: 100, by: 10).map { ChartAxisValuePercent($0, labelSettings: yAxisLabelSettings) }
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
            lineColor: UIColor.red,
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
        
        let guidelinesLayerSettings = ChartGuideLinesLayerSettings(linesColor: UIColor.black, linesWidth: 0.3)
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
        chartSettings.zoomPan.maxZoomX = 3
        chartSettings.zoomPan.minZoomX = 3
        chartSettings.zoomPan.minZoomY = 1
        chartSettings.zoomPan.maxZoomY = 1
        return chartSettings
    }
    
    private func createChartPoint(dateStr: String, percent: Double) -> ChartPoint {
        ChartPoint(
            x: createDateAxisValue(dateStr),
            y: ChartAxisValuePercent(percent)
        )
    }
    
    private func createDateAxisValue(_ dateStr: String) -> ChartAxisValue {
        let date = readFormatter.date(from: dateStr)!
        return ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: xAxisLabelSettings)
    }
    
    class ChartAxisValuePercent: ChartAxisValueDouble {
        override var description: String {
            return "\(formatter.string(from: NSNumber(value: scalar))!)%"
        }
    }
    
}
