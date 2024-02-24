//
//  EmployeeReportRevenueViewController+Extension.swift
//  ORDER
//
//  Created by Kelvin on 13/05/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import Charts

extension EmployeeReportRevenueViewController {
    
    func getCurentTime(){
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        self.Week = calendar.component(.weekOfYear, from: date)
        //Tuần này
        self.thisWeek = String(format: "%d/%d", self.Week, year)
        if self.thisWeek.count == 6 {
            self.thisWeek = String(format: "0%d/%d", self.Week, year)
        }
        //Thang nay
        self.monthCurrent = String(format: "%d/%d", month, year)
        //
        let tm = Calendar.current.date(byAdding: .month, value: 0, to: Date())
        let tmFormatter : DateFormatter = DateFormatter()
        tmFormatter.dateFormat = "MM/yyyy"
        self.thisMonth = tmFormatter.string(from: tm!)
        //Tháng trước
        let lm = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let monthFormatter : DateFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM/yyyy"
        self.lastMonth = monthFormatter.string(from: lm!)
        //Nam nay
        self.yearCurrent = String(year)
        //Nam truoc
        let ly = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        let yearFormatter : DateFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        self.lastYear = yearFormatter.string(from: ly!)
        
        //
        let format = DateFormatter()
        format.dateFormat = "dd/MM/YYYY"
        let formattedDate = format.string(from: date)
        self.dateTimeNow = formattedDate
        //Hôm nay
        let formatTime = DateFormatter()
        formatTime.dateFormat = "HH:mm:ss"
        
        today = formatTime.string(from: date)
        
        //        lblCurrentTime.text = formatTime.string(from: date)
        //Hôm qua
        let y = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.yesterday = dateFormatter.string(from: y!)
        
    }
    
