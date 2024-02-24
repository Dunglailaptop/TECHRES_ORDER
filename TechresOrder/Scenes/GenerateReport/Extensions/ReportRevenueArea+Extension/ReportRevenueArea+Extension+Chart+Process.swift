//
//  ReportRevenueArea+Extension+Chart+Process.swift
//  Techres-Seemt
//
//  Created by Nguyen Thanh Vinh on 16/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import Charts
import RxSwift

extension ReportRevenueAreaTableViewCell {
    func setRevenueAreaPieChart(dataChart: [AreaRevenueReportData]) {
        
        ChartUtils.customPieChart(
            pieChart: pie_chart,
            dataEntries: dataChart.enumerated().map{(i,value) in PieChartDataEntry(value: Double(value.revenue),label:"")},
            colors: colors,
            holeEnable: true
        )
        pie_chart.legend.enabled = false
        
    }
    
    func setupBarChart(data:[AreaRevenueReportData],barChart:BarChartView){
        

        
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.revenue))},
            xLabel: data.map{$0.area_name},
            color: colors
        )
    }
    
}
