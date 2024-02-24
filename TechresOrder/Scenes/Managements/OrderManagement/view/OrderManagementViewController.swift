//
//  OrderManagementViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 25/01/2023.
//

import UIKit
import RxSwift

class OrderManagementViewController: BaseViewController {
    var viewModel = OrderManagementViewModel()
    var router = OrderManagementRouter()
    
    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var lbl_nodata_order: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var view_nodata_order: UIView!

    @IBOutlet weak var btn_filter_today: UILabel!
    @IBOutlet weak var btn_filter_yesterday: UILabel!
    @IBOutlet weak var btn_filter_thisweek: UILabel!
    @IBOutlet weak var btn_filter_thismonth: UILabel!
    @IBOutlet weak var btn_filter_lastmonth: UILabel!
    @IBOutlet weak var btn_filter_three_month: UILabel!
    @IBOutlet weak var btn_filter_this_year: UILabel!
    @IBOutlet weak var btn_filter_last_year: UILabel!
    @IBOutlet weak var btn_filter_three_year: UILabel!
    @IBOutlet weak var btn_filter_All_year: UILabel! // them tat ca cac nam
    
    @IBOutlet weak var view_filter_today: UIView!
    @IBOutlet weak var view_filter_yesterday: UIView!
    @IBOutlet weak var view_filter_thisweek: UIView!
    @IBOutlet weak var view_filter_thismonth: UIView!
    @IBOutlet weak var view_filter_last_month: UIView!
    @IBOutlet weak var view_filter_three_month: UIView!
    @IBOutlet weak var view_filter_this_year: UIView!
    @IBOutlet weak var view_filter_last_year: UIView!
    @IBOutlet weak var view_filter_three_year: UIView!
    @IBOutlet weak var view_filter_All_year: UIView! // them tat ca cac nam
    
    @IBOutlet weak var btnFilterToday: UIButton!
    @IBOutlet weak var btnFilterYesterday: UIButton!
    @IBOutlet weak var btnFilterThisweek: UIButton!
    @IBOutlet weak var btnFilterThismonth: UIButton!
    @IBOutlet weak var btnFilterThreeMonth: UIButton!
    @IBOutlet weak var btnFilterThisYear: UIButton!
    @IBOutlet weak var btnFilterLastYear: UIButton!
    @IBOutlet weak var btnFilterThreeYear: UIButton!
    @IBOutlet weak var btnFilterAllyear: UIButton! // them tat ca cac nam
    
    @IBOutlet weak var temp_revenue: UILabel!
    @IBOutlet weak var total_order_number: UILabel!
    
    
    @IBOutlet weak var text_field_search: UITextField!
    
    
    
    
    @IBOutlet weak var view_clear_search: UIView!
    var report_type = 1
    var time = ""
    var limit = 50
    var page = 1
    var search_string = ""
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view_clear_search.isHidden = true

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        registerCell()
        bindTableViewData()
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UItableViewController
        
        // search call API
        text_field_search.rx.controlEvent(.editingChanged)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(text_field_search.rx.text)
            .subscribe (onNext:{ [self] query in
            self.clearData()
                self.search_string = String(query ?? "").replacingOccurrences(of: "#", with: "")
            viewModel.key_search.accept(search_string)
            self.ordersHistory()    
        }).disposed (by: rxbag)
    }
        // search local
//        text_field_search.rx.controlEvent(.editingChanged)
//                   .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
//                   .withLatestFrom(text_field_search.rx.text)
//               .subscribe(onNext:{ query in
//                   let orders = self.viewModel.allOrders.value
//
//                   if !query!.isEmpty{
//
//                       self.view_clear_search.isHidden = false
//                       var totalAmount = 0
//                       var count = 0
//                       let filterOrders = orders.filter{ $0.table_name.lowercased().contains(String(query!).lowercased()) || String(format: "#%d", $0.id ?? "").contains(query!) || String(format: "%.0f", $0.total_amount ?? "").contains(query!) || $0.employee.name.lowercased().contains(String(query!).lowercased()) || $0.payment_date.components(separatedBy: " ")[0].contains(String(query!))}
//                       dLog(filterOrders.toJSON())
//
//                       self.viewModel.dataArray.accept(filterOrders)
//                       self.viewModel.key_search.accept(query!)
//                       //cập nhật lại số tiền và số đơn theo hoá đơn được tìm kiếm
//                       for order in orders {
//                           if (order.table_name.lowercased().contains(String(query!).lowercased()) || String(format: "#%d", order.id ?? "").contains(query!) || String(format: "%.0f", order.total_amount ?? "").contains(query!) || order.employee.name.lowercased().contains(String(query!).lowercased()) || order.payment_date.components(separatedBy: " ")[0].contains(String(query!))){
//
//
//                               totalAmount += Int(order.total_amount)
//                               count += 1
//                               self.temp_revenue.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(totalAmount))
//                               self.total_order_number.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: count)
//                           }else{
//
//                               self.temp_revenue.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(totalAmount))
//                               self.total_order_number.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: count)
//                           }
//
//                       }
//
//
//                       Utils.isHideAllView(isHide: self.viewModel.dataArray.value.count > 0 ? true: false , view: self.view_nodata_order)
//
//                   }else{
//                       var totalAmount = 0
//                       var count = 0
//                       //khi query empty thì hiện tổng hoá đơn1
//                       for order in orders {
//                           if !(order.table_name.lowercased().contains(String(query!).lowercased()) || String(format: "#%d", order.id ?? "").contains(query!) || String(format: "%.0f", order.total_amount ?? "").contains(query!) || order.employee.name.lowercased().contains(String(query!).lowercased()) || order.payment_date.components(separatedBy: " ")[0].contains(String(query!))){
//
//
//                               totalAmount += Int(order.total_amount)
//                               count += 1
//                               self.temp_revenue.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(totalAmount))
//                               self.total_order_number.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: count)
//                           }
//
//                       }
//                       self.view_clear_search.isHidden = true
//                       dLog(orders.toJSON())
//                       self.viewModel.dataArray.accept(orders)
//
////                       if self.viewModel.dataArray.value.count > 0 {
////                           self.view_nodata_order.isHidden = true
////                       }else{
////                           self.view_nodata_order.isHidden = false
////
////                       }
//                       Utils.isHideAllView(isHide: self.viewModel.dataArray.value.count > 0 ? true: false , view: self.view_nodata_order)
//                   }
//
//
//               }).disposed(by: rxbag)
//
//        self.view_nodata_order.isHidden = false
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkFilterSelected(view_selected: view_filter_today, textTitle:btn_filter_today)
        viewModel.id.accept(ManageCacheObject.getCurrentUser().id)
        viewModel.report_type.accept(report_type)
        viewModel.time.accept(Utils.dateToString(date: Date()))
        self.ordersHistory()
    }

    @objc func refresh(_ sender: AnyObject) {
          // Code to refresh table view
        self.ordersHistory()
        refreshControl.endRefreshing()
    }
    @IBAction func actionClearSearch(_ sender: Any) {
        view_clear_search.isHidden = true
        text_field_search.text = ""
        viewModel.key_search.accept("")
        self.ordersHistory()
    }
    func clearData(){
        viewModel.dataArray.accept([])
        viewModel.page.accept(1)
        viewModel.isGetFullData.accept (false)
    }
    
}
