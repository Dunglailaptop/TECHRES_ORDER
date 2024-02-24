////
////  ReportRevenueProfitCostTableViewCell+Extension+Chart+Process.swift
////  Techres-Seemt
////
////  Created by Huynh Quang Huy on 12/05/2023.
////  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
////
//
//import UIKit
//import Charts
//
////MARK: CHART HANDLER....
//extension ReportRevenueProfitCostTableViewCell {
//
//    func setupMultiLineChart(revenueCostProfitArray:[RevenueCostProfitReportData], chart:LineChartView,reportType:Int) {
//
//        chart.noDataText = "Chưa có dữ liệu!"
//        chart.noDataFont = UIFont(name: "Helvetica", size: 10.0)!
//        revenueLineItem.removeAll()
//        costLineItem.removeAll()
//        profitLineItem.removeAll()
//        var x_label:[String] = revenueCostProfitArray.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)}
//        revenueLineItem = revenueCostProfitArray.enumerated().map{(i,value) in ChartDataEntry(x: Double(i), y: Double(value.total_revenue))}
//        costLineItem = revenueCostProfitArray.enumerated().map{(i,value) in ChartDataEntry(x: Double(i), y: Double(value.total_cost))}
//        profitLineItem = revenueCostProfitArray.enumerated().map{(i,value) in ChartDataEntry(x: Double(i), y: Double(value.total_profit))}
//
//
//
//        //Line Chart
//        let revenueLine = LineChartDataSet(entries: revenueLineItem, label: "revenue data")
//        revenueLine.setColor(ColorUtils.blue_color())
//        revenueLine.setCircleColor(ColorUtils.blue_color())
//        revenueLine.drawValuesEnabled = false
//        revenueLine.circleRadius = 2
//        revenueLine.drawCirclesEnabled = false
//        revenueLine.mode = .horizontalBezier
//
//
//        let costLine = LineChartDataSet(entries: costLineItem, label: "cost data")
//        costLine.setColor(ColorUtils.red_color())
//        costLine.setCircleColor(ColorUtils.red_color())
//        costLine.drawValuesEnabled = false
//        costLine.circleHoleRadius = 10
//        costLine.circleRadius = 2
//        costLine.drawCirclesEnabled = false
//        costLine.mode = .cubicBezier
//
//
//        let profitLine = LineChartDataSet(entries: profitLineItem,label: "profit data")
//        profitLine.setColor(ColorUtils.green())
//        profitLine.setCircleColor(ColorUtils.green())
//        profitLine.drawValuesEnabled = false
//        profitLine.circleHoleRadius = 10
//        profitLine.circleRadius = 2
//        profitLine.drawCirclesEnabled = false
//        profitLine.mode = .cubicBezier
//
//
//        chart.data = LineChartData(dataSets: [revenueLine,costLine,profitLine])
//        chart.legend.enabled = false
//        chart.chartDescription.enabled = false
//        chart.backgroundColor = UIColor.white
//        chart.leftAxis.drawAxisLineEnabled = true
//        chart.leftAxis.drawGridLinesEnabled = true
//        chart.leftAxis.drawAxisLineEnabled = true
//        chart.leftAxis.axisMinimum = profitLine.yMin - 10 //chỉ có lợi nhuận mới có giá trị âm
//        chart.leftAxis.axisLineWidth = 1
//        chart.leftAxis.granularity = 100
//        chart.rightAxis.enabled = false
//
//
//        chart.xAxis.drawAxisLineEnabled = true
//        chart.xAxis.drawGridLinesEnabled = true
//        chart.xAxis.labelPosition = .bottom
//        chart.xAxis.axisLineWidth = 1
//        chart.xAxis.axisMinimum = -1
//        chart.xAxis.axisMaximum = Double(revenueLineItem.count)
//        chart.xAxis.labelCount = ChartUtils.setLabelCountForChart(reportType: reportType, totalDataPoint: revenueLine.count)
//        chart.xAxis.labelFont = UIFont.systemFont(ofSize: 9)
//
//
//        chart.isUserInteractionEnabled = true
//
//        chart.pinchZoomEnabled = false
//        chart.doubleTapToZoomEnabled = false
//        chart.xAxis.labelRotationAngle = 0// self.chartType == 4 || self.chartType == 3 ? -50 : 0
//        chart.xAxis.labelRotatedHeight = 20
//        chart.animate(xAxisDuration: 2.0, yAxisDuration: 3.0, easingOption: ChartEasingOption.easeInOutQuart)
//
//        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: x_label)
//        chart.leftAxis.valueFormatter = CustomAxisValueFormatter()
//
//        // MARK: Handle click show tooltip
//        // Set the extraTopOffset property to add padding
//        chart.extraTopOffset = 20.0 // Adjust the value as per your requirement
//        let customMarkerView = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
//        chart.marker = customMarkerView
//    }
//
//    private class CustomMarkerView: MarkerView {
//        private let label: UILabel
//
//        override init(frame: CGRect) {
//            // Create a label to display the tooltip text
//            label = UILabel()
//            label.textAlignment = .center
//            label.textColor = ColorUtils.textLabelBlue()
//            label.font = UIFont.boldSystemFont(ofSize: 10)
//            label.backgroundColor = ColorUtils.blueTransparent()
//            label.layer.cornerRadius = 5
//            label.clipsToBounds = true
//
//            super.init(frame: frame)
//
//            // Add the label to the marker view
//            addSubview(label)
//        }
//
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//        // Customization of the tooltip text
//        override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
//            label.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(Int(entry.y)))
//
//            // Adjust the width of the tooltip based on the label's content
//            label.sizeToFit()
//
//            // Update the frame of the tooltip
//            var frame = label.frame
//            frame.size.width += 15 // Add some padding
//            frame.size.height += 10 // Add some vertical padding
//            label.frame = frame
//        }
//
//        // Customization of the tooltip position
//        override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
//            var offset = CGPoint(x: -bounds.size.width / 5 + 5, y: bounds.size.height)
//
//            let chartHeight = super.chartView?.bounds.height ?? 0
//                let minY = bounds.size.height
//                let maxY = chartHeight - bounds.size.height
//
//                if offset.y < minY {
//                    offset.y = minY
//                } else if offset.y > maxY {
//                    offset.y = maxY
//                }
//
//                return offset
//        }
//    }
//}
