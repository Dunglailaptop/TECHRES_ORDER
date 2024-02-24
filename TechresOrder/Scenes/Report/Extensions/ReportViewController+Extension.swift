//
//  ReportViewController+Extension.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 30/01/2023.
//

import UIKit
import ObjectMapper
import Charts

extension ReportViewController {
    
    //MARK: Register Cells as you want
    func registerCell(){
//        let reportDetailChartTableViewCell = UINib(nibName: "ReportDetailChartTableViewCell", bundle: .main)
//        tableView.register(reportDetailChartTableViewCell, forCellReuseIdentifier: "ReportDetailChartTableViewCell")

        let itemReportDetailTableViewCell = UINib(nibName: "ItemReportDetailTableViewCell", bundle: .main)
        tableView.register(itemReportDetailTableViewCell, forCellReuseIdentifier: "ItemReportDetailTableViewCell")
      
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView
            .rx.setDelegate(self)
            .disposed(by: rxbag)
    }
}
extension ReportViewController{
    func bindTableView() {
        viewModel.revenues.asObservable().bind(to: tableView.rx.items(cellIdentifier: "ItemReportDetailTableViewCell", cellType: ItemReportDetailTableViewCell.self))
           {  (row, revenue, cell) in
               cell.viewModel = self.viewModel
               cell.index = row
               cell.data = revenue
               
           }.disposed(by: rxbag)
    }
    
}

extension ReportViewController:AxisValueFormatter{
    func setupLineChart(revenues:[Revenue]) {
        line_chart_view.noDataText = "Chưa có dữ liệu!"
        line_chart_view.noDataFont = UIFont(name: "Helvetica", size: 10.0)!
        lineChartItems.removeAll()
        
        let revenues = revenues
        for i in 0..<revenues.count {
            lineChartItems.append(ChartDataEntry(x: Double(i), y: Double(revenues[i].total_revenue / 1000)))
        }
        //Line Chart
        let lineChartDataSet = LineChartDataSet(entries: lineChartItems, label: "")
        lineChartDataSet.setColor(ColorUtils.blue_color())
        lineChartDataSet.setCircleColor(ColorUtils.blue_color())
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.circleRadius = 2
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.fillColor = ColorUtils.blue_brand_400()
        lineChartDataSet.fillAlpha = 0.5
        lineChartDataSet.mode = .cubicBezier
        
        
        
        
        line_chart_view.data = LineChartData(dataSet: lineChartDataSet)
        //Set up chú thích cho chart (Legend)
        line_chart_view.legend.enabled = false
        line_chart_view.legend.formSize = 10
        line_chart_view.legend.form = .circle
        line_chart_view.legend.formLineWidth = 1
        line_chart_view.legend.xEntrySpace = 10
        
        
        
        line_chart_view.chartDescription.enabled = false
        line_chart_view.backgroundColor = UIColor.white
        line_chart_view.leftAxis.drawAxisLineEnabled = true // hiển thị trục y
        line_chart_view.leftAxis.drawGridLinesEnabled = true
        line_chart_view.leftAxis.axisLineWidth = 2 //độ dày của cột y
        line_chart_view.leftAxis.valueFormatter = self // Thêm valueFormatter
//        line_chart_view.leftAxis.axisMinimum = -1
        line_chart_view.leftAxis.axisMinimum = 0
        line_chart_view.rightAxis.enabled = false
        line_chart_view.xAxis.drawAxisLineEnabled = true // hiển thị trục x
        line_chart_view.xAxis.drawGridLinesEnabled = true // hiện gridline của trục x
        line_chart_view.xAxis.axisLineWidth = 2 // độ dày của cột x
        line_chart_view.xAxis.labelPosition = .bottom
        line_chart_view.xAxis.labelRotationAngle = -50
        line_chart_view.xAxis.labelRotatedHeight = 40
        line_chart_view.xAxis.axisMinimum = 0 //hệ trục toạ độ bắt đầu từ 0
        line_chart_view.xAxis.axisMaximum = Double(lineChartItems.count)
        line_chart_view.xAxis.labelCount = setLabelCountForChart(reportType: viewModel.report_type.value, totalDataPoint: lineChartDataSet.count)
        line_chart_view.xAxis.labelFont = NSUIFont(descriptor: UIFontDescriptor(name: "System", size: 9), size: 9)
        
        line_chart_view.pinchZoomEnabled = true
        line_chart_view.doubleTapToZoomEnabled = false
        
        line_chart_view.animate(xAxisDuration: 2.0, yAxisDuration: 3.0, easingOption: ChartEasingOption.easeInOutQuart)
        
        var x_label = [String]()
        for i in 0 ..< revenues.count {
            let substringHour = revenues[i].report_time.components(separatedBy: [" "])
            let substringDate = substringHour[0].components(separatedBy: ["-"])
            
            switch(viewModel.report_type.value){
                case REPORT_TYPE_TODAY:
                    let hour = substringHour[1].components(separatedBy: [":"])
                    x_label.append(String(format: "%@:00", hour.first!))
                break
                
                case REPORT_TYPE_YESTERDAY:
                    let hour = substringHour[1].components(separatedBy: [":"])
                    x_label.append(String(format: "%@:00", hour.first!))
                    break
                
                case REPORT_TYPE_THIS_WEEK:
                    var s = revenues[i].report_time
                    switch i {
                        case 0:
                            s = "Thứ 2"
                            break
                        case 1:
                            s = "Thứ 3"
                            break
                        case 2:
                            s = "Thứ 4"
                            break
                        case 3:
                            s = "Thứ 5"
                            break
                        case 4:
                            s = "Thứ 6"
                            break
                        case 5:
                            s = "Thứ 7"
                            break
                        default:
                            s = "Chủ nhật"
                        }
                    x_label.append(s)
                    break
                
                case REPORT_TYPE_LAST_MONTH:
                        x_label.append(String(format: "%@/%@", substringDate[2],substringDate[1]))
                    break
                
                case REPORT_TYPE_THIS_MONTH:
                        x_label.append(String(format: "%@/%@", substringDate[2],substringDate[1]))
                    break
                case REPORT_TYPE_THREE_MONTHS:
                        x_label.append(String(format: "%@/%@", substringDate[2],substringDate[1]))
                    break
                case REPORT_TYPE_THIS_YEAR:
                        x_label.append(String(format: "%@/%@", substringDate[1], substringDate[0]))
                    break
                case REPORT_TYPE_LAST_YEAR:
                        x_label.append(String(format: "%@/%@", substringDate[1], substringDate[0]))
                    break
                case REPORT_TYPE_THREE_YEAR:
                        x_label.append(String(format: "%@/%@", substringDate[1], substringDate[0]))
                    break
                
                case REPORT_TYPE_ALL_YEAR:
                        x_label.append(String(format: "%@",substringDate[0]))
                    break
                
                default:
                    break
            }
        }
        line_chart_view.xAxis.valueFormatter = IndexAxisValueFormatter(values: x_label)
    }
    
