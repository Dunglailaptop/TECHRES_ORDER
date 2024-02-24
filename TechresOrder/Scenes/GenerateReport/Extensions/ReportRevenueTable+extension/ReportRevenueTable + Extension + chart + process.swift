//
//  ReportRevenueTable + Extension + chart + process.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/09/2023.
//

import UIKit
import Charts
import RxSwift

extension ReportRevenueTableTableViewCell {
    func setRevenueAreaPieChart(dataChart: [TableRevenueReportData]) {
        
        ChartUtils.customPieChart(
            pieChart: pie_chart,
            dataEntries: dataChart.enumerated().map{(i,value) in PieChartDataEntry(value: Double(value.revenue),label:"")},
            colors: colors,
            holeEnable: true
        )
        pie_chart.legend.enabled = false
        
    }
    
    func setupBarChart(data:[TableRevenueReportData],barChart:BarChartView){
        
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.revenue))},
            xLabel: data.map{$0.table_name},
            color: colors
        )
        
        
        barChart.isUserInteractionEnabled = true
        // calculate the required height for the chart based on the number of labels and their rotated height
        let labelHeight = barChart.xAxis.labelRotatedHeight // use the rotated label height
        let labelRotationAngle = CGFloat(barChart.xAxis.labelRotationAngle) * .pi / 180 // convert the rotation angle to radians
        let chartHeight = barChart.frame.origin.y + (CGFloat(barChart.xAxis.labelCount) * labelHeight * abs(cos(labelRotationAngle))) // use the rotated height and the cosine of the rotation angle
        // resize the height of the chart view
        barChart.frame.size.height = chartHeight
    }

}
