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
    
    var chart: Chart? // arc
        
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
        
        let fontSize: CGFloat = 11
        let labelSettings = ChartLabelSettings(font: UIFont(name: "Helvetica", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize))

        let chartPoints = [(2, 2), (4, 4), (7, 1), (8, 11), (12, 3)].map {
            ChartPoint(
                x: ChartAxisValueDouble($0.0, labelSettings: labelSettings),
                y: ChartAxisValueDouble($0.1)
            )
        }
        
        let chartPoints2 = [(2, 3), (3, 1), (5, 6), (7, 2), (8, 14), (12, 6)].map {
            ChartPoint(
                x: ChartAxisValueDouble($0.0, labelSettings: labelSettings),
                y: ChartAxisValueDouble($0.1)
            )
        }
        
        let xValues = chartPoints.map { $0.x }
        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(
            chartPoints,
            minSegmentCount: 10,
            maxSegmentCount: 20,
            multiple: 2,
            axisValueGenerator: {
                ChartAxisValueDouble($0, labelSettings: labelSettings)
            },
            addPaddingSegmentIfEdge: false
        )
        
        let xModel = ChartAxisModel(
            axisValues: xValues,
            axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings)
        )
        let yModel = ChartAxisModel(
            axisValues: yValues,
            axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical())
        )
        let chartFrame = ExamplesDefaults.chartFrame(chartSectionView.bounds)
        
        let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom

        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(
            chartSettings: chartSettings,
            chartFrame: chartFrame,
            xModel: xModel,
            yModel: yModel
        )
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.red, animDuration: 1, animDelay: 0)
        let lineModel2 = ChartLineModel(chartPoints: chartPoints2, lineColor: UIColor.blue, animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(
            xAxis: xAxisLayer.axis,
            yAxis: yAxisLayer.axis,
            lineModels: [lineModel, lineModel2],
            useView: false
        )
        
        let thumbSettings = ChartPointsLineTrackerLayerThumbSettings(thumbSize: Env.iPad ? 20 : 10, thumbBorderWidth: Env.iPad ? 4 : 2)
        let trackerLayerSettings = ChartPointsLineTrackerLayerSettings(thumbSettings: thumbSettings)
        
        var currentPositionLabels: [UILabel] = []
        
        let chartPointsTrackerLayer = ChartPointsLineTrackerLayer<ChartPoint, Any>(
            xAxis: xAxisLayer.axis,
            yAxis: yAxisLayer.axis,
            lines: [chartPoints, chartPoints2],
            lineColor: UIColor.black, animDuration: 1, animDelay: 2, settings: trackerLayerSettings
        ) { chartPointsWithScreenLoc in
            
            currentPositionLabels.forEach { $0.removeFromSuperview() }
            for (index, chartPointWithScreenLoc) in chartPointsWithScreenLoc.enumerated() {
                let label = UILabel()
                label.text = chartPointWithScreenLoc.chartPoint.description
                label.sizeToFit()
                label.center = CGPoint(x: chartPointWithScreenLoc.screenLoc.x + label.frame.width / 2, y: chartPointWithScreenLoc.screenLoc.y + chartFrame.minY - label.frame.height / 2)
                
                label.backgroundColor = index == 0 ? UIColor.red : UIColor.blue
                label.textColor = UIColor.white
                
                currentPositionLabels.append(label)
                self.chartSectionView.addSubview(label)
            }
        }
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
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
        self.chart = chart
    }
    
//    private func createChartPoint(
//        dateStr: String,
//        percent: Double,
//        readFormatter: DateFormatter,
//        displayFormatter: DateFormatter
//    ) -> ChartPoint {
//        ChartPoint(
//            x: createDateAxisValue(dateStr, readFormatter: readFormatter, displayFormatter: displayFormatter),
//            y: ChartAxisValuePercent(percent)
//        )
//    }
//
//    private func createDateAxisValue(_ dateStr: String, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartAxisValue {
//        let date = readFormatter.date(from: dateStr)!
//        let labelSettings = ChartLabelSettings()
//        return ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: labelSettings)
//    }
//
//    class ChartAxisValuePercent: ChartAxisValueDouble {
//        override var description: String {
//            return "\(formatter.string(from: NSNumber(value: scalar))!)%"
//        }
//    }
    
}