    private func setLabelCountForChart(reportType:Int,totalDataPoint:Int) -> Int{
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
    
    
    // Thêm format tiền
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if(value >= 0 && value < 1000 ){
            return String(format: "%@ K", Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: value))
        }else if(value >= 1000 && value < 1000000 ){
            return String(format: "%@ Tr", Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: value/1000))
        }else if(value >= 1000000){
            return String(format: "%@ Tỷ", Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: value/1000000))
        }
        return String(format: "%@", Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: value))
     }

    
}


extension ReportViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
extension ReportViewController{
    func checkLevelShowCurrentPointOfEmployee(){
        if(ManageCacheObject.getSetting().service_restaurant_level_id < GPQT_LEVEL_ONE){
//            self.constraint_filter_view.constant = 30
            root_view_point.isHidden = true
//            root_view_point.frame.size.height = 0
            height_of_root_view_point.constant = 0
        }
    }
}



extension ReportViewController {
    //MARK: revenue by time
    func reportRevenueByTime(){
        viewModel.reportRevenueByEmployee().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let revenue = Mapper<RevenueData>().map(JSONObject: response.data) {
                    dLog(revenue.toJSON())
                    self.lbl_total_revenue.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: revenue.total_revenue)
                    if let revenues = revenue.revenues{
                        dLog(revenues.toJSON())
                        if(revenues[0].total_revenue >= 0){
                            self.setupLineChart(revenues: revenues)
                            self.viewModel.revenues.accept(revenues)
                        }
                    }
                  
                }
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
}
