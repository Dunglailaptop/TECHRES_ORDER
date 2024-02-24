//
//  PayMentViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 15/01/2023.
//

import UIKit

class PayMentViewController: BaseViewController {
    var viewModel = PayMentViewModel()
    private var router = PayMentRouter()
    var callBackToPopViewController:() -> Void = {}
    @IBOutlet weak var lbl_order_table_name: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var view_request_payment: UIView!
    
    @IBOutlet weak var view_completed_bill: UIView!
    
    @IBOutlet weak var constraint_bottom_tableview: NSLayoutConstraint!
    @IBOutlet weak var view_preprint_bill: UIView!
    
    @IBOutlet weak var btn_actionBack: UIButton!
    
    @IBOutlet weak var constraint_bottom_view_preprint: NSLayoutConstraint!
    
    
    var order_id = 0
    var branch_id = 0
    var is_print_bill = ACTIVE
    var food_status = ""
    var is_request_payment = 0
    var payment_method = 0
    var real_time_url = ""
    
    var print_foods = [Food]()
    
    var list_food_prints = [Food]()
    var list_drink_prints = [Food]()
    
    var food_prepare_prints = [Food]()
    
    let left_space = 27
    
    var is_callback_add_food = 0
    
    let host = "172.16.1.233"
    let port = 9100
    var client: TCPClient?
    
    var numberPrint = 0
    var change_icon_prev = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.is_print_bill.accept(ACTIVE)// remove những món quantity = 0 ra khỏi bill
        client = TCPClient(address: ManageCacheObject.getPrinterBill(cache_key: KEY_PRINTER_BILL).printer_ip_address, port: Int32(PRINTER_PORT))

        
        checkLevel()
        food_status = String(format: "%d,%d,%d", PENDING, DONE, COOKING )
        
        viewModel.bind(view: self, router: router)
        registerCell()
        bindTableView()
        viewModel.dataSectionArray.accept([0,1,2,3,4])
        
        viewModel.food_status.accept(food_status)
        viewModel.order_id.accept(order_id)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        
        Utils.isHideAllView(isHide: true, view: view_preprint_bill)
        
        if self.change_icon_prev {
            self.btn_actionBack.setImage(UIImage(named: "icon-prev-green"), for: .normal)
            self.lbl_order_table_name.textColor = ColorUtils.green_600()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSocketIO()
        
        self.getOrderDetail()
        
        if(Utils.checkRoleOwnerOrCashier(permission: ManageCacheObject.getCurrentUser().permissions)
           && ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO
           && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_TWO){
            Utils.isHideAllView(isHide: false, view: view_request_payment)
            Utils.isHideAllView(isHide: true, view: view_completed_bill)
        }else if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE){
            Utils.isHideAllView(isHide: true, view: view_request_payment)
            Utils.isHideAllView(isHide: false, view: view_completed_bill)
        }else{
            Utils.isHideAllView(isHide: false, view: view_request_payment)
            Utils.isHideAllView(isHide: true, view: view_completed_bill)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let  real_time_url = String(format: "%@/%d/%@/%d/%@/%d","restaurants", ManageCacheObject.getCurrentUser().restaurant_id,"branches", ManageCacheObject.getCurrentUser().branch_id,"orders",self.order_id)
          
          SocketIOManager.shareSocketRealtimeInstance().socketRealTime!.emit("leave_room", real_time_url)
        
    }
    @IBAction func actionPaymentAndPrint(_ sender: Any) {
            
//        self.completedPaymentAPI()
        // kiểm tra món chưa gửi bếp/bar trước khi in bill 
        checkFoodNotPrints(print_type: PRINT_TYPE_ADD_FOOD)
        
//        if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_ONE){
//            if(ManageCacheObject.getSetting().is_require_update_customer_slot_in_order == ACTIVE){
//                if(self.viewModel.orderDetailData.value.customer_slot_number > 0){
//                    checkFoodNotPrints(print_type: PRINT_TYPE_ADD_FOOD)
//                }else {
//                    //call update customer slot
//                    self.presentModalUpdateCustomerSlotViewController()
//                }
//            }else{
//                checkFoodNotPrints(print_type: PRINT_TYPE_ADD_FOOD)
//            }
//        }
    }
    @IBAction func actionRequestPayment(_ sender: Any) {
        // NẾU LÀ GIẢI PHÁP QUẢN TRỊ THÌ VÀO ĐÂY KTRA
        if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_ONE){
            if(ManageCacheObject.getSetting().is_require_update_customer_slot_in_order == ACTIVE){
                if(self.viewModel.orderDetailData.value.customer_slot_number > 0){
                    if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_THREE){
                        self.requestPayment()
                    }else{
                        checkFoodNotPrints(print_type: PRINT_TYPE_ADD_FOOD)
                    }
                }else {
                    //call update customer slot
                    self.presentModalUpdateCustomerSlotViewController()
                }
            }else{
                if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_THREE){
                    self.requestPayment()
                }else{
                    checkFoodNotPrints(print_type: PRINT_TYPE_ADD_FOOD)
                }
            }
        }else{// NẾU LÀ GIẢI PHÁP BÁN HÀNG THÌ KIỂM TRA ĐÂY
            
            //NẾU GIẢI PHÁP BÁN HÀNG 3 THÌ CHỈ CÓ YÊU CẦU THANH TOÁN
            if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_THREE){
                self.requestPayment()
            
                //NẾU GIẢI PHÁP BÁN HÀNG 2 & OPTION 2  THÌ KTRA TIẾP
            }else if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO
            && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_TWO){
                self.requestPayment()// THANH TOÁN TRÊN APP CCB 
            }else{
                //NẾU CÓ QUYỀN THU NGÂN THÌ KTRA MÓN CẦN IN RỒI HOÀN TẤT BILL
                if(Utils.checkRoleOwnerOrCashier(permission: ManageCacheObject.getCurrentUser().permissions)){
                    checkFoodNotPrints(print_type: PRINT_TYPE_ADD_FOOD)
                }else{// KO CÓ QUYỀN THU NGÂN THÌ Y/C THANH TOÁN
                    self.requestPayment()
                }
                
            }
        }
        
       

    }
    
    @IBAction func actionPrePrint(_ sender: Any) {
        self.createReceiptPrinter(food_prepare_prints: viewModel.orderDetailData.value.order_details)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
 
   
}
