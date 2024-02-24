//
//  OrderViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert
class OrderViewController: BaseViewController {
    var viewModel = OrderViewModel()
    private var router = OrderRouter()
    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var lbl_current_point: UILabel!
    
    @IBOutlet weak var lbl_current_amount: UILabel!
    @IBOutlet weak var root_view_filter: UIView!
    
    @IBOutlet weak var root_view_point: UIView!
   
    @IBOutlet weak var height_of_root_view_point: NSLayoutConstraint!
    
    
    @IBOutlet weak var view_btn_filter_all: UIView!
    @IBOutlet weak var view_btn_filter_my_order: UIView!
    @IBOutlet weak var view_btn_filter_opening: UIView!
    @IBOutlet weak var view_btn_filter_request_payment: UIView!
    @IBOutlet weak var view_btn_filter_waiting_payment: UIView!
    @IBOutlet weak var view_locked_order: UIView!
    @IBOutlet weak var view_nodata_order: UIView!

    @IBOutlet weak var view_btn_clear_search: UIView!
    
    @IBOutlet weak var btnFilterAll: UILabel!
    @IBOutlet weak var btnFilterMyOrder: UILabel!
    @IBOutlet weak var btnFilterOpening: UILabel!
    @IBOutlet weak var btnFilterRequestPayment: UILabel!
    @IBOutlet weak var btnFilterWaitingPayment: UILabel!
    
    @IBOutlet weak var textfield_search: UITextField!
    @IBOutlet weak var constraint_widht_search: NSLayoutConstraint!
    
    var search_string = ""
    var order_status = ""
    var keywords = ""
    var real_time_url = ""
//    var webSocket:WebSocket?
    let refreshControl = UIRefreshControl()
    
    
    var list_orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.isHideAllView(isHide: true, view: self.view_nodata_order)
        // Do any additional setup after loading the view.
//        Utils.isHideAllView(isHide: false, view: root_view_no_data)
        
        Utils.isHideAllView(isHide: true, view: view_locked_order)
        
        if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_FIVE){
            self.getCurrentPoint(employee_id: ManageCacheObject.getCurrentUser().id)
        }
        if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_THREE){
            Utils.isHideAllView(isHide: false, view: view_locked_order)
        }
        
        if(ManageCacheObject.getSetting().service_restaurant_level_id < GPQT_LEVEL_ONE){
            Utils.isHideAllView(isHide: true, view: view_btn_filter_all)
            Utils.isHideAllView(isHide: true, view: view_btn_filter_my_order)
            Utils.isHideAllView(isHide: true, view: view_btn_filter_opening)
            Utils.isHideAllView(isHide: true, view: view_btn_filter_request_payment)
            Utils.isHideAllView(isHide: true, view: view_btn_filter_waiting_payment)
            constraint_widht_search.constant = self.view.frame.size.width - 16
        }
        
//        if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE){
//            view_btn_filter_all.isHidden = true
//            view_btn_filter_my_order.isHidden = true
//            view_btn_filter_opening.isHidden = true
//            view_btn_filter_request_payment.isHidden = true
//            view_btn_filter_waiting_payment.isHidden = true
//            constraint_width_textfield_search.constant = self.view.frame.size.width - 16
//
//            constraint_widht_search.constant = self.view.frame.size.width - 16
//        }
        viewModel.bind(view: self, router: router)
        view_btn_filter_all.backgroundColor = ColorUtils.main_color()
        btnFilterAll.textColor = .white

        registerCell()
        bindTableViewData()
               
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        
//        textfield_search.rx.controlEvent(.editingChanged)
//                   .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
//                   .withLatestFrom(textfield_search.rx.text)
//               .subscribe(onNext:{ query in
//                   let orders = self.viewModel.allOrders.value
//                   if !query!.isEmpty{
//                       let filterOrders = orders.filter{ $0.table_name.contains(query!.uppercased()) || String($0.total_amount).contains((query?.uppercased())!)}
//                       dLog(filterOrders.toJSON())
//                       self.viewModel.dataArray.accept(filterOrders)
//                       Utils.isHideAllView(isHide: filterOrders.count > 0, view: self.view_nodata_order)
//                   }else{
//                       dLog(orders.toJSON())
//                       self.viewModel.dataArray.accept(orders)
//                       Utils.isHideAllView(isHide: orders.count > 0, view: self.view_nodata_order)
//                   }
//
//               }).disposed(by: rxbag)
        // search call API
        textfield_search
            .rx.text // Observable property thanks to RxCocoa
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .subscribe(onNext: { [unowned self] query in // Here we will be notified of every new value
                self.clearData()
                self.search_string = String(query ?? "").replacingOccurrences(of: "#", with: "")
                viewModel.key_word.accept(search_string)
                dLog(search_string)
                self.fetchOrders(key_word: search_string)
            }).disposed(by: rxbag)
        
