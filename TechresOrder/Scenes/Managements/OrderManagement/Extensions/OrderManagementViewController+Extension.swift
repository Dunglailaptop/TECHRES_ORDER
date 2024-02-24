//
//  OrderManagementViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 25/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper

extension OrderManagementViewController {
    @IBAction func actionFilterToday(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_today, textTitle:btn_filter_today)
        viewModel.time.accept(Utils.dateToString(date: Date()))
        report_type = 1
        viewModel.report_type.accept(report_type)
        viewModel.key_search.accept(self.text_field_search.text ?? "")
        //CALL API GET ORDERS
        self.ordersHistory()
    }
    
    @IBAction func actionFilterYesterday(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_yesterday, textTitle:btn_filter_yesterday)
        report_type = 9
        viewModel.report_type.accept(report_type)
        viewModel.key_search.accept(self.text_field_search.text ?? "")
        //CALL API GET ORDERS
            self.ordersHistory()
    }
    
    @IBAction func actionFilterThisWeek(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_thisweek, textTitle:btn_filter_thisweek)
        report_type = 2
        viewModel.report_type.accept(report_type)
        viewModel.key_search.accept(self.text_field_search.text ?? "")
        //CALL API GET ORDERS
            self.ordersHistory()
    }
    
    @IBAction func actionFilterThisMonth(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_thismonth, textTitle:btn_filter_thismonth)
        report_type = 3
        viewModel.report_type.accept(report_type)
        viewModel.key_search.accept(self.text_field_search.text ?? "")
        //CALL API GET ORDERS
            self.ordersHistory()
    }
    
    @IBAction func actionFilterThisyear(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_this_year, textTitle:btn_filter_this_year)
        report_type = 5
        viewModel.report_type.accept(report_type)
        viewModel.key_search.accept(self.text_field_search.text ?? "")
        //CALL API GET ORDERS
            self.ordersHistory()
    }
    
    @IBAction func actionFilterLastMonth(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_last_month, textTitle:btn_filter_lastmonth)
        report_type = 10
        viewModel.report_type.accept(report_type)
        viewModel.key_search.accept(self.text_field_search.text ?? "")
        //CALL API GET ORDERS
            self.ordersHistory()
    }
    
    @IBAction func actionFilterThreeMonth(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_three_month, textTitle:btn_filter_three_month)
        report_type = 4
        viewModel.report_type.accept(report_type)
        viewModel.key_search.accept(self.text_field_search.text ?? "")
        //CALL API GET ORDERS
            self.ordersHistory()
    }
    
    @IBAction func actionFilterLastYear(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_last_year, textTitle:btn_filter_last_year)
        report_type = 11
        viewModel.report_type.accept(report_type)
        viewModel.key_search.accept(self.text_field_search.text ?? "")
        //CALL API GET ORDERS
            self.ordersHistory()
    }
    
    @IBAction func actionFilterThreeYear(_ sender: Any) {
        checkFilterSelected(view_selected: view_filter_three_year, textTitle:btn_filter_three_year)
        report_type = 6
        viewModel.report_type.accept(report_type)
        viewModel.key_search.accept(self.text_field_search.text ?? "")
        //CALL API GET ORDERS
            self.ordersHistory()
    }
    
    // Thêm action cho tất cả các năm
    @IBAction func actionAllYear(_ sender:Any){
        checkFilterSelected(view_selected: view_filter_All_year, textTitle: btn_filter_All_year)
        report_type = 8
        viewModel.report_type.accept(report_type)
        viewModel.key_search.accept(self.text_field_search.text ?? "")
        //CALL API GET ORDERS
        self.ordersHistory()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.viewModel.makePopViewController()
    }
    
    func checkFilterSelected(view_selected:UIView, textTitle:UILabel){
        view_filter_today.backgroundColor = .white
        view_filter_yesterday.backgroundColor = .white
        view_filter_thisweek.backgroundColor = .white
        view_filter_thismonth.backgroundColor = .white
        view_filter_last_month.backgroundColor = .white
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
extension OrderManagementViewController{
        func registerCell() {
            let orderManagementTableViewCell = UINib(nibName: "OrderManagementTableViewCell", bundle: .main)
            tableView.register(orderManagementTableViewCell, forCellReuseIdentifier: "OrderManagementTableViewCell")
            self.tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            
            
            tableView.rx.modelSelected(Order.self) .subscribe(onNext: { element in
                self.viewModel.order_id.accept(element.id)
                self.viewModel.makePayMentViewController()
            }).disposed(by: rxbag)
            
            tableView.rx.setDelegate(self).disposed(by: rxbag)
        }
    
    func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "OrderManagementTableViewCell", cellType: OrderManagementTableViewCell.self))
           {  (row, order, cell) in
               cell.data = order
               cell.viewModel = self.viewModel           
           }.disposed(by: rxbag)
       }
    
}
extension OrderManagementViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
extension OrderManagementViewController{
    
    public func ordersHistory(){
        viewModel.orders().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let orderData = Mapper<OrderData>().map(JSONObject: response.data) {
                    dLog(orderData)
                    if let orders = orderData.orders{
                        var totalAmount = 0
                        
                        var filterOrders:[Order] = []
                        var totalAmountFilter = 0
                        var count = 0
                        let query = self.viewModel.key_search.value
                        if(orders.count > 0){
                            Utils.isHideAllView(isHide: true, view: self.view_nodata_order)
                            if(self.viewModel.allOrders.value.count == 0){
                                self.viewModel.allOrders.accept(orders)
                            }
                            
                            dLog(orders.toJSONString(prettyPrint: true) as Any)
                            
                            
                            for order in orders {
                                totalAmount += Int(order.total_amount)
                                
                                if(!query.isEmpty){
                                    if (order.table_name.lowercased().contains(String(query).lowercased()) || String(format: "#%d", order.id ?? "").contains(query) || String(format: "%.0f", order.total_amount ?? "").contains(query) || order.employee.name.lowercased().contains(String(query).lowercased()) || order.payment_date.components(separatedBy: " ")[0].contains(String(query))){
                                        filterOrders.append(order)
                                        totalAmountFilter += Int(order.total_amount)
                                        count += 1
                                        self.temp_revenue.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(totalAmountFilter))
                                        self.total_order_number.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: count)
                                    }
                                    if count == 0{
                                        self.temp_revenue.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(0))
                                        self.total_order_number.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: 0)
                                    }
                                    
                                    Utils.isHideAllView(isHide: count > 0 ? true: false , view: self.view_nodata_order)
                                }
                                
                            }
                            if (!query.isEmpty) {
                                self.viewModel.allOrders.accept(orders)
                                self.viewModel.dataArray.accept(filterOrders)
                                
                                dLog(filterOrders)
                                 
                            }else{
                                self.viewModel.allOrders.accept(orders)
                                self.viewModel.dataArray.accept(orders)
                                dLog(orders)
                                self.temp_revenue.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(totalAmount))
                                self.total_order_number.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: orders.count)
                            }
                            
                        }else{
                            Utils.isHideAllView(isHide: false, view: self.view_nodata_order)
                            self.temp_revenue.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(totalAmount))
                            self.total_order_number.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: 0)
                            self.viewModel.dataArray.accept([])
                            self.viewModel.allOrders.accept([])
                        }
                    }
                  
                        
                }
               
                 
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
}
