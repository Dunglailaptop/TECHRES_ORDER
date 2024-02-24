//
//  ReportRevenueGeneralTableViewCell+Extension+Chart+Proccess.swift
//  Techres-Seemt
//
//  Created by macmini_techres_04 on 13/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import Charts

extension ReportRevenueGeneralTableViewCell {
    
    func setupBarChart(dataChart: [SaleReportData],reportType:Int){
        
        bar_chart.noDataText = "Chưa có dữ liệu !!"
        
        var barChartItems = [BarChartDataEntry]()
        
        //Chart Data
        for (index,_) in dataChart.enumerated() {
            barChartItems.append(BarChartDataEntry(x: Double(index), y: Double(dataChart[index].total_revenue)))
        }
        
        //Bar Chart
        let barChartDataSet = BarChartDataSet(entries: barChartItems, label: "")
        barChartDataSet.setColors(ColorUtils.blue())
        barChartDataSet.drawValuesEnabled = false
        barChartDataSet.drawIconsEnabled = false
        bar_chart.data = BarChartData(dataSet: barChartDataSet)
        
        bar_chart.legend.enabled = false
        bar_chart.chartDescription.enabled = false
        bar_chart.backgroundColor = UIColor.white
        bar_chart.leftAxis.drawAxisLineEnabled = true
        bar_chart.leftAxis.drawGridLinesEnabled = true
        bar_chart.leftAxis.axisMinimum = 0
        bar_chart.rightAxis.enabled = false
        bar_chart.xAxis.drawAxisLineEnabled = false
        bar_chart.xAxis.labelPosition = .bottom
        bar_chart.xAxis.drawGridLinesEnabled = true
        bar_chart.xAxis.axisMinimum = -1
        bar_chart.xAxis.axisMaximum = Double(barChartItems.count)
        bar_chart.xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        bar_chart.animate(xAxisDuration: 2.0, yAxisDuration: 3.0, easingOption: ChartEasingOption.easeInOutQuart)
        bar_chart.pinchZoomEnabled = false
        bar_chart.doubleTapToZoomEnabled = false
        bar_chart.xAxis.labelRotationAngle = -27
        bar_chart.xAxis.labelRotatedHeight = 35
        
        bar_chart.isUserInteractionEnabled = true
//        bar_chart.scaleXEnabled = true
//        bar_chart.scaleYEnabled = true

        var x_label = [String]()
        for i in 0 ..< dataChart.count {
            if dataChart[i].report_time != "" {
                x_label.append(ChartUtils.getXLabel(dateTime: dataChart[i].report_time, reportType: reportType, dataPointnth:i))
            }
        }

        bar_chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: x_label)
        bar_chart.leftAxis.valueFormatter = CustomAxisValueFormatter()
        
        // MARK: Handle click show tooltip
        // Set the extraTopOffset property to add padding
        bar_chart.extraTopOffset = 30.0 // Adjust the value as per your requirement
        bar_chart.marker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: 130, height: 40), dataChart: dataChart)
        bar_chart.data = BarChartData(dataSet: barChartDataSet)
    }
    
    private class CustomMarkerView: MarkerView {
        private let label1 = UILabel()
        private let label2 = UILabel()
        private let dataChart: [SaleReportData]
        
        init(frame: CGRect, dataChart: [SaleReportData]) {
            
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
            guard let barChartDataEntry = entry as? BarChartDataEntry else {
                        return
                    }
            
            let index = Int(barChartDataEntry.x)
            let quantity = Utils.stringQuantityFormatWithNumber(amount: dataChart[index].total_order)
            let amount = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(dataChart[index].total_revenue))
            
            label1.numberOfLines = 0
            label1.lineBreakMode = .byWordWrapping
            label1.text = "Số lượng: \(quantity)"
            
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
