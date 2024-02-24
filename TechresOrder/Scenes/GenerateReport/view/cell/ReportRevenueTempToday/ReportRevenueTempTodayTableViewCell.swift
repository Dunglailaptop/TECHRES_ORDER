//
//  ReportRevenueTempTodayTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import RxSwift
import Charts
class ReportRevenueTempTodayTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_today_total_amount_temp: UILabel!
    
    @IBOutlet weak var lbl_revenue_temp_ready_payment: UILabel!
    
    @IBOutlet weak var lbl_revenue_temp_not_payment: UILabel!
    @IBOutlet weak var btnRevenueDetail: UIButton!
    @IBOutlet weak var line_chart: LineChartView!
    var lineChartItems = [ChartDataEntry]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel: GenerateReportViewModel? {
           didSet {
               guard let viewModel = self.viewModel else {return}
               viewModel.dailyOrderReport.subscribe( // Thực hiện subscribe Observable data food
                 onNext: { [weak self] (dailyOrderReport) in
                     self?.lbl_revenue_temp_not_payment.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.revenue_serving)
                     self?.lbl_revenue_temp_ready_payment.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.revenue_paid)
                     self?.lbl_today_total_amount_temp.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.revenue_paid + dailyOrderReport.revenue_serving)
                 }).disposed(by: disposeBag)

               viewModel.toDayRenueReport.subscribe( // Thực hiện subscribe Observable data food
                 onNext: { [weak self] (toDayRenueReport) in
                     self!.setupLineChart(revenuesToday: toDayRenueReport.revenues ?? [])
                 }).disposed(by: disposeBag)
           }
    }

}

extension ReportRevenueTempTodayTableViewCell:AxisValueFormatter{
    private func setupLineChart(revenuesToday:[Revenue]) {
        line_chart.noDataText = "Chưa có dữ liệu!"
        lineChartItems.removeAll()
        
        let revenues = revenuesToday
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
        lineChartDataSet.fillAlpha = 0.7
        lineChartDataSet.mode = .cubicBezier
        
        

        line_chart.data = LineChartData(dataSet: lineChartDataSet)
        line_chart.legend.enabled = false
        line_chart.chartDescription.enabled = false
        line_chart.backgroundColor = UIColor.white
        line_chart.leftAxis.drawAxisLineEnabled = true
        line_chart.leftAxis.drawGridLinesEnabled = true
        line_chart.rightAxis.enabled = false
        line_chart.leftAxis.axisMinimum = 0
        line_chart.leftAxis.valueFormatter = self // thêm valueFormatter
        line_chart.xAxis.drawAxisLineEnabled = false
        line_chart.xAxis.drawGridLinesEnabled = true
        line_chart.xAxis.labelPosition = .bottom
        line_chart.xAxis.drawGridLinesEnabled = false
        line_chart.xAxis.axisMinimum = 0
        line_chart.xAxis.axisMaximum = Double(lineChartItems.count)
        line_chart.xAxis.labelCount = lineChartDataSet.count/3
        line_chart.xAxis.labelFont = NSUIFont(descriptor: UIFontDescriptor(name: "System", size: 9), size: 9)
        line_chart.pinchZoomEnabled = false
        line_chart.doubleTapToZoomEnabled = false
        line_chart.xAxis.labelRotationAngle = -50// self.chartType == 4 || self.chartType == 3 ? -50 : 0
        line_chart.xAxis.labelRotatedHeight = 30
        line_chart.animate(xAxisDuration: 2.0, yAxisDuration: 3.0, easingOption: ChartEasingOption.easeInOutQuart)
        
        var x_label = [String]()
        for i in 0 ..< revenues.count {
            let substringHour = revenues[i].report_time.components(separatedBy: [" "])
            let hour = substringHour[1].components(separatedBy: [":"])
            x_label.append(String(format: "%@ giờ", hour.first!))
        }
        line_chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: x_label)
    }
    // Thêm format giá tiền
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
