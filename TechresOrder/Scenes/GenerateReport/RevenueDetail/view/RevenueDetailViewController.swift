//
//  RevenueDetailViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 05/02/2023.
//

import UIKit
import Charts


class RevenueDetailViewController: BaseViewController {
    var viewModel = RevenueDetailViewModel()
    var router = RevenueDetailRouter()
    
    @IBOutlet weak var line_chart_view: LineChartView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl_revenue_title: UILabel!
    @IBOutlet weak var lbl_branch_name: UILabel!
    @IBOutlet weak var lbl_branch_address: UILabel!
    @IBOutlet weak var avatar_branch: UIImageView!
    
    @IBOutlet weak var lbl_filter_today: UILabel!
    @IBOutlet weak var lbl_filter_yesterday: UILabel!
    @IBOutlet weak var lbl_filter_this_week: UILabel!
    @IBOutlet weak var lbl_filter_this_month: UILabel!
    @IBOutlet weak var lbl_filter_last_month: UILabel!
    @IBOutlet weak var lbl_filter_three_month: UILabel!
    @IBOutlet weak var lbl_filter_this_year: UILabel!
    @IBOutlet weak var lbl_filter_last_year: UILabel!
    @IBOutlet weak var lbl_filter_three_year: UILabel!
    @IBOutlet weak var lbl_filter_all_year: UILabel!
    
    @IBOutlet weak var view_filter_today: UIView!
    @IBOutlet weak var view_filter_yesterday: UIView!
    @IBOutlet weak var view_filter_thisweek: UIView!
    @IBOutlet weak var view_filter_thismonth: UIView!
    @IBOutlet weak var view_filter_lastmonth: UIView!
    @IBOutlet weak var view_filter_three_month: UIView!
    @IBOutlet weak var view_filter_this_year: UIView!
    @IBOutlet weak var view_filter_last_year: UIView!
    @IBOutlet weak var view_filter_three_year: UIView!
    @IBOutlet weak var view_filter_all_year: UIView!
    
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
    
    
    var dateTimeNow = ""
    var yesterday = ""
    var thisWeek = ""
    var lastThreeMonth = ""
    var lastMonth = ""
    var thisMonth = ""
    var lastThreeYear = ""
    var lastYear = ""
    var currentYear = ""
   
