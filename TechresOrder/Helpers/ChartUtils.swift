//
//  ChartUtils.swift
//  Techres - TMS
//
//  Created by Thanh Phong on 05/08/2021.
//  Copyright © 2021 ALOAPP. All rights reserved.
//  Updated by Phạm Khánh 16/09/2023

import UIKit
import Charts

class ChartUtils: NSObject {
    static func customLineChart(chartView : LineChartView, entries: [ChartDataEntry],x_label:[String],labelCount:Int) {
        
    
        chartView.noDataText = "Chưa có dữ liệu!"

        //Line Chart
        let lineChartDataSet = LineChartDataSet(entries: entries, label: "")
        lineChartDataSet.setColor(ColorUtils.blue_color())
        lineChartDataSet.setCircleColor(ColorUtils.blue_color())
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.circleRadius = 2
        
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.fillColor = ColorUtils.blue_brand_400()
        lineChartDataSet.fillAlpha = 0.7
        lineChartDataSet.mode = .cubicBezier
        
        chartView.data = LineChartData(dataSet: lineChartDataSet)
        
        chartView.legend.enabled = false
        chartView.chartDescription.enabled = false
        chartView.backgroundColor = UIColor.white
        chartView.leftAxis.drawAxisLineEnabled = true
        chartView.leftAxis.drawGridLinesEnabled = true
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.axisLineWidth = 1
        chartView.leftAxis.valueFormatter = CustomAxisValueFormatter() // Thêm valueFormatter
        
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.drawAxisLineEnabled = true
        chartView.xAxis.drawGridLinesEnabled = true
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.axisMinimum = -1
        chartView.xAxis.axisMaximum = Double(entries.count)
        chartView.xAxis.labelCount = labelCount
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 9)
        chartView.xAxis.axisLineWidth = 1
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: x_label)
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false

        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 3.0, easingOption: ChartEasingOption.easeInOutQuart)
 
    }
    

    
    static func customPieChart(pieChart : PieChartView, dataEntries: [PieChartDataEntry],colors:[UIColor],chartTitle:String="",holeEnable:Bool=false) {
        
        pieChart.noDataText = NSLocalizedString("Data not available", comment: "")

        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: chartTitle)
        pieChartDataSet.colors = colors
        pieChartDataSet.sliceSpace = 4
        pieChartDataSet.selectionShift = 1
        pieChartDataSet.xValuePosition = .outsideSlice
        pieChartDataSet.yValuePosition = .outsideSlice

        pieChartDataSet.valueLineWidth = 0.5
        pieChartDataSet.valueLinePart1Length = 0.1
        pieChartDataSet.valueLinePart2Length = 0.2
        
        pieChartDataSet.valueTextColor = .white
        pieChartDataSet.drawValuesEnabled = false
        pieChartDataSet.drawIconsEnabled = false
        
        

//        let formatter = NumberFormatter()
//        formatter.numberStyle = .percent
//        formatter.maximumFractionDigits = 1
//        formatter.multiplier = 1
//        formatter.percentSymbol = " %"
//        let bvform = DefaultValueFormatter(formatter: formatter)
//
//        pieChartDataSet.valueFormatter = bvform
        
        
        

        pieChart.data = PieChartData(dataSet: pieChartDataSet)
        pieChart.drawSlicesUnderHoleEnabled = false
        pieChart.holeRadiusPercent = 0.5
        pieChart.transparentCircleRadiusPercent = 0.61
        pieChart.chartDescription.enabled = false
        pieChart.setExtraOffsets(left: -30, top: 0, right: 30, bottom: 0)
        
        pieChart.drawHoleEnabled = holeEnable
        pieChart.drawCenterTextEnabled = true
               
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center

        let centerText = NSMutableAttributedString(string: Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(dataEntries.map{$0.value}.reduce(0.0, +))))

        centerText.addAttributes([.font : UIFont.systemFont(ofSize: 14,weight: .bold),
                                  .foregroundColor : ColorUtils.green_600()],
                             range: NSRange(location: 0, length: centerText.length))

        pieChart.centerAttributedText = centerText;
     
        pieChart.rotationAngle = 0
        pieChart.rotationEnabled = true
        pieChart.highlightPerTapEnabled = true
        
        pieChart.legend.enabled = true
        pieChart.legend.drawInside = false
        pieChart.legend.horizontalAlignment = .right
        pieChart.legend.verticalAlignment = .center
        pieChart.legend.orientation = .vertical
        //form là icon trong bản chỉ dẫn
        pieChart.legend.form = .circle
        pieChart.legend.formSize = 10
        //% diện tích của pieChart bản chỉ dẫn .maxSizePercent = 0.2 (legend = 0.2, piechart = 0.8)
        pieChart.legend.maxSizePercent = 0.2
    
        pieChart.legend.xEntrySpace = 100
        pieChart.legend.yEntrySpace = 5
        pieChart.legend.yOffset = 10
        pieChart.legend.xOffset = 0
        pieChart.drawEntryLabelsEnabled = false
        pieChart.marker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        /*
            pieChart.legend.getMaximumEntrySize(withFont: UIFont.systemFont(ofSize: 10)).height => lấy ra được chiều cao của đoạn text trong legend
            CGFloat(5*revenues.count), trong đó 5 = legend.yEntrySpace
         */
