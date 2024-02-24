//
//  OrderDetailViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit
import ObjectMapper
import JonAlert


class OrderDetailViewController: BaseViewController {
    var order_id = 0
    var viewModel = OrderDetailViewModel()
    var router = OrderDetailRouter()
    var branch_id = 0
    var table_name = ""
    var table_id = 0
    var area_id = 0
    var numberPrint = 0
    var order_details = [OrderDetail]()
    var booking_status = 0
    
    @IBOutlet var view_number_update: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl_order_code: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lbl_number_need_update: UILabel!
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    @IBOutlet var view_number_update_food: UIView!
    @IBOutlet weak var lbl_number_food_need_update: UILabel!
    
    @IBOutlet var root_view_number_update_food: UIView!
    @IBOutlet weak var btnSentUpdate: UIButton!
    @IBOutlet weak var imageSentUpdate: UIImageView!
    
    @IBOutlet var root_view_sent_chef_bar: UIView!
    @IBOutlet weak var image_sent_chef: UIImageView!
    @IBOutlet weak var btnSentChef: UIButton!
    
    @IBOutlet var root_view_review_food: UIView!
    @IBOutlet weak var btnReviewFood: UIButton!
    
    
    @IBOutlet weak var btnAddOtherFood: UIButton!
    @IBOutlet weak var btnAddFood: UIButton!
    @IBOutlet weak var btnSplitFood: UIButton!
    @IBOutlet weak var btnAddGiftFood: UIButton!
    @IBOutlet weak var btnPaymentFood: UIButton!
    @IBOutlet weak var lbl_total_estimate: UILabel!
    @IBOutlet weak var height_total_estimate_constraint: NSLayoutConstraint!

    @IBOutlet weak var height_tableview_order_detail_constraint: NSLayoutConstraint!

    @IBOutlet weak var root_view_action: UIView!
    
    var numberNeedUpdate = 0
    //======== Printer ==========
    var orderData = OrderDetailData.init()
    
    let PAGE_AREA_HEIGHT: Int = 500
    let PAGE_AREA_WIDTH: Int = 500
    let FONT_A_HEIGHT: Int = 24
    let FONT_A_WIDTH: Int = 12
    let BARCODE_HEIGHT_POS: Int = 70
    let BARCODE_WIDTH_POS: Int = 110
   //var printer:Epos2Printer?
    var print_foods = [Food]()
    var note_return = ""
    var list_food_prints = [Food]()
    var list_drink_prints = [Food]()
    
    var food_prepare_prints = [Food]()
    
    let left_space = 27
    
    var is_callback_add_food = 0
    
    let host = "172.16.1.233"
    let port = 9100
    var client: TCPClient?
    var real_time_url = ""
    var isFirst = ACTIVE
    //======= End Printer ========
    
    
    func isHideRootChefBar(isHide:Bool){
        root_view_sent_chef_bar.isHidden = isHide
        image_sent_chef.isHidden = isHide
        btnSentChef.isHidden = isHide
        view_number_update.isHidden = isHide
        lbl_number_need_update.isHidden = isHide
    }
    