    var report_type = 1
    var lineChartItems = [ChartDataEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        getCurentTime()
        
        viewModel.branch_id.accept(ManageCacheObject.getCurrentUser().branch_id)
        viewModel.restaurant_brand_id.accept(ManageCacheObject.getCurrentUser().restaurant_brand_id)
        
        registerCell()
        bindTableView()
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lbl_branch_name.text = ManageCacheObject.getCurrentBranch().name
        lbl_branch_address.text = ManageCacheObject.getCurrentBranch().address
        avatar_branch.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: ManageCacheObject.getSetting().branch_info.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
        // CALL API GET REVENUE
        switch(report_type){
            case REPORT_TYPE_TODAY:
                checkFilterSelected(view_selected: view_filter_today, textTitle: lbl_filter_today)
                viewModel.report_type.accept(REPORT_TYPE_TODAY)
                viewModel.date_string.accept(dateTimeNow)
                lbl_revenue_title.text = String(format: "DOANH THU HÔM NAY| %@", dateTimeNow)
                reportRevenueByTime()
                break
            case REPORT_TYPE_YESTERDAY:
                checkFilterSelected(view_selected: view_filter_yesterday, textTitle: lbl_filter_yesterday)
                viewModel.report_type.accept(REPORT_TYPE_YESTERDAY)
                viewModel.date_string.accept(yesterday)
                lbl_revenue_title.text = String(format: "DOANH THU HÔM QUA| %@", yesterday)
                reportRevenueByTime()
                break
            case REPORT_TYPE_THIS_WEEK:
                checkFilterSelected(view_selected: self.view_filter_thisweek, textTitle: self.lbl_filter_this_week)
                viewModel.report_type.accept(REPORT_TYPE_THIS_WEEK)
                viewModel.date_string.accept(thisWeek)
                lbl_revenue_title.text = String(format: "DOANH THU TUẦN NÀY| %@", thisWeek)
                reportRevenueByTime()
                break
            case REPORT_TYPE_THIS_MONTH:
                checkFilterSelected(view_selected: view_filter_thismonth, textTitle: lbl_filter_this_month)
                viewModel.report_type.accept(REPORT_TYPE_THIS_MONTH)
                viewModel.date_string.accept(thisMonth)
                lbl_revenue_title.text = String(format: "DOANH THU THÁNG NÀY| %@", thisMonth)
                reportRevenueByTime()
                break
            
                
            case REPORT_TYPE_LAST_MONTH:
                checkFilterSelected(view_selected: view_filter_thismonth, textTitle: lbl_filter_this_month)
                viewModel.report_type.accept(REPORT_TYPE_LAST_MONTH)
                viewModel.date_string.accept(lastMonth)
                lbl_revenue_title.text = String(format: "DOANH THU THÁNG TRƯỚC| %@", lastMonth)
                reportRevenueByTime()
                break
            
            case REPORT_TYPE_THREE_MONTHS:
                checkFilterSelected(view_selected: view_filter_three_month, textTitle: lbl_filter_three_month)
                viewModel.report_type.accept(REPORT_TYPE_THREE_MONTHS)
                viewModel.date_string.accept(lastThreeMonth)
                lbl_revenue_title.text =  "DOANH THU 3 THÁNG GẦN NHẤT"
                reportRevenueByTime()
                break
            case REPORT_TYPE_THIS_YEAR:
                checkFilterSelected(view_selected: view_filter_this_year, textTitle: lbl_filter_this_year)
                viewModel.report_type.accept(REPORT_TYPE_THIS_YEAR)
                viewModel.date_string.accept(currentYear)
                lbl_revenue_title.text = String(format: "DOANH THU NĂM NAY| %@", currentYear)
                reportRevenueByTime()
                break
            case REPORT_TYPE_LAST_YEAR:
                checkFilterSelected(view_selected: view_filter_last_year, textTitle: lbl_filter_last_year)
                viewModel.report_type.accept(REPORT_TYPE_LAST_YEAR)
                viewModel.date_string.accept(lastYear)
                lbl_revenue_title.text = String(format: "DOANH THU NĂM TRƯỚC| %@", lastYear)
                reportRevenueByTime()
                break
            case REPORT_TYPE_THREE_YEAR:
                checkFilterSelected(view_selected: view_filter_three_year, textTitle: lbl_filter_three_year)
                viewModel.report_type.accept(REPORT_TYPE_THREE_YEAR)
                lbl_revenue_title.text = "DOANH THU 3 NĂM GẦN NHẤT"
                reportRevenueByTime()
                break
            default:
                checkFilterSelected(view_selected: view_filter_today, textTitle: lbl_filter_today)
                viewModel.report_type.accept(REPORT_TYPE_TODAY)
                viewModel.date_string.accept(dateTimeNow)
                lbl_revenue_title.text = String(format: "DOANH THU HÔM NAY| %@", dateTimeNow)
                reportRevenueByTime()
                break
        }
      
    }

}
extension RevenueDetailViewController{
    @IBAction func actionFilterToday(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_today, textTitle: lbl_filter_today)
        viewModel.report_type.accept(REPORT_TYPE_TODAY)
        viewModel.date_string.accept(dateTimeNow)
        
