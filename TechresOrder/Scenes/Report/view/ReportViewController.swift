//
//  ReportViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 28/01/2023.
//

import UIKit
import Charts

class ReportViewController: BaseViewController {
    var viewModel = ReportViewModel()
    var router = ReportRouter()
    
  
    @IBOutlet weak var line_chart_view: LineChartView!
    
    @IBOutlet weak var lbl_target_amount: UILabel!
    
    @IBOutlet weak var lbl_target_point: UILabel!
    
    
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
    
    
    @IBOutlet weak var view_filter_today: UIView!
    @IBOutlet weak var view_filter_yesterday: UIView!
    @IBOutlet weak var view_filter_thisweek: UIView!
    @IBOutlet weak var view_filter_thismonth: UIView!
    @IBOutlet weak var view_filter_lastmonth: UIView!
    
    @IBOutlet weak var view_filter_three_month: UIView!
    @IBOutlet weak var view_filter_this_year: UIView!
    @IBOutlet weak var view_filter_last_year: UIView!
    @IBOutlet weak var view_filter_three_year: UIView!
    
    
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
    @IBOutlet weak var root_view_point: UIView!
//    @IBOutlet weak var constraint_filter_view: NSLayoutConstraint!

    @IBOutlet weak var height_of_root_view_point: NSLayoutConstraint!
    
    
    var dateTimeNow = ""
    var yesterday = ""
    var thisWeek = ""
    var lastThreeMonth = ""
    var lastMonth = ""
    var currentMonth = ""
    var lastThreeYear = ""
    var lastYear = ""
    var currentYear = ""
    var report_type = 1
//    var time = ""
//    var today = ""
//    var yesterday = ""
//    var monthCurrent = ""
//    var yearCurrent = ""
//    var Week = 1
//    var thisWeek = ""
//    var lastMonth = ""
//    var thisMonth = ""
//    var lastYear = ""
//    var dateTimeNow = ""
//    var report_type = 1
    