//        textfield_search
//            .rx.text // Observable property thanks to RxCocoa
//            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
//            .subscribe(onNext: { [unowned self] query in // Here we will be notified of every new value
//                let orders = self.viewModel.allOrders.value
//                if !query!.isEmpty{
//
//
//                    let filterOrders = orders.filter({ (value) -> Bool in
//                        let str1 = query!.uppercased().applyingTransform(.stripDiacritics, reverse: false)!
//                        let str2 = value.table_name.uppercased().applyingTransform(.stripDiacritics, reverse: false)!
//                        return str2.contains(str1)
//                    })
//
//                    self.viewModel.dataArray.accept(filterOrders)
//                    Utils.isHideAllView(isHide: filterOrders.count > 0, view: self.view_nodata_order)
//
//                    //show button clear search
//                    view_btn_clear_search.isHidden = false
//
//                }else{
//                    dLog(orders.toJSON())
//                    self.viewModel.dataArray.accept(orders)
//                    Utils.isHideAllView(isHide: orders.count > 0, view: self.view_nodata_order)
//
//                    //hidden button clear search
//                    view_btn_clear_search.isHidden = true
//                }
//
//            }).disposed(by: rxbag)

    }
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
        dLog(ManageCacheObject.getCurrentBranch().toJSON())
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        
        fetchOrders(key_word: keywords)
      
        checkLevelShowCurrentPointOfEmployee()
        getCurrentPoint(employee_id: ManageCacheObject.getCurrentUser().id)
        
        lbl_current_point.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_target_point))
        lbl_current_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_bonus_salary))
        
        textfield_search.text = ""
        
       checkVersion()
        
        setupSocketIO()
        
    }
    
  
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SocketIOManager.shareSocketRealtimeInstance().socketRealTime!.emit("leave_room", real_time_url)
    }

    @IBAction func actionFilterAll(_ sender: Any) {
        order_status = String(format: "%d,%d,%d", ORDER_STATUS_OPENING, ORDER_STATUS_REQUEST_PAYMENT,ORDER_STATUS_WAITING_WAITING_COMPLETE)
        checkFilterSelected(view_selected: view_btn_filter_all, textTitle:btnFilterAll)
        viewModel.employee_id.accept(0)// get all
        self.fetchOrders(key_word:  textfield_search.text!)
    }
    
   
    @IBAction func actionFilterMyOrder(_ sender: Any) {
        order_status = ""
        viewModel.employee_id.accept(ManageCacheObject.getCurrentUser().id)// get only my order
        checkFilterSelected(view_selected: view_btn_filter_my_order, textTitle: self.btnFilterMyOrder)
        self.fetchOrders(key_word: textfield_search.text!)
    }
    @IBAction func actionFilterOpening(_ sender: Any) {
        order_status = String(format: "%d", ORDER_STATUS_OPENING)
        checkFilterSelected(view_selected: view_btn_filter_opening, textTitle: btnFilterOpening)
        viewModel.employee_id.accept(0)// get all
        self.fetchOrders(key_word:  textfield_search.text!)
    }
    @IBAction func actionFilterRequestPayment(_ sender: Any) {
        order_status = String(format: "%d", ORDER_STATUS_REQUEST_PAYMENT)
        checkFilterSelected(view_selected: view_btn_filter_request_payment, textTitle: btnFilterRequestPayment)
       
        viewModel.employee_id.accept(0)// get all
        self.fetchOrders(key_word:  textfield_search.text!)
    }
    
    @IBAction func actionFilterWaitingPayment(_ sender: Any) {
        order_status =  String(format: "%d",ORDER_STATUS_WAITING_WAITING_COMPLETE)
        
        checkFilterSelected(view_selected: view_btn_filter_waiting_payment, textTitle: btnFilterWaitingPayment)
      
        viewModel.employee_id.accept(0)// get all
        self.fetchOrders(key_word:  textfield_search.text!)
    }
   
    func checkFilterSelected(view_selected:UIView, textTitle:UILabel){
        view_btn_filter_all.backgroundColor = .white
        view_btn_filter_my_order.backgroundColor = .white
        view_btn_filter_opening.backgroundColor = .white
        view_btn_filter_request_payment.backgroundColor = .white
        view_btn_filter_waiting_payment.backgroundColor = .white
        
        btnFilterAll.textColor = ColorUtils.main_color()
        btnFilterMyOrder.textColor = ColorUtils.main_color()
        btnFilterRequestPayment.textColor = ColorUtils.main_color()
        btnFilterWaitingPayment.textColor = ColorUtils.main_color()
        btnFilterOpening.textColor = ColorUtils.main_color()

        textTitle.textColor = ColorUtils.white()
        view_selected.backgroundColor = ColorUtils.main_color()
    }
    
    
   
    @IBAction func actionClearSearch(_ sender: Any) {
        textfield_search.text = ""
        view_btn_clear_search.isHidden = true
        self.fetchOrders(key_word: "")
    }
    
}
extension OrderViewController{
        func registerCell() {
            let orderTableViewCell = UINib(nibName: "OrderTableViewCell", bundle: .main)
            tableView.register(orderTableViewCell, forCellReuseIdentifier: "OrderTableViewCell")
            
            self.tableView.estimatedRowHeight = 170
            self.tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            
            
            tableView.rx.modelSelected(Order.self) .subscribe(onNext: { element in
                print("Selected \(element)")
                if(element.order_status != ORDER_STATUS_WAITING_WAITING_COMPLETE){
                    self.viewModel.order_id.accept(element.id)
                    self.viewModel.table_name.accept(element.table_name)
                    self.viewModel.makeOrderDetailViewController()
                }else{
//                    Toast.show(message: "Đơn hàng đang chờ thu tiền bạn không được phép thao tác.", controller: self)
                    JonAlert.showError(message: "Đơn hàng đang chờ thu tiền bạn không được phép thao tác.",duration: 2.0)
                    
                }
                
            }).disposed(by: rxbag)
            tableView.rx.setDelegate(self).disposed(by: rxbag)
            refreshControl.attributedTitle = NSAttributedString(string: "")
            refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
            tableView.addSubview(refreshControl) // not required when using UItableViewController
        }
    
