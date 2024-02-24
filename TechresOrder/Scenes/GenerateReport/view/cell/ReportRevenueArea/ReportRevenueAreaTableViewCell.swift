//
//  ReportRevenueAreaTableViewCell.swift
//  Techres-Seemt
//
//  Created by Nguyen Thanh Vinh on 16/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import Charts

class ReportRevenueAreaTableViewCell: UITableViewCell {

    @IBOutlet weak var pie_chart: PieChartView!
    @IBOutlet weak var bar_chart: BarChartView!
    var pieChartItems = [PieChartDataEntry]()
        
    var colors = ColorUtils.chartColors()
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewArea: UITableView!
    @IBOutlet weak var root_view_empty_data: UIView!
    @IBOutlet weak var height_table_view: NSLayoutConstraint!
    @IBOutlet weak var height_of_view_wrap: NSLayoutConstraint!
    
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
    
    var btnArray:[UIButton] = []

    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let areaItemRevenueTableViewCell = UINib(nibName: "AreaItemRevenueTableViewCell", bundle: .main)
        tableView.register(areaItemRevenueTableViewCell, forCellReuseIdentifier: "AreaItemRevenueTableViewCell")
        
        
        let cellReportRevenueAreaListItem = UINib(nibName: "CellReportRevenueAreaListItem", bundle: .main)
        tableViewArea.register(cellReportRevenueAreaListItem, forCellReuseIdentifier: "CellReportRevenueAreaListItem")
        tableViewArea.isScrollEnabled = false
        tableViewArea.rowHeight = UITableView.automaticDimension
        tableViewArea.separatorStyle = UITableViewCell.SeparatorStyle.none
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

    }
    
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        
        guard let viewModel = self.viewModel else {return}
        
        var areaRevenueReport = viewModel.areaRevenueReport.value
        areaRevenueReport.reportType = sender.tag
        areaRevenueReport.dateString = viewModel.view?.reportTypeArray[sender.tag] ?? ""
        viewModel.areaRevenueReport.accept(areaRevenueReport)
        self.viewModel?.view?.getReportRevenueArea()
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
    
    
    
    
    var viewModel: GenerateReportViewModel? {
           didSet {
               guard let viewModel = self.viewModel else {return}
               btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
               changeBgBtn(btn: btn_this_month)
               for btn in self.btnArray{
                   btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                       self?.changeBgBtn(btn: btn)
                   }).disposed(by: disposeBag)
               }
               
               var total_revenue_amount = 0
               viewModel.areaRevenueReport.subscribe(onNext: { [self] report in
                   lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue_amount)
                   root_view_empty_data.isHidden = report.total_revenue_amount > 0 ? true : false
                   setupBarChart(data: report.areaRevenueReportData, barChart: bar_chart)
                   setRevenueAreaPieChart(dataChart: report.areaRevenueReportData)
                   total_revenue_amount = report.total_revenue_amount
                 }).disposed(by: disposeBag)

               viewModel.areaRevenueReport.map{$0.areaRevenueReportData}.asObservable().bind(to: tableView.rx.items){ [self] (tableView, index, element) in
                   let cell = tableView.dequeueReusableCell(withIdentifier: "AreaItemRevenueTableViewCell") as! AreaItemRevenueTableViewCell
                   cell.back_ground_index.backgroundColor = self.colors[index]
                   cell.lbl_index.text = String(index + 1)
                   cell.data = element
                   return cell
               }.disposed(by: disposeBag)
               
               viewModel.areaRevenueReport.map{$0.areaRevenueReportData}.asObservable().bind(to: tableViewArea.rx.items){ [self] (tableView, index, element) in
                   let cell = tableView.dequeueReusableCell(withIdentifier: "CellReportRevenueAreaListItem") as! CellReportRevenueAreaListItem
                   cell.view_color_area.backgroundColor = self.colors[index]
                   cell.lbl_percent_area.textColor = self.colors[index]
                   cell.totalAmountRevenueArea = total_revenue_amount
                   cell.lbl_index_area.text = String(index + 1)
                   cell.data = element
                   return cell
               }.disposed(by: disposeBag)
           }    
    }
    
    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeToAreaReportViewController()
     
    }
    
}