    //MARK: Register Cells as you want
    func registerCell(){
        
        let employeeReportRevenueTableViewCell = UINib(nibName: "EmployeeReportRevenueTableViewCell", bundle: .main)
        tableView.register(employeeReportRevenueTableViewCell, forCellReuseIdentifier: "EmployeeReportRevenueTableViewCell")
      
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView
            .rx.setDelegate(self)
            .disposed(by: rxbag)
    }
}
extension EmployeeReportRevenueViewController{
    @IBAction func actionFilterToday(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_today, textTitle: self.btn_filter_today)
        self.viewModel.report_type.accept(REPORT_TYPE_TODAY)
        self.viewModel.date_string.accept(dateTimeNow)
        self.reportRevenueByEmployee()
    }
    
    @IBAction func actionFilterYesterday(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_yesterday, textTitle: self.btn_filter_yesterday)
        self.viewModel.report_type.accept(REPORT_TYPE_YESTERDAY)
        self.viewModel.date_string.accept(yesterday)
        self.reportRevenueByEmployee()
    }
    
    @IBAction func actionFilterThisWeek(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_thisweek, textTitle: self.btn_filter_thisweek)
        self.viewModel.report_type.accept(REPORT_TYPE_THIS_WEEK)
        self.viewModel.date_string.accept(thisWeek)
        self.reportRevenueByEmployee()
    }
    
    @IBAction func actionFilterThisMonth(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_thismonth, textTitle: self.btn_filter_thismonth)
        self.viewModel.report_type.accept(REPORT_TYPE_THIS_MONTH)
        self.viewModel.date_string.accept(thisMonth)
        self.reportRevenueByEmployee()
    }
    
    @IBAction func actionFilterLastMonth(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_lastmonth, textTitle: self.btn_filter_lastmonth)
        self.viewModel.report_type.accept(REPORT_TYPE_LAST_MONTH)
        self.viewModel.date_string.accept(lastMonth)
        self.reportRevenueByEmployee()
    }
    
    
    @IBAction func actionFilterThreeMonth(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_three_month, textTitle: self.btn_filter_three_month)
        self.viewModel.report_type.accept(REPORT_TYPE_THREE_MONTHS)
        self.viewModel.date_string.accept(dateTimeNow)
        self.reportRevenueByEmployee()
    }
    
    @IBAction func actionFilterThisYear(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_this_year, textTitle: self.btn_filter_this_year)
        self.viewModel.report_type.accept(REPORT_TYPE_THIS_YEAR)
        self.viewModel.date_string.accept(yearCurrent)
        self.reportRevenueByEmployee()
    }
    
    @IBAction func actionFilterLastYear(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_last_year, textTitle: self.btn_filter_last_year)
        self.viewModel.report_type.accept(REPORT_TYPE_LAST_YEAR)
        self.viewModel.date_string.accept(lastYear)
        self.reportRevenueByEmployee()
    }
    
    @IBAction func actionFilterThreeYear(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_three_year, textTitle: self.btn_filter_three_year)
        self.viewModel.report_type.accept(REPORT_TYPE_THREE_YEAR)
        self.reportRevenueByEmployee()
    }
    
    @IBAction func actionFilterAllYear(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_All_year, textTitle: self.btn_filter_All_year)
        self.viewModel.report_type.accept(REPORT_TYPE_ALL_YEAR)
        self.viewModel.date_string.accept(yearCurrent)
        self.reportRevenueByEmployee()
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.viewModel.makePopViewController()
    }
    func checkFilterSelected(view_selected:UIView, textTitle:UILabel){
        view_filter_today.backgroundColor = .white
        view_filter_yesterday.backgroundColor = .white
        view_filter_thisweek.backgroundColor = .white
        view_filter_thismonth.backgroundColor = .white
        view_filter_lastmonth.backgroundColor = .white
        view_filter_three_month.backgroundColor = .white
        view_filter_this_year.backgroundColor = .white
        view_filter_last_year.backgroundColor = .white
        view_filter_three_year.backgroundColor = .white
        view_filter_All_year.backgroundColor = .white
        
        btn_filter_today.textColor = ColorUtils.main_color()
        btn_filter_yesterday.textColor = ColorUtils.main_color()
        btn_filter_thisweek.textColor = ColorUtils.main_color()
        btn_filter_thismonth.textColor = ColorUtils.main_color()
        btn_filter_lastmonth.textColor = ColorUtils.main_color()
        btn_filter_three_month.textColor = ColorUtils.main_color()
        btn_filter_this_year.textColor = ColorUtils.main_color()
        btn_filter_last_year.textColor = ColorUtils.main_color()
        btn_filter_three_year.textColor = ColorUtils.main_color()
        btn_filter_All_year.textColor = ColorUtils.main_color()
        
        textTitle.textColor = ColorUtils.white()
        view_selected.backgroundColor = ColorUtils.main_color()
    }
    
    
}
extension EmployeeReportRevenueViewController{
    func bindTableView() {
        viewModel.revenues.asObservable().bind(to: tableView.rx.items(cellIdentifier: "EmployeeReportRevenueTableViewCell", cellType: EmployeeReportRevenueTableViewCell.self))
           {  (row, revenue, cell) in
               cell.viewModel = self.viewModel
               cell.index = row + 1
               cell.data = revenue
               
           }.disposed(by: rxbag)
    }
    
}
extension EmployeeReportRevenueViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
extension EmployeeReportRevenueViewController:AxisValueFormatter{
    func setupLineChart(revenues:[RevenueEmployee]) {
        lineChart.noDataText = "Chưa có dữ liệu!"
        lineChart.noDataFont = UIFont(name: "Helvetica", size: 10.0)!
        lineChartItems.removeAll()
        
        let revenues = revenues
        for i in 0..<revenues.count {
            lineChartItems.append(ChartDataEntry(x: Double(i), y: Double(revenues[i].revenue / 1000)))
        }
        //Line Chart
        let lineChartDataSet = LineChartDataSet(entries: lineChartItems, label: "")
        lineChartDataSet.setColor(ColorUtils.blue_color())
        lineChartDataSet.setCircleColor(ColorUtils.blue_color())
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.circleRadius = 3
        lineChart.data = LineChartData(dataSet: lineChartDataSet)
        lineChart.legend.enabled = false
        lineChart.chartDescription.enabled = false
        lineChart.backgroundColor = UIColor.white
        lineChart.leftAxis.drawAxisLineEnabled = true
        lineChart.leftAxis.drawGridLinesEnabled = true
        lineChart.leftAxis.valueFormatter = self // Thêm phương thức
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.drawAxisLineEnabled = false
        lineChart.xAxis.drawGridLinesEnabled = true
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.leftAxis.axisMinimum = 0
        lineChart.xAxis.axisMinimum = -1
        lineChart.xAxis.axisMaximum = Double(lineChartItems.count)
        lineChart.xAxis.labelCount = lineChartDataSet.count + 1
        lineChart.xAxis.labelFont = NSUIFont(descriptor: UIFontDescriptor(name: "System", size: 9), size: 9)
        lineChart.pinchZoomEnabled = false
        lineChart.doubleTapToZoomEnabled = false
        lineChart.xAxis.labelRotationAngle = -40
        lineChart.xAxis.labelRotatedHeight = 60
        lineChart.animate(xAxisDuration: 2.0, yAxisDuration: 3.0, easingOption: ChartEasingOption.easeInOutQuart)
        
        var x_label = [String]()
        for i in 0 ..< revenues.count {
            x_label.append(revenues[i].employee_name)
        }
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: x_label)
    }
    
    
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        dLog(value)
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

//MARK: CALL API
extension EmployeeReportRevenueViewController{
    //MARK: revenue by employee
    func reportRevenueByEmployee(){
        viewModel.reportRevenueByEmployee().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let revenue = Mapper<RevenueEmployeeData>().map(JSONObject: response.data) {
                    dLog(revenue.toJSON())
                    self.lbl_total_revenue.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: revenue.total_revenue)
                    if let revenues = revenue.revenues{
                        dLog(revenues.toJSON())
                        self.setupLineChart(revenues: revenues)
                        self.viewModel.revenues.accept(revenues)
                        // Kiểm tra hiển thị view no data
                        self.No_data_view.isHidden = (self.viewModel.revenues.value.count) > 0 ? true:false
                    }
                  
                }
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
}