    var lineChartItems = [ChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        getCurentTime()
        
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.restaurant_brand_id.accept(ManageCacheObject.getCurrentBrand().id)
        viewModel.employee_id.accept(ManageCacheObject.getCurrentUser().id)
       
        registerCell()
        bindTableView()
        
        if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_FIVE){
            self.getCurrentPoint(employee_id: ManageCacheObject.getCurrentUser().id)
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLevelShowCurrentPointOfEmployee()
        lbl_target_point.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_target_point))
        lbl_target_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_bonus_salary))
        viewModel.employee_id.accept(ManageCacheObject.getCurrentUser().id)
        lbl_branch_name.text = ManageCacheObject.getCurrentBranch().name
        lbl_branch_address.text = ManageCacheObject.getCurrentBranch().address
        
        avatar_branch.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: ManageCacheObject.getSetting().branch_info.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
        // CALL API GET REVENUE
        switch(self.report_type){
            case REPORT_TYPE_TODAY:
                self.checkFilterSelected(view_selected: self.view_filter_today, textTitle: self.btn_filter_today)
                self.viewModel.report_type.accept(REPORT_TYPE_TODAY)
                self.viewModel.date_string.accept(dateTimeNow)
                self.reportRevenueByTime()
                break
            case REPORT_TYPE_YESTERDAY:
                self.checkFilterSelected(view_selected: self.view_filter_yesterday, textTitle: self.btn_filter_yesterday)
                self.viewModel.report_type.accept(REPORT_TYPE_YESTERDAY)
                self.viewModel.date_string.accept(yesterday)
                self.reportRevenueByTime()
                break
            case REPORT_TYPE_THIS_WEEK:
                self.checkFilterSelected(view_selected: self.view_filter_thisweek, textTitle: self.btn_filter_thisweek)
                self.viewModel.report_type.accept(REPORT_TYPE_THIS_WEEK)
                self.viewModel.date_string.accept(thisWeek)
                self.reportRevenueByTime()
                break
            case REPORT_TYPE_THIS_MONTH:
                self.checkFilterSelected(view_selected: self.view_filter_thismonth, textTitle: self.btn_filter_thismonth)
                self.viewModel.report_type.accept(REPORT_TYPE_THIS_MONTH)
                self.viewModel.date_string.accept(currentMonth)
                self.reportRevenueByTime()
                break
            case REPORT_TYPE_LAST_MONTH:
                self.checkFilterSelected(view_selected: self.view_filter_lastmonth, textTitle: self.btn_filter_lastmonth)
                self.viewModel.report_type.accept(REPORT_TYPE_LAST_MONTH)
                self.viewModel.date_string.accept(lastMonth)
                self.reportRevenueByTime()
                break
            case REPORT_TYPE_THREE_MONTHS:
                self.checkFilterSelected(view_selected: self.view_filter_three_month, textTitle: self.btn_filter_three_month)
                self.viewModel.report_type.accept(REPORT_TYPE_THREE_MONTHS)
                self.viewModel.date_string.accept(lastThreeMonth)
                self.reportRevenueByTime()
                break
            case REPORT_TYPE_THIS_YEAR:
                self.checkFilterSelected(view_selected: self.view_filter_this_year, textTitle: self.btn_filter_this_year)
                self.viewModel.report_type.accept(REPORT_TYPE_THIS_YEAR)
                self.viewModel.date_string.accept(currentYear)
                self.reportRevenueByTime()
                break
            case REPORT_TYPE_LAST_YEAR:
                self.checkFilterSelected(view_selected: self.view_filter_last_year, textTitle: self.btn_filter_last_year)
                self.viewModel.report_type.accept(REPORT_TYPE_LAST_YEAR)
                self.viewModel.date_string.accept(lastYear)
                self.reportRevenueByTime()
                break
            case REPORT_TYPE_THREE_YEAR:
                self.checkFilterSelected(view_selected: self.view_filter_three_year, textTitle: self.btn_filter_three_year)
                self.viewModel.report_type.accept(REPORT_TYPE_THREE_YEAR)
                self.viewModel.date_string.accept(lastThreeYear)
                self.reportRevenueByTime()
                break
            default:
                self.checkFilterSelected(view_selected: self.view_filter_today, textTitle: self.btn_filter_today)
                self.viewModel.report_type.accept(REPORT_TYPE_TODAY)
                self.viewModel.date_string.accept(dateTimeNow)
                self.reportRevenueByTime()
                break
        }
      
    }

}
extension ReportViewController{
    @IBAction func actionFilterToday(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_today, textTitle: self.btn_filter_today)
        self.viewModel.report_type.accept(REPORT_TYPE_TODAY)
        self.viewModel.date_string.accept(dateTimeNow)
        self.reportRevenueByTime()
    }
    
    @IBAction func actionFilterYesterday(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_yesterday, textTitle: self.btn_filter_yesterday)
        self.viewModel.report_type.accept(REPORT_TYPE_YESTERDAY)
        self.viewModel.date_string.accept(yesterday)
        self.reportRevenueByTime()
    }
    
    @IBAction func actionFilterThisWeek(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_thisweek, textTitle: self.btn_filter_thisweek)
        self.viewModel.report_type.accept(REPORT_TYPE_THIS_WEEK)
        self.viewModel.date_string.accept(thisWeek)
        self.reportRevenueByTime()
    }
    
    @IBAction func actionFilterThisMonth(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_thismonth, textTitle: self.btn_filter_thismonth)
        self.viewModel.report_type.accept(REPORT_TYPE_THIS_MONTH)
        self.viewModel.date_string.accept(currentMonth)
        self.reportRevenueByTime()
    }
    
    @IBAction func actionFilterLastMonth(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_lastmonth, textTitle: self.btn_filter_lastmonth)
        self.viewModel.report_type.accept(REPORT_TYPE_LAST_MONTH)
        self.viewModel.date_string.accept(lastMonth)
        self.reportRevenueByTime()
    }
    
  
    @IBAction func actionFilterThreeMonth(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_three_month, textTitle: self.btn_filter_three_month)
        self.viewModel.report_type.accept(REPORT_TYPE_THREE_MONTHS)
        self.viewModel.date_string.accept(lastThreeMonth)
        self.reportRevenueByTime()
    }
    
    @IBAction func actionFilterThisYear(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_this_year, textTitle: self.btn_filter_this_year)
        self.viewModel.report_type.accept(REPORT_TYPE_THIS_YEAR)
        self.viewModel.date_string.accept(currentYear)
        self.reportRevenueByTime()
    }
    
    @IBAction func actionFilterLastYear(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_last_year, textTitle: self.btn_filter_last_year)
        self.viewModel.report_type.accept(REPORT_TYPE_LAST_YEAR)
        self.viewModel.date_string.accept(lastYear)
        self.reportRevenueByTime()
    }
    
    @IBAction func actionFilterThreeYear(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_three_year, textTitle: self.btn_filter_three_year)
        self.viewModel.report_type.accept(REPORT_TYPE_THREE_YEAR)
        self.viewModel.date_string.accept(lastThreeYear)
        self.reportRevenueByTime()
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
        
        btn_filter_today.textColor = ColorUtils.main_color()
        btn_filter_yesterday.textColor = ColorUtils.main_color()
        btn_filter_thisweek.textColor = ColorUtils.main_color()
        btn_filter_thismonth.textColor = ColorUtils.main_color()
        btn_filter_lastmonth.textColor = ColorUtils.main_color()
        btn_filter_three_month.textColor = ColorUtils.main_color()
        btn_filter_this_year.textColor = ColorUtils.main_color()
        btn_filter_last_year.textColor = ColorUtils.main_color()
        btn_filter_three_year.textColor = ColorUtils.main_color()
        

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
        currentMonth = Utils.getCurrentMonthString()
        lastThreeYear = Utils.getLastThreeYearString()
        lastYear = Utils.getLastYearString()
        currentYear = Utils.getCurrentYearString()
        
        
    