    @objc func refresh(_ sender: AnyObject) {
          // Code to refresh table view
           self.fetchOrders(key_word: keywords)
           refreshControl.endRefreshing()
    }
}
extension OrderViewController{
    
    private func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "OrderTableViewCell", cellType: OrderTableViewCell.self))
           {  (row, order, cell) in
               cell.data = order
               cell.viewModel = self.viewModel
               
               if(order.order_status == ORDER_STATUS_REQUEST_PAYMENT){
                   // check action avalible ?
                   cell.root_view_action.isHidden = false
                   cell.height_of_root_view_action.constant = 30
               }else if(order.order_status == ORDER_STATUS_WAITING_WAITING_COMPLETE){
                   cell.root_view_action.isHidden = true
                   cell.height_of_root_view_action.constant = 0
               }else{
                   // check action avalible ?
                   cell.root_view_action.isHidden = false
                   cell.height_of_root_view_action.constant = 30
               }
               
               if(ManageCacheObject.getSetting().service_restaurant_level_id < 2){
                   Utils.isHideAllView(isHide: true, view: cell.root_view_action_scan_bill)
               }else{
                 
                   // action scan bill
                   cell.btn_scan_bill.rx.tap.asDriver()
                                  .drive(onNext: { [weak self] in
                                      dLog("action scan bill")
                                      self!.viewModel.order_id.accept(order.id)
                                      self!.viewModel.table_name.accept(order.table_name)
                                      self?.viewModel.makeScanBillViewController()
                                  }).disposed(by: cell.disposeBag)
                   
               }
              
               // action gif food
               cell.btn_gif_food.rx.tap.asDriver()
                              .drive(onNext: { [weak self] in
                                  dLog("action gif food")
                                  if(Utils.checkRoleDiscountGifFood(permission: ManageCacheObject.getCurrentUser().permissions)){
                                      self!.viewModel.order_id.accept(order.id)
                                      self!.viewModel.table_name.accept(order.table_name)
                                      self!.viewModel.is_gift.accept(ADD_GIFT)
                                      self!.viewModel.makeNavigatorAddFoodViewController()
                                  }else{
                                      JonAlert.showError(message: "Hiện tại bạn chưa được cấp quyền sử dụng tính năng này. Vui lòng liên hệ quản lý để được cấp quyền!", duration: 2.0)
                                  }
                                 
                              }).disposed(by: cell.disposeBag)
               
               // action payment
               cell.btn_payment.rx.tap.asDriver()
                              .drive(onNext: { [weak self] in
                                  dLog("action payment")
//                                  if(order.is_allow_request_payment == ACTIVE){
                                      self!.viewModel.order_id.accept(order.id)
                                      self?.viewModel.makePayMentViewController()
//                                  }
                                 
                              }).disposed(by: cell.disposeBag)
               
               
               cell.btn_more_action.rx.tap.asDriver()
                              .drive(onNext: { [weak self] in
                                  if(Utils.checkRoleManagerOrder(permission: ManageCacheObject.getCurrentUser().permissions)){
                                      self!.presentModalMoreAction(order_id: order.id, destination_table_id:order.table_id, destination_table_name:order.table_name, employee: order.employee)
                                  }else{
                                      JonAlert.showError(message: "Hiện tại bạn chưa được cấp quyền sử dụng tính năng này. Vui lòng liên hệ quản lý để được cấp quyền!", duration: 2.0)
                                  }
                                 
                              }).disposed(by: cell.disposeBag)
               
               
               cell.btn_number_slot.rx.tap.asDriver()
                              .drive(onNext: { [weak self] in
                                  
                                  if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_TWO){
                                      if(ManageCacheObject.getSetting().is_require_update_customer_slot_in_order == ACTIVE){
                                          self?.viewModel.order_id.accept(order.id)
                                          self?.presentModalUpdateCustomerSlotViewController(current_quantity: order.using_slot)
                                      }else {
//                                          Toast.show(message: "Hiện tại nhà hàng chưa được bật tính năng nhập số người", controller: self!)
                                          JonAlert.showError(message: "Hiện tại nhà hàng chưa được bật tính năng nhập số người!", duration: 2.0)
                                      }
                                  }else {
//                                      Toast.show(message: "Vui lòng nâng cấp lên giải pháp quản trị", controller: self!)
                                      JonAlert.showError(message: "Vui lòng nâng cấp lên giải pháp quản trị!", duration: 2.0)
                                  }
                                  
                              }).disposed(by: cell.disposeBag)
               
               
               
           }.disposed(by: rxbag)
       }
}
extension OrderViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
}

