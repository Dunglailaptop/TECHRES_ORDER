//
//  EmployeeReportRevenueViewController.swift
//  ORDER
//
//  Created by Kelvin on 13/05/2023.
//

import UIKit
import Charts

class EmployeeReportRevenueViewController: BaseViewController {
    var viewModel = EmployeeReportRevenueViewModel()
    var router = EmployeeReportRevenueRouter()
    
  
    @IBOutlet weak var lineChart: LineChartView!
    
  
    @IBOutlet weak var No_data_view: UIView! // Hiển thi view không có dữ liệu
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbl_branch_name: UILabel!
    @IBOutlet weak var lbl_branch_address: UILabel!
    @IBOutlet weak var avatar_branch: UIImageView!
    
    @IBOutlet weak var btn_filter_today: UILabel!
    @IBOutlet weak var btn_filter_yesterday: UILabel!
    @IBOutlet weak var btn_filter_thisweek: UILabel!
    @IBOutlet weak var btn_filter_thismonth: UILabel!
    @IBOutlet weak var btn_filter_lastmonth: UILabel!
    
    @IBOutlet weak var btn_filter_three_month: UILabel!
    @IBOutlet weak var btn_filter_this_year: UILabel!
    @IBOutlet weak var btn_filter_last_year: UILabel!
    @IBOutlet weak var btn_filter_three_year: UILabel!
    @IBOutlet weak var btn_filter_All_year: UILabel!
    
    @IBOutlet weak var view_filter_today: UIView!
    @IBOutlet weak var view_filter_yesterday: UIView!
    @IBOutlet weak var view_filter_thisweek: UIView!
    @IBOutlet weak var view_filter_thismonth: UIView!
    @IBOutlet weak var view_filter_lastmonth: UIView!
    
    @IBOutlet weak var view_filter_three_month: UIView!
    @IBOutlet weak var view_filter_this_year: UIView!
    @IBOutlet weak var view_filter_last_year: UIView!
    @IBOutlet weak var view_filter_three_year: UIView!
    @IBOutlet weak var view_filter_All_year: UIView!
    
    
    @IBOutlet weak var btnFilterToday: UIButton!
    @IBOutlet weak var btnFilterYesterday: UIButton!
    @IBOutlet weak var btnFilterThisweek: UIButton!
    @IBOutlet weak var btnFilterThismonth: UIButton!
    @IBOutlet weak var btnFilterLastmonth: UIButton!
    @IBOutlet weak var btnFilterThreeMonth: UIButton!
    @IBOutlet weak var btnFilterThisYear: UIButton!
    @IBOutlet weak var btnFilterLastYear: UIButton!
    @IBOutlet weak var btnFilterThreeYear: UIButton!
    
    @IBOutlet weak var lbl_total_revenue: UILabel!
 

    var time = ""
    var today = ""
    var yesterday = ""
    var monthCurrent = ""
    var yearCurrent = ""
    var Week = 1
    var thisWeek = ""
    var lastMonth = ""
    var thisMonth = ""
    var lastYear = ""
    var dateTimeNow = ""
    var report_type = 1
    
    var lineChartItems = [ChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        No_data_view.isHidden = true // Hiển thị view no data
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        getCurentTime()
        
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.restaurant_brand_id.accept(ManageCacheObject.getCurrentBrand().id)
       
        registerCell()
        bindTableView()
//        ColorUtils.green_600()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbl_branch_name.text = ManageCacheObject.getCurrentBranch().name
        lbl_branch_address.text = ManageCacheObject.getCurrentBranch().address
        avatar_branch.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: ManageCacheObject.getCurrentBranch().avatar)), placeholder: UIImage(named: "image_defauft_medium"))
        
      
        switch (report_type){
        case REPORT_TYPE_TODAY:
            self.checkFilterSelected(view_selected: self.view_filter_today, textTitle: self.btn_filter_today)
            self.viewModel.report_type.accept(REPORT_TYPE_TODAY)
            self.viewModel.date_string.accept(dateTimeNow)
            self.reportRevenueByEmployee()
            break
        case REPORT_TYPE_YESTERDAY:
            self.checkFilterSelected(view_selected: self.view_filter_yesterday, textTitle: self.btn_filter_yesterday)
            self.viewModel.report_type.accept(REPORT_TYPE_YESTERDAY)
            self.viewModel.date_string.accept(yesterday)
            self.reportRevenueByEmployee()
            break
        case REPORT_TYPE_THIS_WEEK:
            self.checkFilterSelected(view_selected: self.view_filter_thisweek, textTitle: self.btn_filter_thisweek)
            self.viewModel.report_type.accept(REPORT_TYPE_THIS_WEEK)
            self.viewModel.date_string.accept(thisWeek)
            self.reportRevenueByEmployee()
            break
        case REPORT_TYPE_THIS_MONTH:
            self.checkFilterSelected(view_selected: self.view_filter_thismonth, textTitle: self.btn_filter_thismonth)
            self.viewModel.report_type.accept(REPORT_TYPE_THIS_MONTH)
            self.viewModel.date_string.accept(thisMonth)
            self.reportRevenueByEmployee()
            break
        case REPORT_TYPE_LAST_MONTH:
            self.checkFilterSelected(view_selected: self.view_filter_lastmonth, textTitle: self.btn_filter_lastmonth)
            self.viewModel.report_type.accept(REPORT_TYPE_LAST_MONTH)
            self.viewModel.date_string.accept(lastMonth)
            self.reportRevenueByEmployee()
            break
        case REPORT_TYPE_THREE_MONTHS:
            self.checkFilterSelected(view_selected: self.view_filter_three_month, textTitle: self.btn_filter_three_month)
            self.viewModel.report_type.accept(REPORT_TYPE_THREE_MONTHS)
            self.viewModel.date_string.accept(dateTimeNow)
            self.reportRevenueByEmployee()
            break
        case REPORT_TYPE_THIS_YEAR:
            self.checkFilterSelected(view_selected: self.view_filter_this_year, textTitle: self.btn_filter_this_year)
            self.viewModel.report_type.accept(REPORT_TYPE_THIS_YEAR)
            self.viewModel.date_string.accept(yearCurrent)
            self.reportRevenueByEmployee()
            break
        case REPORT_TYPE_LAST_YEAR:
            self.checkFilterSelected(view_selected: self.view_filter_last_year, textTitle: self.btn_filter_last_year)
            self.viewModel.report_type.accept(REPORT_TYPE_LAST_YEAR)
            self.viewModel.date_string.accept(lastYear)
            self.reportRevenueByEmployee()
            break
        case REPORT_TYPE_THREE_YEAR:
            self.checkFilterSelected(view_selected: self.view_filter_three_year, textTitle: self.btn_filter_three_year)
            self.viewModel.report_type.accept(REPORT_TYPE_THREE_YEAR)
            self.reportRevenueByEmployee()
            break
        default:
            self.checkFilterSelected(view_selected: self.view_filter_today, textTitle: self.btn_filter_today)
            self.viewModel.report_type.accept(REPORT_TYPE_TODAY)
            self.viewModel.date_string.accept(dateTimeNow)
            self.reportRevenueByEmployee()
            break
            
        }
        
        
        reportRevenueByEmployee()
    }
    

    @IBAction func btnback(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
}