        lbl_revenue_title.text = String(format: "DOANH THU HÔM NAY| %@", dateTimeNow)
        reportRevenueByTime()
    }
    
    @IBAction func actionFilterYesterday(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_yesterday, textTitle: lbl_filter_yesterday)
        viewModel.report_type.accept(REPORT_TYPE_YESTERDAY)
        viewModel.date_string.accept(yesterday)
        lbl_revenue_title.text = String(format: "DOANH THU HÔM QUA| %@", yesterday)
        reportRevenueByTime()
    }
    
    @IBAction func actionFilterThisWeek(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_thisweek, textTitle: lbl_filter_this_week)
        viewModel.report_type.accept(REPORT_TYPE_THIS_WEEK)
        viewModel.date_string.accept(thisWeek)
        lbl_revenue_title.text = String(format: "DOANH THU TUẦN NÀY| %@", thisWeek)
        reportRevenueByTime()
    }
    
    @IBAction func actionFilterThisMonth(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_thismonth, textTitle: lbl_filter_this_month)
        viewModel.report_type.accept(REPORT_TYPE_THIS_MONTH)
        viewModel.date_string.accept(thisMonth)
        lbl_revenue_title.text = String(format: "DOANH THU THÁNG NÀY| %@", thisMonth)
        reportRevenueByTime()
    }
    
    @IBAction func actionFilterLastMonth(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_lastmonth, textTitle: lbl_filter_last_month)
        viewModel.report_type.accept(REPORT_TYPE_LAST_MONTH)
        viewModel.date_string.accept(lastMonth)
        lbl_revenue_title.text = String(format: "DOANH THU THÁNG TRƯỚC| %@", lastMonth)
        reportRevenueByTime()
    }
    
    
    
    @IBAction func actionFilterThreeMonth(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_three_month, textTitle: lbl_filter_three_month)
        viewModel.report_type.accept(REPORT_TYPE_THREE_MONTHS)
        viewModel.date_string.accept(lastThreeMonth)
        lbl_revenue_title.text =  "DOANH THU 3 THÁNG GẦN NHẤT"
        reportRevenueByTime()
    }
    
    @IBAction func actionFilterThisYear(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_this_year, textTitle: lbl_filter_this_year)
        viewModel.report_type.accept(REPORT_TYPE_THIS_YEAR)
        viewModel.date_string.accept(currentYear)
        lbl_revenue_title.text = String(format: "DOANH THU NĂM NAY| %@", currentYear)

        reportRevenueByTime()
    }
    
    @IBAction func actionFilterLastYear(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_last_year, textTitle: lbl_filter_last_year)
        viewModel.report_type.accept(REPORT_TYPE_LAST_YEAR)
        viewModel.date_string.accept(lastYear)
        lbl_revenue_title.text = String(format: "DOANH THU NĂM TRƯỚC| %@", lastYear)
        reportRevenueByTime()
    }
    
    @IBAction func actionFilterThreeYear(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_three_year, textTitle: lbl_filter_three_year)
        viewModel.report_type.accept(REPORT_TYPE_THREE_YEAR)
        viewModel.date_string.accept(lastThreeYear)
        lbl_revenue_title.text = "DOANH THU 3 NĂM GẦN NHẤT"
        reportRevenueByTime()
    }
    
    @IBAction func actionFilterAllYear(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_all_year, textTitle: lbl_filter_all_year)
        viewModel.report_type.accept(REPORT_TYPE_ALL_YEAR)
        viewModel.date_string.accept(currentYear)
        lbl_revenue_title.text = "DOANH THU TẤT CẢ CÁC NĂM"
        reportRevenueByTime()
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        
        viewModel.makePopViewController()
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
        view_filter_all_year.backgroundColor = .white
        
        lbl_filter_today.textColor = ColorUtils.main_color()
        lbl_filter_yesterday.textColor = ColorUtils.main_color()
        lbl_filter_this_week.textColor = ColorUtils.main_color()
        lbl_filter_this_month.textColor = ColorUtils.main_color()
        lbl_filter_last_month.textColor = ColorUtils.main_color()
        lbl_filter_three_month.textColor = ColorUtils.main_color()
        lbl_filter_this_year.textColor = ColorUtils.main_color()
        lbl_filter_last_year.textColor = ColorUtils.main_color()
        lbl_filter_three_year.textColor = ColorUtils.main_color()
        lbl_filter_all_year.textColor = ColorUtils.main_color()

        textTitle.textColor = ColorUtils.white()
        view_selected.backgroundColor = ColorUtils.main_color()
//        fees()
    }
    
    func getCurentTime(){
        yesterday = Utils.getYesterdayString()
        dateTimeNow = Utils.getCurrentDateString()
        thisWeek = Utils.getCurrentWeekString()
        lastThreeMonth = Utils.getLastThreeMonthString()
        lastMonth = Utils.getLastMonthString()
        thisMonth = Utils.getCurrentMonthString()
        lastThreeYear = Utils.getLastThreeYearString()
        lastYear = Utils.getLastYearString()
        currentYear = Utils.getCurrentYearString()
    }
}