extension OrderViewController{
    
    func fetchOrders(key_word:String){
        viewModel.order_status.accept(self.order_status)
        viewModel.key_word.accept(key_word)
        
        viewModel.getOrders().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let orders = Mapper<Order>().mapArray(JSONObject: response.data) {
                    var filterOrders:[Order] = []
                    if(orders.count > 0){
                        Utils.isHideAllView(isHide: true, view: view_nodata_order)
                        dLog(orders.toJSONString(prettyPrint: true) as Any)
                        
                        self.viewModel.allOrders.accept(orders)
//                        self.viewModel.dataArray.accept(orders)
                        //lọc các order theo tên bàn, id bàn, tổng số tiền,
                        for order in orders {
                            if (order.table_name.lowercased().contains(String(key_word).lowercased()) || String(format: "#%d", order.id ?? "").contains(key_word) || String(format: "%.0f", order.total_amount ?? "").contains(key_word)){
                                filterOrders.append(order)
                            }
                        }
                        if(!key_word.isEmpty){
                            Utils.isHideAllView(isHide: false, view: view_btn_clear_search)// hiện button clear từ khoá đang tìm kiếm
                            self.viewModel.dataArray.accept(filterOrders)// lưu và hiển thị các order đang tìm kiếm
                            if filterOrders.count == 0 {
                                Utils.isHideAllView(isHide: false, view: view_nodata_order)// hiện view thông báo không có đơn hàng
                            }
                        }else{
                            self.viewModel.dataArray.accept(orders)// lưu và hiển thị tất cả đơn hàng đang có
                            Utils.isHideAllView(isHide: true, view: view_btn_clear_search)
                        }
//
//                        if(key_word.count > 0){
//                            let filterOrders = orders.filter{ $0.table_name.contains(key_word.uppercased())}
//                            self.viewModel.dataArray.accept(filterOrders)
//                        }else{
//                            self.viewModel.dataArray.accept(orders)
//                        }
                  
                    }else{
                        Utils.isHideAllView(isHide: false, view: view_nodata_order)
//                        Utils.isHideView(isHide: true, view: self.root_view_no_data)
                        self.viewModel.dataArray.accept([])
                    }
                        
                }
               
                 
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
func assignCustomerToBill(){
        viewModel.assignCustomerToBill().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.viewModel.makeOrderDetailViewController()
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình giao tiếp với hệ thống. Vui lòng thử lại sau. ",duration: 2.0)

            }
         
        }).disposed(by: rxbag)
    }
    
    func closeTable(){
            viewModel.closeTable().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
//                    Toast.show(message: "Đóng bàn thành công", controller: self)
                    JonAlert.showSuccess(message: "Đóng bàn thành công!",duration: 2.0)
                    self.fetchOrders(key_word: "")
                }else{
                    dLog(response.message ?? "")
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình giao tiếp với hệ thống. Vui lòng thử lại sau. ",duration: 2.0)
                }
             
            }).disposed(by: rxbag)
        }

    func checkVersion(){
            viewModel.checkVersion().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    let _version  = Mapper<VersionModel>().map(JSON: response.data as! [String : Any])
                    
                    let isEqual = (Utils.version() == _version?.version)
                    if !isEqual {
                        
                        if(_version!.is_require_update == ACTIVE){
                           //show dialog update version
                            self.presentModalDialogUpdateVersionViewController(is_require_update: (_version?.is_require_update)!, content: (_version?.message)!)
                        }
                        
                        
                    }
                    
                }else{
                    dLog(response.message ?? "")
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
//                    Toast.show(message: response.message ?? "Có lỗi xảy ra trong quá trình giao tiếp với hệ thống. Vui lòng thử lại sau. ", controller: self)
                }
             
            }).disposed(by: rxbag)
        }
    
    func clearData(){
        viewModel.dataArray.accept([])
        viewModel.page.accept(1)
//        viewModel.isGetFullData.accept (false)
    }
}