//        let date = Date()
//        let calendar = Calendar.current
//        let month = calendar.component(.month, from: date)
//        let year = calendar.component(.year, from: date)
//        self.Week = calendar.component(.weekOfYear, from: date)
//        //Tuần này
//        self.thisWeek = String(format: "%d/%d", self.Week, year)
//        if self.thisWeek.count == 6 {
//            self.thisWeek = String(format: "0%d/%d", self.Week, year)
//        }
//        //Thang nay
//        self.monthCurrent = String(format: "%d/%d", month, year)
//        //
//        let tm = Calendar.current.date(byAdding: .month, value: 0, to: Date())
//        let tmFormatter : DateFormatter = DateFormatter()
//        tmFormatter.dateFormat = "MM/yyyy"
//        self.thisMonth = tmFormatter.string(from: tm!)
//        //Tháng trước
//        let lm = Calendar.current.date(byAdding: .month, value: -1, to: Date())
//        let monthFormatter : DateFormatter = DateFormatter()
//        monthFormatter.dateFormat = "MM/yyyy"
//        self.lastMonth = monthFormatter.string(from: lm!)
//        //Nam nay
//        self.yearCurrent = String(year)
//        //Nam truoc
//        let ly = Calendar.current.date(byAdding: .year, value: -1, to: Date())
//        let yearFormatter : DateFormatter = DateFormatter()
//        yearFormatter.dateFormat = "yyyy"
//        self.lastYear = yearFormatter.string(from: ly!)
//
//        //
//        let format = DateFormatter()
//        format.dateFormat = "dd/MM/YYYY"
//        let formattedDate = format.string(from: date)
//        self.dateTimeNow = formattedDate
//        //Hôm nay
//        let formatTime = DateFormatter()
//        formatTime.dateFormat = "HH:mm:ss"
//
//        today = formatTime.string(from: date)
//
//        //        lblCurrentTime.text = formatTime.string(from: date)
//        //Hôm qua
//        let y = Calendar.current.date(byAdding: .day, value: -1, to: Date())
//        let dateFormatter : DateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        self.yesterday = dateFormatter.string(from: y!)
        
    }

}
