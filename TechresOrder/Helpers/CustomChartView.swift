//
//  testChart.swift
//  Techres - TMS
//
//  Created by Thanh Phong on 21/09/2021.
//  Copyright © 2021 ALOAPP. All rights reserved.
//

import UIKit
import Charts

class CustomChartView: NSObject, ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(value))
    }
    
    var names = [String]()
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        return names[Int(value)]
        return Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(value))
    }
    
    public func setValues(values: [String]) {
          self.names = values
    }
}
