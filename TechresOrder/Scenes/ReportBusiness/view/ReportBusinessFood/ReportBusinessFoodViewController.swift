//
//  ReportBusinessFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 07/03/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import Charts
import RxRelay
import RxCocoa
class ReportBusinessFoodViewController: BaseViewController {
    
    // MARK: Biến của button filter
    @IBOutlet weak var btn_today: UIButton!
    @IBOutlet weak var btn_yesterday: UIButton!
    @IBOutlet weak var btn_this_week: UIButton!
    @IBOutlet weak var btn_this_month: UIButton!
    @IBOutlet weak var btn_last_month: UIButton!
    @IBOutlet weak var btn_last_three_month: UIButton!
    @IBOutlet weak var btn_this_year: UIButton!
    @IBOutlet weak var btn_last_year: UIButton!
    @IBOutlet weak var btn_last_three_year: UIButton!
    @IBOutlet weak var btn_all_year: UIButton!
    
    
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var view_no_data: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var total_amount: UILabel!
    
    var btnArray:[UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view_no_data.isHidden = true // Thêm view no data trong viewDidload()
        // Do any additional setup after loading the view.
        registerCell()
        bindTableViewData()
        
        btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
        changeBgBtn(btn: btn_this_month)
        for btn in self.btnArray{
            btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                self?.changeBgBtn(btn: btn)
            }).disposed(by: rxbag)
            
            if btn.tag == viewModel?.giftedFoodReport.value.reportType{
                changeBgBtn(btn: btn)
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportFood()
    }
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}
        var report = viewModel.foodReport.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.foodReport.accept(report)
        getReportFood()
    }
    
    func changeBgBtn(btn:UIButton){
        for button in self.btnArray{
            button.backgroundColor = ColorUtils.white()
            button.setTitleColor(ColorUtils.orange_brand_900(),for: .normal)
            
            let btnTxt = NSMutableAttributedString(string: button.titleLabel?.text ?? "",attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 12, weight: .semibold)])
        
            button.setAttributedTitle(btnTxt,for: .normal)
            button.borderWidth = 1
            button.borderColor = ColorUtils.orange_brand_900()
        }
        btn.borderWidth = 0
        btn.backgroundColor = ColorUtils.orange_brand_900()
        btn.setTitleColor(ColorUtils.white(),for: .normal)
    }
    

    var viewModel: ReportBusinessViewModel?
 
}
extension ReportBusinessFoodViewController{
    
    private func getReportFood(){
        guard let viewModel = self.viewModel else {return}
        viewModel.getReportFood().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<FoodReportData>().map(JSONObject: response.data) {
                    report.reportType = viewModel.foodReport.value.reportType
                    report.dateString = viewModel.foodReport.value.dateString
                    report.foods.sort{$0.total_amount > $1.total_amount}
                    viewModel.foodReport.accept(report)
                }
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.")
            }
        }).disposed(by: rxbag)
    }
    
    private func registerCell(){
        let foodReportRevenueTableViewCell = UINib(nibName: "FoodReportRevenueTableViewCell", bundle: .main)
        tableView.register(foodReportRevenueTableViewCell, forCellReuseIdentifier: "FoodReportRevenueTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    private func bindTableViewData() {
        guard let viewModel = self.viewModel else {return}
        
        viewModel.foodReport.subscribe(onNext: { [self] report in
            if report.foods.count > 0{
                setupBarChart(data: report.foods, barChart: barChart)
            }
            view_no_data.isHidden = report.total_amount > 0 ? true : false
            total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_amount)
        }).disposed(by: rxbag)
        
        viewModel.foodReport.map{$0.foods}.bind(to: tableView.rx.items(cellIdentifier: "FoodReportRevenueTableViewCell", cellType: FoodReportRevenueTableViewCell.self))
        {(row, food, cell) in
            cell.data = food
            cell.lbl_number.text = String(row + 1)
        }.disposed(by: rxbag)
        
    }
    
    
    private func setupBarChart(data:[FoodReport],barChart:BarChartView){
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.total_amount))},
            xLabel: data.map{$0.food_name}
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
