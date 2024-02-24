//
//  ReportVATTableViewCell+Extension+Chart+Proccess.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 15/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import Charts

extension ReportVATTableViewCell {
    func setupLineChart(dataChart:[VATReportData],reportType:Int) {

        lineChartItems.removeAll()
                
        lineChartItems = dataChart.enumerated().map{(i,value) in ChartDataEntry(x: Double(i), y: Double(value.amount))}

        var x_label:[String] = dataChart.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)}
        
        ChartUtils.customLineChart(
            chartView: line_chart_view,
            entries: lineChartItems,
            x_label: x_label,
            labelCount: ChartUtils.setLabelCountForChart(reportType: reportType, totalDataPoint: dataChart.count))


        // MARK: Handle click show tooltip
        // Set the extraTopOffset property to add padding
        line_chart_view.extraTopOffset = 30.0 // Adjust the value as per your requirement
        line_chart_view.marker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: 130, height: 40), dataChart: dataChart)

    }


    public class CustomLineChartFormatter: NSObject, ValueFormatter {
        public func stringForValue(_ value: Double, entry: Charts.ChartDataEntry, dataSetIndex: Int, viewPortHandler: Charts.ViewPortHandler?) -> String {
            return String(format: "%@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(value)))
        }
    }

    private class CustomMarkerView: MarkerView {
        private let label1 = UILabel()
        private let label2 = UILabel()
        private let dataChart: [VATReportData]

        init(frame: CGRect, dataChart: [VATReportData]) {

            // Create a label to display the tooltip text
            label1.textAlignment = .left
            label1.textColor = .white
            label1.font = UIFont.boldSystemFont(ofSize: 10)
            label1.backgroundColor = .clear

            label2.textAlignment = .left
            label2.textColor = .white
            label2.font = UIFont.boldSystemFont(ofSize: 10)
            label2.backgroundColor = .clear

            self.dataChart = dataChart

            super.init(frame: frame)
            // Create a containerView to hold the label
            let containerView = UIView()
            containerView.frame = bounds
            containerView.backgroundColor = ColorUtils.blueTransparent008()
            containerView.layer.cornerRadius = 5
            containerView.clipsToBounds = true
            containerView.borderWidth = 1.0
            containerView.borderColor = .black

            containerView.translatesAutoresizingMaskIntoConstraints = false
            label1.translatesAutoresizingMaskIntoConstraints = false
            label2.translatesAutoresizingMaskIntoConstraints = false

            label1.frame = CGRect(x: 5, y: 5, width: bounds.width - 10, height: 15)
            label2.frame = CGRect(x: 5, y: 20, width: bounds.width - 10, height: 15)

            addSubview(containerView)
            containerView.addSubview(label1)
            containerView.addSubview(label2)

        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // Customization of the tooltip text
        override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
            guard let barChartDataEntry = entry as? ChartDataEntry else {
                        return
                    }

            let index = Int(barChartDataEntry.x)
            let quantity = Utils.stringQuantityFormatWithNumber(amount: dataChart[index].amount)
            let amount = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dataChart[index].amount)

            label1.numberOfLines = 0
            label1.lineBreakMode = .byWordWrapping
            label1.text = "Số hoá đơn: \(quantity)"

            label2.numberOfLines = 0
            label2.lineBreakMode = .byWordWrapping
            label2.text = "Tổng tiền: \(amount)"

        }
        // Customization of the tooltip position
        override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
            var offset = CGPoint(x: -bounds.size.width / 2, y: bounds.size.height)

            let chartHeight = super.chartView?.bounds.height ?? 0
                let minY = bounds.size.height
                let maxY = chartHeight - minY

                if offset.y < minY {
                    offset.y = minY
                } else if offset.y > maxY {
                    offset.y = maxY
                }
                return offset
        }
    }
}