    func isHideRootUpdateFood(isHide:Bool){
        root_view_number_update_food.isHidden = isHide
//        root_view_review_food.isHidden = !isHide
        
//        Utils.isHideAllView(isHide: !isHide, view: root_view_review_food)
        
        imageSentUpdate.isHidden = isHide
        btnSentUpdate.isHidden = isHide
        view_number_update_food.isHidden = isHide
        lbl_number_food_need_update.isHidden = isHide
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.branch_id = ManageCacheObject.getCurrentBranch().id
        // Do any additional setup after loading the view.
        
        
        
        
//        ManagerRealmHelper.shareInstance().getFoods()
       
        
        viewModel.bind(view: self, router: router)
        viewModel.order_id.accept(order_id)
        viewModel.branch_id.accept(branch_id)
        
        registerCell()
        bindTableViewData()
        
        view_number_update.isHidden = true
        view_number_update_food.isHidden = true
        
        
        viewModel.isChange.subscribe( // Thực hiện subscribe Observable
          onNext: { [weak self] isChange in
              self?.CountSave()
          }).disposed(by: rxbag)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(giftFoodNoteUpdate(_:)), name: NSNotification.Name(rawValue: "GIFT_FOOD_NOTE_UPDATE_QUANTITY"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cancelFoodWhenQuantitySub(_:)), name: NSNotification.Name(rawValue: "CANCEL_FOOD"), object: nil)
      
        
        // action scan bill
        btnReviewFood.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           dLog("action review food")
                           self!.presentModalReviewFoodViewController(order_id: self!.order_id)
                       }).disposed(by: rxbag)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHideRootChefBar(isHide: true)
        self.isHideRootUpdateFood(isHide: true)
        Utils.isHideView(isHide: true, view: root_view_review_food)
        
