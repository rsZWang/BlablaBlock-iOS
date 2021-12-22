//
//  PNLView.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/23.
//

import UIKit
import SwiftCharts

class PNLView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var chartSectionView: UIView!
    
    private lazy var readFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    private lazy var displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
        
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
        
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
//        let date = { [unowned self] (str: String) -> Date in
//            readFormatter.date(from: str)!
//        }
        
//        let calendar = Calendar.current
        
//        let dateWithComponents = { (day: Int, month: Int, year: Int) -> Date in
//            var components = DateComponents()
//            components.day = day
//            components.month = month
//            components.year = year
//            return calendar.date(from: components)!
//        }
        
        func filler(_ date: Date) -> ChartAxisValueDate {
            let filler = ChartAxisValueDate(date: date, formatter: displayFormatter)
            filler.hidden = true
            return filler
        }
        
        let chartPoints = [
            createChartPoint(dateStr: "01.10.2015", percent: 5, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "04.10.2015", percent: 10, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "05.10.2015", percent: 30, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "06.10.2015", percent: 70, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "08.10.2015", percent: 79, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "10.10.2015", percent: 90, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "12.10.2015", percent: 47, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "14.10.2015", percent: 60, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "15.10.2015", percent: 70, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "16.10.2015", percent: 80, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "19.10.2015", percent: 90, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "21.10.2015", percent: 100, readFormatter: readFormatter, displayFormatter: displayFormatter)
        ]
        
        let yValues = stride(from: 0, through: 100, by: 10)
            .map { ChartAxisValuePercent($0, labelSettings: labelSettings) }
        
        let xValues = [
            createDateAxisValue("01.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("03.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("05.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("07.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("09.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("11.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("13.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("15.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("17.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("19.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter),
            createDateAxisValue("21.10.2015", readFormatter: readFormatter, displayFormatter: displayFormatter)
        ]
        
        let set = ChartLabelSettings(font: .systemFont(ofSize: 0))
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "", settings: set))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "", settings: set))
        let chartFrame = ExamplesDefaults.chartFrame(chartSectionView.bounds)
        
        var chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
        //        chartSettings.leading = 0
        //        chartSettings.trailing = 0
        //        chartSettings.bottom = 50
        
        // Set a fixed (horizontal) scrollable area 2x than the original width, with zooming disabled.
        chartSettings.zoomPan.maxZoomX = 2
        chartSettings.zoomPan.minZoomX = 2
        chartSettings.zoomPan.minZoomY = 1
        chartSettings.zoomPan.maxZoomY = 1
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.red, lineWidth: 2, animDuration: 1, animDelay: 0)
        
        // delayInit parameter is needed by some layers for initial zoom level to work correctly. Setting it to true allows to trigger drawing of layer manually (in this case, after the chart is initialized). This obviously needs improvement. For now it's necessary.
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel], delayInit: true)
        
        let guidelinesLayerSettings = ChartGuideLinesLayerSettings(linesColor: UIColor.black, linesWidth: 0.3)
        let guidelinesLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: guidelinesLayerSettings)
        
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
        
        // Set scrollable area 2x than the original width, with zooming enabled. This can also be combined with e.g. minZoomX to allow only larger zooming levels.
//        chart.zoom(scaleX: 2, scaleY: 1, centerX: 0, centerY: 0)
        
        // Now that the chart is zoomed (either with minZoom setting or programmatic zooming), trigger drawing of the line layer. Important: This requires delayInit paramter in line layer to be set to true.
        chartPointsLineLayer.initScreenLines(chart)
        chartSectionView.addSubview(chart.view)
    }
    
    private func createChartPoint(
        dateStr: String,
        percent: Double,
        readFormatter: DateFormatter,
        displayFormatter: DateFormatter
    ) -> ChartPoint {
        ChartPoint(
            x: createDateAxisValue(dateStr, readFormatter: readFormatter, displayFormatter: displayFormatter),
            y: ChartAxisValuePercent(percent)
        )
    }
    
    private func createDateAxisValue(_ dateStr: String, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartAxisValue {
        let date = readFormatter.date(from: dateStr)!
        let labelSettings = ChartLabelSettings()
        return ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: labelSettings)
    }
    
    class ChartAxisValuePercent: ChartAxisValueDouble {
        override var description: String {
            return "\(formatter.string(from: NSNumber(value: scalar))!)%"
        }
    }
    
}