//        let heightLegend =  pieChart.legend.getMaximumEntrySize(withFont: UIFont.systemFont(ofSize: 10)).height*CGFloat(revenues.count) + CGFloat(5*revenues.count)
//        if heightLegend > piechart.frame.height{//nếu chiều cao của legend > chiều cao của piechart thì ta mở rộng ra, và lấy dư 20pixel
//            let pieChartHeight = ceil(pieChart.legend.getMaximumEntrySize(withFont: UIFont.systemFont(ofSize: 10)).height)*CGFloat(revenues.count) + CGFloat(5*revenues.count) + 20
//            height_of_pie_chart.constant = pieChartHeight
//        }
        pieChart.notifyDataSetChanged()
      }
    
    
    
    static func customBarChart(chartView : BarChartView,barChartItems:[BarChartDataEntry],xLabel:[String]=[],color:[UIColor]?=nil,drawValuesOnDataSet:Bool=false) {
        chartView.noDataText = "Chưa có dữ liệu !!"
        //Bar Chart
        let barChartDataSet = BarChartDataSet(entries: barChartItems, label: "")
        barChartDataSet.valueColors = [ColorUtils.green_600(),ColorUtils.red_400(),ColorUtils.orange_brand_900()]
        barChartDataSet.valueFont = UIFont.systemFont(ofSize: 9, weight: .semibold)
        barChartDataSet.valueFormatter = CustomValueFormater()
        color != nil ? barChartDataSet.setColors(color!,alpha: 1) : barChartDataSet.setColors(ColorUtils.blue_brand_700()) 
        
    
        barChartDataSet.drawValuesEnabled = drawValuesOnDataSet
        barChartDataSet.drawIconsEnabled = false
        chartView.data = BarChartData(dataSet: barChartDataSet)
        

        
        chartView.legend.enabled = false
        chartView.chartDescription.enabled = false
        chartView.backgroundColor = UIColor.white
        chartView.leftAxis.drawAxisLineEnabled = true
        chartView.leftAxis.drawGridLinesEnabled = true
        chartView.leftAxis.axisLineWidth = 1
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.valueFormatter = CustomAxisValueFormatter()
        
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        chartView.xAxis.drawAxisLineEnabled = true
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.axisLineWidth = 1
        chartView.xAxis.axisMinimum = -1
        chartView.xAxis.axisMaximum = Double(barChartItems.count)
        chartView.xAxis.labelRotationAngle = -27
        chartView.xAxis.labelRotatedHeight = 35
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xLabel)
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 3.0, easingOption: ChartEasingOption.easeInOutQuart)
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        
        
        let visibleXRange = 8 // Number of values to show in y-Axis
        chartView.setVisibleXRangeMaximum(Double(visibleXRange))
        chartView.xAxis.setLabelCount(visibleXRange, force: false)
        chartView.xAxis.granularity = 1
        chartView.xAxis.labelCount = visibleXRange
        chartView.dragEnabled = true
     
        
        // MARK: Handle click show tooltip
        // Set the extraTopOffset property to add padding
        chartView.extraTopOffset = 30.0 // Adjust the value as per your requirement
        chartView.marker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: 80, height: 30))

    }

    
    ////variable  dataPointnth is used to get label for the report type of week
    static func getXLabel(dateTime:String, reportType:Int, dataPointnth:Int) -> String {
        var x_label = ""
        let datetimeSeparator = dateTime.components(separatedBy: [" "])

            switch(reportType){
                case REPORT_TYPE_TODAY:
                let substringTime = datetimeSeparator[1].components(separatedBy: [":"])
                    x_label = String(format: "%@:00", substringTime.first!)
         
                case REPORT_TYPE_YESTERDAY:
                let substringTime = datetimeSeparator[1].components(separatedBy: [":"])
                    x_label = String(format: "%@:00", substringTime.first!)
                
                case REPORT_TYPE_THIS_WEEK:
                    switch dataPointnth {
                        case 0:
                            x_label = "Thứ 2"
                            break
                        case 1:
                            x_label = "Thứ 3"
                            break
                        case 2:
                            x_label = "Thứ 4"
                            break
                        case 3:
                            x_label = "Thứ 5"
                            break
                        case 4:
                            x_label = "Thứ 6"
                            break
                        case 5:
                            x_label = "Thứ 7"
                            break
                        default:
                            x_label = "Chủ nhật"
                    }
                    break
                
                case REPORT_TYPE_LAST_MONTH:
                    let datetimeSeparator = dateTime.components(separatedBy: [" "])
                    let substringDate = datetimeSeparator[0].components(separatedBy: ["-"])
                    
                    x_label = String(format: "%@/%@", substringDate[2], substringDate[1])
                    break
                
                case REPORT_TYPE_THIS_MONTH:
                    let datetimeSeparator = dateTime.components(separatedBy: [" "])
                    let substringDate = datetimeSeparator[0].components(separatedBy: ["-"])

                    x_label = String(format: "%@/%@", substringDate[2], substringDate[1])
                    break
                
                case REPORT_TYPE_THREE_MONTHS:
                    let datetimeSeparator = dateTime.components(separatedBy: [" "])
                    let substringDate = datetimeSeparator[0].components(separatedBy: ["-"])
                    dLog(dateTime)
                    x_label = String(format: "%@/%@", substringDate[2],substringDate[1])
                    break
                
                case REPORT_TYPE_THIS_YEAR:
                    let datetimeSeparator = dateTime.components(separatedBy: [" "])
                    let substringDate = datetimeSeparator[0].components(separatedBy: ["-"])

                    x_label = String(format: "%@", substringDate[1])
                    break
                
                case REPORT_TYPE_LAST_YEAR:
                    let datetimeSeparator = dateTime.components(separatedBy: [" "])
                    let substringDate = datetimeSeparator[0].components(separatedBy: ["-"])

                    x_label = String(format: "%@", substringDate[1])
                    break
                
                case REPORT_TYPE_THREE_YEAR:
                    let datetimeSeparator = dateTime.components(separatedBy: [" "])
                    let substringDate = datetimeSeparator[0].components(separatedBy: ["-"])

                    x_label = String(format: "%@/%@", substringDate[1], substringDate[0])
                    break
                
                case REPORT_TYPE_ALL_YEAR:
                    let datetimeSeparator = dateTime.components(separatedBy: [" "])
                    let substringDate = datetimeSeparator[0].components(separatedBy: ["-"])

                    x_label.append(String(format: "%@",substringDate[0]))
                    break
                
                default:
                    break
            }
        
        return x_label
        
    }
    
    
    static func setLabelCountForChart(reportType:Int,totalDataPoint:Int) -> Int{
        
        switch reportType {
            case REPORT_TYPE_TODAY:
                return (totalDataPoint)/3
            
            case REPORT_TYPE_YESTERDAY:
                return (totalDataPoint)/3
            
            case REPORT_TYPE_THIS_WEEK:
                return totalDataPoint
            
            case REPORT_TYPE_THIS_MONTH:
                return (totalDataPoint)/4
            
            case REPORT_TYPE_LAST_MONTH:
                return (totalDataPoint)/4
            
            case REPORT_TYPE_THREE_MONTHS:
                return (totalDataPoint)/11
            
            case REPORT_TYPE_THIS_YEAR:
                return (totalDataPoint)
            
            case REPORT_TYPE_LAST_YEAR:
                return (totalDataPoint)
            
            case REPORT_TYPE_THREE_YEAR:
                return (totalDataPoint)/5
            
            case REPORT_TYPE_ALL_YEAR:
                return (totalDataPoint)
            
            default:
                return totalDataPoint
        }

    }
    
    
    
    
    
    
    
    
    
}


