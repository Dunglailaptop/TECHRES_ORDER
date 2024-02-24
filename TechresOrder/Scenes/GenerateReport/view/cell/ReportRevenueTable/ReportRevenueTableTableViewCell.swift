//
//  ReportRevenueTableTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/09/2023.
//

import UIKit
import Charts
import RxRelay
import RxSwift
class ReportRevenueTableTableViewCell: UITableViewCell {
    
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
    
    @IBOutlet weak var scroll_view: UIScrollView!
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
    
    @IBOutlet weak var stack_view: UIStackView!
    var btnArray:[UIButton] = []
    

    override func awakeFromNib() {
        super.awakeFromNib()
        let areaItemRevenueTableViewCell = UINib(nibName: "TableItemRevenueTableViewCell", bundle: .main)
        tableView.register(areaItemRevenueTableViewCell, forCellReuseIdentifier: "TableItemRevenueTableViewCell")
        
        
        let cellReportRevenueAreaListItem = UINib(nibName: "CellReportRevenueTableTableViewCell", bundle: .main)
        tableViewArea.register(cellReportRevenueAreaListItem, forCellReuseIdentifier: "CellReportRevenueTableTableViewCell")
        tableViewArea.isScrollEnabled = false
        tableViewArea.rowHeight = 50
        tableViewArea.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
        // Configure the view for the selected state
    }
    
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        
        guard let viewModel = self.viewModel else {return}
        var report = viewModel.tableRevenueReport.value
        report.reportType = sender.tag
        report.dateString = viewModel.view?.reportTypeArray[sender.tag] ?? ""
        viewModel.tableRevenueReport.accept(report)
        self.viewModel?.view?.getReportTableRevenue()
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
    
                   if btn.tag == viewModel.tableRevenueReport.value.reportType{
                       changeBgBtn(btn: btn)
                   }
               }
               
               var total_revenue_amount = 0
               viewModel.tableRevenueReport.subscribe(onNext: { [self] report in
                   lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue)
                   root_view_empty_data.isHidden = report.total_revenue > 0 ? true : false
                   
                   colors = report.tableRevenueReportData.map{_ in ColorUtils.random()}
                   setupBarChart(data: report.tableRevenueReportData, barChart: bar_chart)
                   setRevenueAreaPieChart(dataChart: report.tableRevenueReportData)
                   total_revenue_amount = report.total_revenue
                   
                   height_table_view.constant = CGFloat(report.tableRevenueReportData.count*50 + 520)
                   height_of_view_wrap.constant = CGFloat(report.tableRevenueReportData.count*50 + 520)
                   
                   
                   
                 }).disposed(by: disposeBag)

               viewModel.tableRevenueReport.map{$0.tableRevenueReportData}.bind(to: tableView.rx.items){ [self] (tableView, index, element) in
                   let cell = tableView.dequeueReusableCell(withIdentifier: "TableItemRevenueTableViewCell") as! TableItemRevenueTableViewCell
                   cell.back_ground_index.backgroundColor = self.colors[index]
                   cell.lbl_index.text = String(index + 1)
                   cell.data = element
                   return cell
               }.disposed(by: disposeBag)
               
               viewModel.tableRevenueReport.map{$0.tableRevenueReportData}.bind(to: tableViewArea.rx.items){ [self] (tableView, index, element) in
                   let cell = tableView.dequeueReusableCell(withIdentifier: "CellReportRevenueTableTableViewCell") as! CellReportRevenueTableTableViewCell
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
        viewModel.makeToTableReportViewController()
    }
    
    
    
}