//        if(isFirst == ACTIVE){
//            isFirst = DEACTIVE
//            self.setupSocketIO()
//        }
        
        self.setupSocketIO()
        
        if(self.order_id != 0){
            getOrder()
        }else{
//            Toast.show(message: "Vui lòng mở bàn trước khi order", controller: self)
            JonAlert.showError(message: "Vui lòng mở bàn trước khi order!", duration: 2.0)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isFirst = ACTIVE
      let  real_time_url = String(format: "%@/%d/%@/%d/%@/%d","restaurants", ManageCacheObject.getCurrentUser().restaurant_id,"branches", ManageCacheObject.getCurrentUser().branch_id,"orders",self.order_id)
        dLog(real_time_url)
        SocketIOManager.shareSocketRealtimeInstance().socketRealTime!.emit("leave_room", real_time_url)
        
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        
        let order_details = viewModel.dataArray.value
        var nDem = 0
        for index in 0..<order_details.count {
            if(order_details[index].isChange == 1) {
               nDem += 1
            }
        }
        if(nDem > 0){
            self.presentModalDialogConfirmViewController(dialog_type: ACTIVE, title: "THÔNG BÁO LƯU ĐƠN HÀNG", content: "Đơn hàng chưa được lưu bạn có muốn lưu lại không?")
        }else{
            viewModel.makePopViewController()
        }
        
    }
    
    @IBAction func actionAddOtherFood(_ sender: Any) {
        if(self.orderData?.booking_status != STATUS_TABLE_BOOKING || self.orderData?.booking_status == STATUS_BOOKING_WAITING_COMPLETE){
            
            //Check có quyền mới cho dùng chức năng này
            if(Utils.checkRoleAddCustomFood(permission: ManageCacheObject.getCurrentUser().permissions)){
                viewModel.table_name.accept(self.table_name)
                viewModel.order_id.accept(self.order_id)
                viewModel.makeNavigatorAddOtherOrExtraFoodViewController()
            }else{
                JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)
            }
            
        }else{
            JonAlert.showSuccess(message: "Bàn booking chưa nhận khách bạn không được phép thao tác", duration: 2.0)
        }
       
       
    }
    
    @IBAction func actionAddFood(_ sender: Any) {
        viewModel.area_id.accept(self.area_id)
        viewModel.table_name.accept(self.table_name)
        viewModel.order_id.accept(self.order_id)
        viewModel.is_gift.accept(ADD_FOOD)
        viewModel.booking_status.accept(booking_status)
        viewModel.makeNavigatorAddFoodViewController()
    }
    
    @IBAction func actionAddGifFood(_ sender: Any) {
        // check quyền trước khi thực hiện tặng món
        if(Utils.checkRoleDiscountGifFood(permission: ManageCacheObject.getCurrentUser().permissions)){
            viewModel.area_id.accept(self.area_id)
            viewModel.table_name.accept(self.table_name)
            viewModel.order_id.accept(self.order_id)
            viewModel.is_gift.accept(ADD_GIFT)
            viewModel.makeNavigatorAddFoodViewController()
        }else{
            JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)
        }
       
    }
    
    @IBAction func actionPayment(_ sender: Any) {
        viewModel.order_id.accept(self.order_id)
        viewModel.makePayMentViewController()
    }
    
    @IBAction func actionSplitFood(_ sender: Any) {
        // check quyền trước khi thực hiện chia món
        if(Utils.checkRoleManagerOrder(permission: ManageCacheObject.getCurrentUser().permissions)){
            self.presentModalSeparateFoodViewController(table_name: table_name, table_id:table_id)
        }else{
            JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)
        }
       
    }
    
    @IBAction func actionUpdateFood(_ sender: Any) {
        // CALL API UPDATE QUANTITY FOOD ORDER HERE...
        self.repairUpdateFoods()
        self.updateFoodsToOrder()
        
    }
    @IBAction func actionSentChefBar(_ sender: Any) {
        // CALL API UPDATE QUANTITY FOOD ORDER HERE...
        // CALL API SENT CHEF BAR  HERE...
        self.repairUpdateFoods()
        if(viewModel.dataUpdateFoodsRequest.value.count > 0){
            self.updateFoodsToOrder()
        }
       
        
        checkPrintChefBar()

       
        
    }
    func checkPrintChefBar(){
        if(self.numberPrint > 0){
            if (ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_TWO && ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE) || (ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_THREE && ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE) {
               
                self.getFoodsNeedPrint(print_type: PRINT_TYPE_ADD_FOOD)
                
            } else {
                // only level 2 & option 2 then print via app thu ngan windows
                if (ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_TWO) {
                    //Call API request windows cashier application print
                    
                    // set để báo app thu ngân biết là in phiếu chế biến món mới
                    self.viewModel.print_type.accept(PRINT_TYPE_REQUEST_NEW_FOOD)
                    requestPrintChefBar()
                
                } else if (ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE) {// if option one print via mobile
                    self.getFoodsNeedPrint(print_type: PRINT_TYPE_ADD_FOOD)
                    
                }
                
            }
        }
    }
    func setupData(orderData:OrderDetailData){
        
        if(orderData.status == ORDER_STATUS_REQUEST_PAYMENT){
            self.btnAddOtherFood.setImage(UIImage(named: "icon-order-detail-add-other-food-request-payment"), for: .normal)
            self.btnAddFood.setImage(UIImage(named: "icon-order-detail-add-food-request-payment"), for: .normal)
            self.btnSplitFood.setImage(UIImage(named: "icon-order-detail-split-food-request-payment"), for: .normal)
            self.btnAddGiftFood.setImage(UIImage(named: "icon-order-detail-add-gift-food-request-payment"), for: .normal)
            self.btnPaymentFood.setImage(UIImage(named: "icon-order-detail-payment-request-payment"), for: .normal)
            self.lbl_order_code.textColor = ColorUtils.main_color()
        }else{
            
            self.btnAddOtherFood.setImage(UIImage(named: "icon-order-detail-add-other-food-opening"), for: .normal)
            self.btnAddFood.setImage(UIImage(named: "icon-order-detail-add-food-opening"), for: .normal)
            self.btnSplitFood.setImage(UIImage(named: "icon-order-detail-split-food-opening"), for: .normal)
            self.btnAddGiftFood.setImage(UIImage(named: "icon-order-detail-add-gift-food-opening"), for: .normal)
            self.btnPaymentFood.setImage(UIImage(named: "icon-order-detail-payment-opening"), for: .normal)
            self.lbl_order_code.textColor = ColorUtils.textLabelBlue()
            
            btnAddOtherFood.isEnabled = orderData.booking_status == STATUS_BOOKING_SET_UP ? false : true
            btnSplitFood.isEnabled = orderData.booking_status == STATUS_BOOKING_SET_UP ? false : true
            btnAddGiftFood.isEnabled = orderData.booking_status == STATUS_BOOKING_SET_UP ? false : true
//            btnPaymentFood.isEnabled = orderData.booking_status == STATUS_BOOKING_SET_UP ? false : true

        }
        
        
        if(ManageCacheObject.getSetting().is_hide_total_amount_before_complete_bill == ACTIVE && !Utils.checkRoleOwnerAndGeneralManager(permission: ManageCacheObject.getCurrentUser().permissions)){
            if(orderData.amount > 1000){
                self.lbl_total_estimate.text = Utils.hideTotalAmount(amount: Float(orderData.amount))
            }else{
                self.lbl_total_estimate.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(orderData.amount))
            }
        }else{
            self.lbl_total_estimate.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(orderData.amount))
        }
        
       
        
        
        if(ManageCacheObject.getSetting().is_hide_total_amount_before_complete_bill == ACTIVE && !Utils.checkRoleOwnerAndGeneralManager(permission: ManageCacheObject.getCurrentUser().permissions)){
            if(orderData.total_amount > 1000){
                self.lbl_total_amount.text = Utils.hideTotalAmount(amount: Float(orderData.total_amount))
            }else{
                self.lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(orderData.total_amount))
            }
        }else{
            self.lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(orderData.total_amount))
        }
        
        if(orderData.status == ORDER_STATUS_REQUEST_PAYMENT){
            self.btnBack.setImage(UIImage(named: "icon-prev"), for: .normal)
        }
        
        self.lbl_order_code.text = String(format: "#%d %@", orderData.id, self.table_name)
    }

}
extension OrderDetailViewController{
    func registerCell() {
        let orderDetailTableViewCell = UINib(nibName: "OrderDetailTableViewCell", bundle: .main)
        tableView.register(orderDetailTableViewCell, forCellReuseIdentifier: "OrderDetailTableViewCell")
        
        let orderDetailCompletedTableViewCell = UINib(nibName: "OrderDetailCompletedTableViewCell", bundle: .main)
        tableView.register(orderDetailCompletedTableViewCell, forCellReuseIdentifier: "OrderDetailCompletedTableViewCell")
        
        
//        self.tableView.estimatedRowHeight = 170
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rx.setDelegate(self).disposed(by: rxbag)
    }
    