public class CustomAxisValueFormatter: NSObject, AxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        var yValue = value/1000
        if(yValue >= 0 && yValue < 1000 ){
            return String(format: "%@ K", Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: yValue))
        }else if(yValue >= 1000 && yValue < 1000000 ){
            return String(format: "%@ Tr", Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: yValue/1000))
        }else if(yValue >= 1000000){
            return String(format: "%@ Tỷ", Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: yValue/1000000))
        }
        else if(value < 0 && value > -1000) {
            return String(format: "%@", Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: value))
        }else if(value <= -1000 && value > -1000000 ){
            return String(format: "%@ Ng", Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: value/1000))
        }else if(value <= -1000000){
            return String(format: "%@ Tr", Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: value/1000000))
        }else if(value <= -1000000000){
            return String(format: "%@ Tỷ", Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: value/1000000000))
        }
        return String(format: "%@", Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: yValue))
        
    }
}

private class CustomValueFormater:ValueFormatter{
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return Utils.stringVietnameseMoneyFormatWithNumberDouble(amount:value)
    }

}




private class CustomMarkerView: MarkerView {
    private let label: UILabel

    override init(frame: CGRect) {
        // Create a label to display the tooltip text
        label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.backgroundColor = ColorUtils.blueTransparent008()
        label.layer.cornerRadius = 5
        label.clipsToBounds = true

        super.init(frame: frame)

        // Add the label to the marker view
        addSubview(label)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Customization of the tooltip text
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        label.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(Int(entry.y)))
       
        // Adjust the width of the tooltip based on the label's content
        label.sizeToFit()
        
        // Update the frame of the tooltip
        var frame = label.frame
        frame.size.width += 15 // Add some padding
        frame.size.height += 10 // Add some vertical padding
        label.frame = frame
    }

    // Customization of the tooltip position
    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        var offset = CGPoint(x: -bounds.size.width / 5 + 5, y: bounds.size.height)
                
        let chartHeight = super.chartView?.bounds.height ?? 0
            let minY = bounds.size.height
            let maxY = chartHeight - bounds.size.height
            
            if offset.y < minY {
                offset.y = minY
            } else if offset.y > maxY {
                offset.y = maxY
            }
            
            return offset
    }
}