    private func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "OrderDetailTableViewCell", cellType: OrderDetailTableViewCell.self))
           {  (row, orderDetail, cell) in
               cell.data = orderDetail
               cell.viewModel = self.viewModel
            
               cell.preservesSuperviewLayoutMargins = false
               cell.separatorInset = UIEdgeInsets.zero
               cell.layoutMargins = UIEdgeInsets.zero

               switch  orderDetail.status {
                   case 0:
                       cell.view_color_trailing_scroll.backgroundColor = ColorUtils.gray_600()
                       cell.view_color_trailing_scroll.isHidden = false
                   case 2:
                        cell.view_color_trailing_scroll.backgroundColor = ColorUtils.green_600()
                        cell.view_color_trailing_scroll.isHidden = false
                   case 4:
                        cell.view_color_trailing_scroll.backgroundColor = ColorUtils.red_500()
                        cell.view_color_trailing_scroll.isHidden = true
                   default:
                       return
               }
               if (self.booking_status == STATUS_BOOKING_SET_UP && orderDetail.category_type == DRINK){
                   cell.view_color_trailing_scroll.backgroundColor = ColorUtils.gray_600()
                   if (orderDetail.status == DONE){
                       cell.view_color_trailing_scroll.backgroundColor = ColorUtils.red_500()
                   }
               }else if (self.booking_status == STATUS_BOOKING_SET_UP && orderDetail.category_type != DRINK){
                   cell.view_color_trailing_scroll.isHidden = true
               }
               //Không tăng giảm số lượng món ăn khi đang booking
               if (self.booking_status == STATUS_BOOKING_SET_UP && orderDetail.category_type == FOOD){
                   cell.btnSub.isHidden = true
                   cell.btnAdd.isHidden = true
                   cell.btnQuantity.isUserInteractionEnabled = false
               }
               
               
               cell.btnQuantity.rx.tap.asDriver()
                              .drive(onNext: { [weak self] in
                                  if(orderDetail.is_gift != 1){// món tặng không được phép chỉnh sửa số lượng
                                      self!.presentModalInputQuantityViewController(position: row)
                                  }else{
                                      JonAlert.showError(message: "Món tặng không được phép thay đổi số lượng", duration: 3.0)
                                  }
                                 
                              }).disposed(by: cell.disposeBag)
               
               
           }.disposed(by: rxbag)
       }
}
//MARK: CALL API GET & UPDATE DATA
extension OrderDetailViewController{
    func getOrder(){
        viewModel.getOrder().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get order Success...")
                if let orderDetailData  = Mapper<OrderDetailData>().map(JSONObject: response.data){
                    if(orderDetailData.status == ORDER_STATUS_COMPLETE
                    || orderDetailData.status == ORDER_STATUS_WAITING_WAITING_COMPLETE){
                        Utils.isHideAllView(isHide: true, view: self.root_view_action)
                    }else{
                        Utils.isHideAllView(isHide: false, view: self.root_view_action)
                        self.orderData = orderDetailData
                        self.setupData(orderData: orderDetailData)
                        self.area_id = orderDetailData.area_id
                        self.table_name = orderDetailData.table_name
                        self.table_id = orderDetailData.table_id
                        self.order_id = orderDetailData.id
                        self.booking_status = orderDetailData.booking_status
                        dLog(orderDetailData.toJSON())
                        
                        if(orderDetailData.is_allow_review == ACTIVE){
                            Utils.isHideAllView(isHide: false, view: (self.root_view_review_food)!)
                            self.height_total_estimate_constraint.constant = 120

                            //Chỉnh sửa bottom của tableView
                            // Lấy contentInset hiện tại
                            var currentInsets = self.tableView.contentInset
                            // Chỉnh sửa khoảng cách dưới (bottom)
                            let newBottomInset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: currentInsets.bottom + 45, right: 0)
                            currentInsets.bottom = newBottomInset.bottom
                            // Thiết lập contentInset mới cho UITableView
                            self.tableView.contentInset = currentInsets
                            
                        }else{
                            Utils.isHideAllView(isHide: true, view: (self.root_view_review_food)!)
                            self.height_total_estimate_constraint.constant = 10
                        }
                        self.viewModel.dataArray.accept(orderDetailData.order_details)
                        self.checkNumberNeedPrint(order: orderDetailData)
                        self.CountSave(order: orderDetailData)
                        //Nếu bàn booking thì sẽ lấy thêm các món ăn
                        if (self.booking_status == STATUS_BOOKING_SET_UP){
                            self.getFoodBookingStatus()
                        }
                    }
                    
                }

            }
        }).disposed(by: rxbag)
        
    }
    func getFoodBookingStatus(){
        viewModel.getFoodBookingStatus().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get order booking status Success...")
                if let orderDetailData  = Mapper<OrderDetail>().mapArray(JSONObject: response.data){
                    let orderDetail: [OrderDetail] = orderDetailData
                    let dataArray: [OrderDetail] = self.viewModel.dataArray.value
                    let orderDetailBooking = orderDetail + dataArray
                    self.viewModel.dataArray.accept(orderDetailBooking)
                }
            }
        }).disposed(by: rxbag)
        
    }
    func getFoodsNeedPrint(print_type:Int){
            viewModel.getFoodsNeedPrint().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    dLog("Get order Success...")
                    if let foods_need_print  = Mapper<Food>().mapArray(JSONObject: response.data){
                        if(print_type == PRINT_TYPE_ADD_FOOD){
                            dLog(foods_need_print.toJSON())
                            self.print_foods = foods_need_print
                            
                        }else{// Xử lý in phiếu món huỷ/trả luôn chứ ko in những món khác
                            let order_detail_id = self.viewModel.order_detail_id.value
                            
                            self.print_foods = foods_need_print.filter({$0.id == order_detail_id})

                        }
                        if(self.print_foods.count > 0){
                            if(self.print_foods[0].category_type == TYPE_COOKED){
                               self.runPrinterChefSequence(food_prints: self.print_foods, print_type: print_type)
                                    debugPrint("Printing chef..........")
                            }else{
                                self.runPrinterBarSequence(food_prints: self.print_foods, print_type: print_type)
                                    debugPrint("Printing bar..........")
                            }
                        }
                        var order_details = [Int]()
                        for i in self.print_foods {
                            order_details.append(i.id)
                        }
                        
                        if ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE {
                            if(order_details.count > 0){
                                self.viewModel.order_detail_ids.accept(order_details)
                                self.updateReadyPrinted()
                            }
                           
                        }
                        if ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE {
                            if(order_details.count > 0){
                                self.viewModel.order_detail_ids.accept(order_details)
                                self.updateReadyPrinted()
                            }
                           
                        }
                        
                       
                        
                    }

                }
            }).disposed(by: rxbag)
        
        
    }
    func requestPrintChefBar(){
        viewModel.requestPrintChefBar().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Request Print Success...")
                self.numberPrint = 0
                self.isHideRootChefBar(isHide: true)
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
    
    func updateReadyPrinted(){
        viewModel.updateReadyPrinted().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Update  Print Success...")
                self.numberPrint = 0
                self.lbl_number_need_update.text = "0"
                self.isHideRootChefBar(isHide: true)
                self.getOrder()
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
    func addNoteToFood(){
        viewModel.addNoteToOrderDetail().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get order Success...")
                self.getOrder()
            }else{
                JonAlert.showError(message:response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
        
    }
    func updateFoodsToOrder(){
        viewModel.updateFoods().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get order Success...")
                self.numberPrint = 0
                self.lbl_number_food_need_update.text = "0"
                self.view_number_update_food.isHidden = true
                self.getOrder()
            }else{
               
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
    
    func cancelFood(){
        dLog(order_id)
        viewModel.cancelFood().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("cancel food Success...")
                let food = self.order_details.filter({$0.id == self.viewModel.order_detail_id.value})
                self.printFoodAfterCancel()
                self.getOrder()
            }else{
                JonAlert.showError(message:response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
    
    func cancelExtraCharge(){
        dLog(order_id)
        viewModel.cancelExtraCharge().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("cancel food Success...")
                let food = self.order_details.filter({$0.id == self.viewModel.order_detail_id.value})
                self.printFoodAfterCancel()
                self.getOrder()
            }else{
                JonAlert.showError(message:response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
    
    
    
}
extension OrderDetailViewController: UITableViewDelegate{
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let order_detail = viewModel.dataArray.value[indexPath.row]
        let font = UIFont(name: "Helvetica", size: 14.0)
        let s = order_detail.cancel_reason
        let height_note = s.isEmpty ? heightForLabel(text: String.init(format: "%@",order_detail.note), font: font!, width: view.frame.width) : heightForLabel(text: String.init(format: "%@",order_detail.cancel_reason), font: font!, width: view.frame.width)
        
        let height_gift:CGFloat = 100
        
        var string = ""
        var height_addition:CGFloat = 0
        
        if order_detail.order_detail_restaurant_pc_foods.count > 0 {
            for i in 0..<order_detail.order_detail_restaurant_pc_foods.count - 1 {
                let item = order_detail.order_detail_restaurant_pc_foods[i]
                string = string + "+ " + item.name + " x " + String(item.quantity)
            }
            
            let item = order_detail.order_detail_restaurant_pc_foods.last
            string = string + "+ " + item!.name +  " x " + String(Int(item!.quantity)) + " = " + Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(item!.price) * Float(item!.quantity))
        } else if order_detail.order_detail_additions.count > 0 {
            for i in 0..<order_detail.order_detail_additions.count - 1 {
                let item = order_detail.order_detail_additions[i]
                string = string + "+ " + item.name + " x " + String(item.quantity)
                + " = " + Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(item.price) * Float(item.quantity)) + "\n"
            }
            
            let item = order_detail.order_detail_additions.last
            string = string + "+ " + item!.name +  " x " + String(Int(item!.quantity)) + " = " + Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(item!.price) * Float(item!.quantity))
            
            
        } else if order_detail.order_detail_combo.count > 0 {
            for i in 0..<order_detail.order_detail_combo.count - 1 {
                let item = order_detail.order_detail_combo[i]
                string = string + "+ " + item.name + " x " + String(item.quantity)
            }
            
        }
        
        height_addition = heightForLabel(text: String.init(format: "%@",string), font: font!, width: 250)
       
        if(order_detail.is_gift == ACTIVE){
            
            
            return height_note + height_addition + height_gift
        }else{
            if (order_detail.order_detail_combo.count > 0){
                return CGFloat(70 + (order_detail.order_detail_combo.count * 12))
            }
            return height_note + height_addition + 80
        }
      
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dLog(viewModel.dataArray.value[indexPath.row].toJSON())
        let order_detail = viewModel.dataArray.value[indexPath.row]
       
        if(order_detail.status != 3 || order_detail.status != 4) {
            if(order_detail.category_type == TYPE_BEER || order_detail.category_type == TYPE_OTHER){
                if(order_detail.status == DONE && order_detail.enable_return_beer == 1 && order_detail.is_gift == 0){
                    if(order_detail.quantity > 0){
                        self.presentModalReturnBeerViewController(order_id:self.order_id, order_detail_id: viewModel.dataArray.value[indexPath.row].id, quantity: Int(order_detail.quantity))
                    }
                   
                }
            }else{
                if(order_detail.status == PENDING && order_detail.is_gift == 0 && order_detail.is_bbq == 0){
                    
                    if(order_detail.is_gift != 1){// món tặng không được phép chỉnh sửa số lượng
                        if (self.booking_status == STATUS_BOOKING_SET_UP && order_detail.category_type != FOOD){
                            var foods = self.viewModel.dataArray.value
                            var quantity = order_detail.quantity
                      
                            if(order_detail.is_sell_by_weight == ACTIVE){
                                quantity = quantity + 0.01
                                quantity = quantity >= 200 ? 200 : quantity
                            }else{
                                
                                    quantity += 1
                                    quantity = quantity >= 1000 ? 1000 : quantity
                    
                            }

                            foods.enumerated().forEach { (index, value) in
                                if(order_detail.id == value.id){
                                    foods[index].quantity = quantity
                                    foods[index].isChange = 1
                                }
                            }
                            viewModel.dataArray.accept(foods)
                            
                            viewModel.isChange.accept(1)
                        }
                    }else{
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GIFT_FOOD_NOTE_UPDATE_QUANTITY"), object: nil)
                        
                    }
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let order_detail = viewModel.dataArray.value[indexPath.row]
        var configuration : UISwipeActionsConfiguration?
        // cancelFood action
        let cancelFood = UIContextualAction(style: .normal,title: ""){
            [weak self] (action, view, completionHandler) in
            self?.handleCancelFood(order_detail_id: order_detail.id,
                                   is_extra_charge:Int(order_detail.is_extra_Charge),
                                   quantity: Int(order_detail.quantity))
            completionHandler(true)
        }
        cancelFood.backgroundColor = .UIColorFromRGB("F5072F")
        cancelFood.image = UIImage(named: "icon-cancel-order-detail")
        
        
        
        // splitFood action (tách món)
        let splitFood = UIContextualAction(style: .normal,
                                           title: "") { [weak self] (action, view, completionHandler) in
            self!.order_details = [OrderDetail]()
            self?.order_details.append(order_detail)
            self?.handleSplitFood(table_name: self!.table_name, table_id:self!.table_id)
            completionHandler(true)
        }
        splitFood.backgroundColor = .UIColorFromRGB("2EA534")
        splitFood.image = UIImage(named: "icon-splite-food")
        
        
        // noteFood action
        let noteFood = UIContextualAction(style: .normal,title: "") {
            [weak self] (action, view, completionHandler) in
            self?.handleNoteFood(pos: indexPath.row,
                                 note:order_detail.note,
                                 food_id: order_detail.food_id)
            completionHandler(true)
        }
        noteFood.backgroundColor = .UIColorFromRGB("7D7E81")
        noteFood.image = UIImage(named: "icon-note")
        
        /*
         TH1:nếu là món nước hoặc món khác
         -> TH1: Nếu trạng thái của món là bị huỷ hoặc không đủ thì chỉ được thao tác tách món
         -> TH2: Nếu món đã hoàn
         */
        
        if(order_detail.category_type == TYPE_BEER || order_detail.category_type == TYPE_OTHER){// Mon nuoc hoac mon khac
            if(order_detail.status == CANCEL_FOOD || order_detail.status == NOT_ENOUGH){
                configuration = UISwipeActionsConfiguration(actions: [splitFood])
                configuration!.performsFirstActionWithFullSwipe = false
            }else{
                /*Nếu món nước và món khác được trả lại và có số lượng == 0 thì ta không cho user thao tác nữa */
                if(order_detail.status == DONE){
                    if(order_detail.quantity > 0){
                        configuration = UISwipeActionsConfiguration(actions: [cancelFood,splitFood])
                        configuration!.performsFirstActionWithFullSwipe = false
                    }
                }else{
                    configuration = UISwipeActionsConfiguration(actions: [cancelFood, splitFood, noteFood ])
                    configuration!.performsFirstActionWithFullSwipe = false
                }
               
            }
        }else{// Food Type is Food
            if(order_detail.status != PENDING){
                if(Utils.checkRoleCancelFoodCompleted(permission: ManageCacheObject.getCurrentUser().permissions)){
                    if(order_detail.status != CANCEL_FOOD && order_detail.status != NOT_ENOUGH){
                        configuration = UISwipeActionsConfiguration(actions: [cancelFood, splitFood])
                        configuration!.performsFirstActionWithFullSwipe = false
                    }else{
                        configuration = UISwipeActionsConfiguration(actions: [splitFood])
                        configuration!.performsFirstActionWithFullSwipe = false
                    }
                }else{ //if(order_detail.is_extra_Charge == ACTIVE && Utils.checkRoleAddCustomFood(permission: ManageCacheObject.getCurrentUser().permissions)){
                    configuration = UISwipeActionsConfiguration(actions: [cancelFood, splitFood])
                    configuration!.performsFirstActionWithFullSwipe = false
                }
            }else{
                
                configuration = UISwipeActionsConfiguration(actions: [cancelFood, splitFood, noteFood ])
                configuration!.performsFirstActionWithFullSwipe = false

            }
        }
        
        if(order_detail.status == 3 || order_detail.status == 4) {
            configuration = UISwipeActionsConfiguration(actions: [])
            configuration!.performsFirstActionWithFullSwipe = false
        }
        // Bàn booking chỉ cho phép huỷ với món nước, còn lại không cho thao tác
        if(booking_status == STATUS_BOOKING_SET_UP ){
            if (order_detail.category_type == DRINK && order_detail.status != 4){
                configuration = UISwipeActionsConfiguration(actions: [cancelFood, noteFood])
                if (order_detail.status == DONE){
                    configuration = UISwipeActionsConfiguration(actions: [cancelFood])
                }
                configuration!.performsFirstActionWithFullSwipe = false
            }else{
                configuration = UISwipeActionsConfiguration(actions: [])
                configuration!.performsFirstActionWithFullSwipe = false
            }
        }
        return configuration
    }
    
}

