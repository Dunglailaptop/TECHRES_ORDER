//
//  PayMentViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import ObjectMapper
import JonAlert

extension PayMentViewController {
    
    //MARK: Register Cells as you want
    func registerCell(){

        let paymentTotalAmountTableViewCell = UINib(nibName: "PaymentTotalAmountTableViewCell", bundle: .main)
        tableView.register(paymentTotalAmountTableViewCell, forCellReuseIdentifier: "PaymentTotalAmountTableViewCell")

        let paymentInfoTableViewCell = UINib(nibName: "PaymentInfoTableViewCell", bundle: .main)
        tableView.register(paymentInfoTableViewCell, forCellReuseIdentifier: "PaymentInfoTableViewCell")
        
        let paymentOrderDetailTableViewCell = UINib(nibName: "PaymentOrderDetailTableViewCell", bundle: .main)
        tableView.register(paymentOrderDetailTableViewCell, forCellReuseIdentifier: "PaymentOrderDetailTableViewCell")
        
        let paymentFooterTableViewCell = UINib(nibName: "PaymentFooterTableViewCell", bundle: .main)
        tableView.register(paymentFooterTableViewCell, forCellReuseIdentifier: "PaymentFooterTableViewCell")
        
        let paymentFooterEndTableViewCell = UINib(nibName: "PaymentFooterEndTableViewCell", bundle: .main)
        tableView.register(paymentFooterEndTableViewCell, forCellReuseIdentifier: "PaymentFooterEndTableViewCell")
     
        
     
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
      
        tableView
            .rx.setDelegate(self)
            .disposed(by: rxbag)
//
        
    }
    
    func bindTableView(){
        viewModel.dataSectionArray.asObservable()
            .bind(to: tableView.rx.items){ [self] (tableView, index, element) in
                
                dLog(element)
                switch(element){
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTotalAmountTableViewCell") as! PaymentTotalAmountTableViewCell
                    if (self.change_icon_prev){
                        cell.lbl_total_payment.textColor = ColorUtils.green_600()
                    }
                    cell.viewModel = viewModel
                    return cell
                case 1: let cell = tableView.dequeueReusableCell(withIdentifier:"PaymentInfoTableViewCell" ) as! PaymentInfoTableViewCell
                    cell.viewModel = viewModel
                    
                    cell.btnCospan.rx.tap.asDriver()
                                   .drive(onNext: { [weak self] in
                                       dLog("btnCospan")
//                                       self?.viewModel.order_detail_height_payment_info.accept(150)
                                   }).disposed(by: rxbag)
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOrderDetailTableViewCell") as! PaymentOrderDetailTableViewCell
                    cell.viewModel = viewModel
                    return cell
                case 3:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"PaymentFooterTableViewCell" ) as! PaymentFooterTableViewCell
                    
                    if (self.change_icon_prev){
                        cell.isChangeImage = true
                        cell.image_checked_vat.image = UIImage(named: "icon-checked-vat-green")
                        cell.image_discount.image = UIImage(named: "icon-discount-green")
                        cell.image_total_point_use.image = UIImage(named: "icon-sack-dollar")
                        
                        cell.lbl_total_temp_payment.textColor = ColorUtils.green_600()
                        cell.lbl_total_vat.textColor = ColorUtils.green_600()
                        cell.lbl_total_discount.textColor = ColorUtils.green_600()
                        cell.lbl_total_used_point.textColor = ColorUtils.green_600()
                        
                        cell.lbl_name_vat.textColor = ColorUtils.green_600()
                        cell.lbl_name_discount.textColor = ColorUtils.green_600()
                        cell.lbl_name_total_point_used.textColor = ColorUtils.green_600()
                    }
                    
                    cell.viewModel = viewModel
                    
                    cell.btn_checkbox_vat.rx.tap.asDriver()
                                   .drive(onNext: { [weak self] in
                                       dLog("btn_checkbox_vat")
                                       // check quyền trước khi thực hiện vat
                                       if(Utils.checkRoleDiscountGifFood(permission: ManageCacheObject.getCurrentUser().permissions)){
                                           let is_apply_vat = self?.viewModel.orderDetailData.value.is_apply_vat == ACTIVE ? DEACTIVE : ACTIVE
                                           self!.viewModel.order_id.accept(self!.order_id)
                                           self!.viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
                                           self!.viewModel.is_include_vat.accept(is_apply_vat)
                                           if cell.btn_checkbox_vat.isUserInteractionEnabled == true {
                                               //không cho tương tác với btn_checkbox_vat khi btn_checkbox_vat đã được nhấn
                                               cell.btn_checkbox_vat.isUserInteractionEnabled = false
                                               self!.applyVAT(btnApply: cell.btn_checkbox_vat)
                                           }
                                        
                                       }else{
                                           JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)
                                       }
                                      
                                   }).disposed(by: rxbag)
                    
                    cell.btn_detail_vat.rx.tap.asDriver()
                                   .drive(onNext: { [weak self] in
                                       let order = self!.viewModel.orderDetailData.value
                                       if(order.vat_amount > 0){// Navigator to vat detail
                                           dLog("Navigator to vat detail")
                                           self!.presentModalDetailVATViewController(order_id: order.id)
                                       }
                                   }).disposed(by: rxbag)
                    
                    
                    cell.btn_checkbox_discount.rx.tap.asDriver()
                                   .drive(onNext: { [weak self] in
                                       dLog("btn_checkbox_discount")
                                       // check quyền trước khi thực hiện giảm giá
                                       if(Utils.checkRoleDiscountGifFood(permission: ManageCacheObject.getCurrentUser().permissions)){
                                           let order = self!.viewModel.orderDetailData.value
                                           
                                           if(order.discount_percent > 0){ // call api remove discount
                                               self!.viewModel.discount_percent.accept(0)
                                               self!.viewModel.discount_type.accept(1)// total bill discount
                                               self!.viewModel.note.accept("")
                                               self!.applyDiscount()
                                           }else{
                                               self!.presentModalDiscountViewController(order_id:(self?.viewModel.orderDetailData.value.id)!)
                                           }
                                       }else{
                                           JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)
                                       }
                                      
                                      
                                   }).disposed(by: rxbag)
                    
                    
                    return cell
                case 4:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentFooterEndTableViewCell") as! PaymentFooterEndTableViewCell
                    cell.viewModel = viewModel
                    return cell

                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"PaymentTotalAmountTableViewCell" ) as! PaymentTotalAmountTableViewCell
                    cell.viewModel = viewModel
                    return cell
 
                }
            }
    }
}

extension PayMentViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
        switch indexPath.row{
            case 0:
                return 60
                
            case 1:
//            var row_height = 170
//            viewModel.order_detail_height_payment_info.subscribe( // Thực hiện subscribe Observable
//              onNext: { [weak self] order_detail_height_payment_info in
//                  row_height = order_detail_height_payment_info
//                  self!.tableView.reloadRows(at: [indexPath], with: .none)
//              }).disposed(by: rxbag)
            
//            return  CGFloat(row_height)
                
            if(self.viewModel.orderDetailData.value.customer_name.count > 0){
                return 280
            }else{
                return 210
            }
                
            case 2:

            var previous_order_detail_height: CGFloat = 0
            var row_height: CGFloat = 300

            viewModel.order_detail_height.subscribe(
                onNext: { [weak self] order_detail_height in
                    if NSNumber(value: Double(order_detail_height)) != NSNumber(value: Double(previous_order_detail_height)) {
                        row_height = CGFloat(order_detail_height)
                        self?.tableView.reloadRows(at: [indexPath], with: .none)
                        previous_order_detail_height = CGFloat(order_detail_height)
                    }
                }
            ).disposed(by: rxbag)

            return CGFloat(row_height)
            
            case 3:
                return 200
            case 4:
                return 230
            default:
                return 143
                
            }
    
    }
}

// MARK: CALL API GET DATA HERE...
extension PayMentViewController{
    func applyDiscount(){
        viewModel.discount().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog(response.message)
                
//                Toast.show(message: self.viewModel.discount_percent.value > 0 ? "Giảm giá thành công..." : "Hủy giảm giá thành công...", controller: self)
                JonAlert.showError(message: self.viewModel.discount_percent.value > 0 ? "Giảm giá thành công..." : "Hủy giảm giá thành công...", duration: 2.0)
                self.getOrderDetail()
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
//                Toast.show(message: response.message ?? "Có lỗi trong quá trình thêm món", controller: self)
            }
         
        }).disposed(by: rxbag)
    }
    // func load lại chi tiết đơn hàng khi nhấn áp dụng hoặc huỷ VAT
    func getOrderDetail(btnApply:UIButton){
        viewModel.getOrderDetail().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get order Success...")
                if var orderDetailData  = Mapper<OrderDetailData>().map(JSONObject: response.data){
                    dLog(orderDetailData.toJSON())
                    self.order_id = orderDetailData.id
                    self.viewModel.cash_amount.accept(orderDetailData.total_amount)
                    self.lbl_order_table_name.text = String(format: "#%d - %@", orderDetailData.id, orderDetailData.table_name)
                    var height_of_view_cell = 0
                    
                    // lấy chiều cao tổng của cell khi có combo
                    for orderDetail in orderDetailData.order_details{
                        height_of_view_cell += (orderDetail.order_detail_additions.count * 15) + (orderDetail.order_detail_combo.count * 15)
                    }
                    self.viewModel.order_detail_height.accept((orderDetailData.order_details.count * 70) + height_of_view_cell)
                    dLog((orderDetailData.order_details.count * 70) + height_of_view_cell)
                    self.viewModel.dataOrderDetails.accept(orderDetailData.order_details)
                    self.viewModel.orderDetailData.accept(orderDetailData)
                    
                    if(orderDetailData.status == ORDER_STATUS_COMPLETE || orderDetailData.status == ORDER_STATUS_DEBT_COMPLETE){
                        Utils.isHideAllView(isHide: true, view: self.view_request_payment)
                        Utils.isHideAllView(isHide: true, view: self.view_completed_bill)
//                        if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE){
//                            Utils.isHideAllView(isHide: false, view: self.view_preprint_bill)
//                        }else{
//                            Utils.isHideAllView(isHide: true, view: self.view_preprint_bill)
//                        }
                        //Màn hình chi tiết hóa đơn chỉ hiển thị nút in hóa đơn đối với gpbh1o3 và 2o1 các giải pháp còn lại ẩn nút in hóa đơn.
                        if((ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_THREE) || (ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE)){
                            
                            Utils.isHideAllView(isHide: false, view: self.view_preprint_bill)
                        }else{
                            Utils.isHideAllView(isHide: true, view: self.view_preprint_bill)
                        }
                        self.constraint_bottom_tableview.constant = 150
                    }else{
                        if(ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_ONE){
                            
                            if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE){
                                if(Utils.checkRoleOwnerOrCashier(permission: ManageCacheObject.getCurrentUser().permissions)){
                                    Utils.isHideAllView(isHide: true, view: self.view_request_payment)
                                    Utils.isHideAllView(isHide: false, view: self.view_completed_bill)
                                }else{
                                    Utils.isHideAllView(isHide: false, view: self.view_request_payment)
                                    Utils.isHideAllView(isHide: true, view: self.view_completed_bill)
                                }
                                
                            }
//                            Utils.isHideAllView(isHide: false, view: self.view_request_payment)
//                            Utils.isHideAllView(isHide: true, view: self.view_completed_bill)
                        }else{
                            Utils.isHideAllView(isHide: true, view: self.view_request_payment)
                            Utils.isHideAllView(isHide: false, view: self.view_completed_bill)
                        }
                        Utils.isHideAllView(isHide: true, view: self.view_preprint_bill)
                        self.constraint_bottom_tableview.constant = 55
                    }
                    // sau khi quá trình áp dụng hoặc huỷ VAT xong, cho phép người dùng tương tác với btn_checkbox_vat
                    btnApply.isUserInteractionEnabled = true
                }
                
            }
        }).disposed(by: rxbag)
 }
    
    func getOrderDetail(){
        viewModel.getOrderDetail().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get order Success...")
                if var orderDetailData  = Mapper<OrderDetailData>().map(JSONObject: response.data){
                    dLog(orderDetailData.toJSON())
                    self.order_id = orderDetailData.id
                    self.viewModel.cash_amount.accept(orderDetailData.total_amount)
                    self.lbl_order_table_name.text = String(format: "#%d - %@", orderDetailData.id, orderDetailData.table_name)
                    var height_of_view_cell = 0

                    // lấy chiều cao tổng của cell khi có combo
                    for orderDetail in orderDetailData.order_details{
                        height_of_view_cell += (orderDetail.order_detail_additions.count * 15) + (orderDetail.order_detail_combo.count * 15)
                    }
                    self.viewModel.order_detail_height.accept((orderDetailData.order_details.count * 70) + height_of_view_cell)
                    dLog((orderDetailData.order_details.count * 70) + height_of_view_cell)
                    self.viewModel.dataOrderDetails.accept(orderDetailData.order_details)
                    self.viewModel.orderDetailData.accept(orderDetailData)
                    
                    if(orderDetailData.status == ORDER_STATUS_COMPLETE || orderDetailData.status == ORDER_STATUS_DEBT_COMPLETE){
                        Utils.isHideAllView(isHide: true, view: self.view_request_payment)
                        Utils.isHideAllView(isHide: true, view: self.view_completed_bill)
//                        if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE){
//                            Utils.isHideAllView(isHide: false, view: self.view_preprint_bill)
//                        }else{
//                            Utils.isHideAllView(isHide: true, view: self.view_preprint_bill)
//                        }
                        //Màn hình chi tiết hóa đơn chỉ hiển thị nút in hóa đơn đối với gpbh1o3 và 2o1 các giải pháp còn lại ẩn nút in hóa đơn.
                        if((ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_THREE) || (ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE)){
                            
                            Utils.isHideAllView(isHide: false, view: self.view_preprint_bill)
                            self.constraint_bottom_tableview.constant = 70
                            self.constraint_bottom_view_preprint.constant = 30
                        }else{
                            Utils.isHideAllView(isHide: true, view: self.view_preprint_bill)
                            self.constraint_bottom_tableview.constant = 0
                        }
                    }else{
                        if(ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_ONE){
                            
                            if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE){
                                if(Utils.checkRoleOwnerOrCashier(permission: ManageCacheObject.getCurrentUser().permissions)){
                                    Utils.isHideAllView(isHide: true, view: self.view_request_payment)
                                    Utils.isHideAllView(isHide: false, view: self.view_completed_bill)
                                }else{
                                    Utils.isHideAllView(isHide: false, view: self.view_request_payment)
                                    Utils.isHideAllView(isHide: true, view: self.view_completed_bill)
                                }
                                
                            }
//                            Utils.isHideAllView(isHide: false, view: self.view_request_payment)
//                            Utils.isHideAllView(isHide: true, view: self.view_completed_bill)
                        }else{
                            Utils.isHideAllView(isHide: true, view: self.view_request_payment)
                            Utils.isHideAllView(isHide: false, view: self.view_completed_bill)
                        }
                       
                        Utils.isHideAllView(isHide: true, view: self.view_preprint_bill)
                        self.constraint_bottom_tableview.constant = 55
                    }
                }
 
            }
        }).disposed(by: rxbag)
 }
    //MARK: Kiểm tra số món chưa in có ko ? Nếu chưa in thì thông báo in trước khi thanh toán bill
    func checkFoodNotPrints(print_type:Int){
        viewModel.getFoodsNeedPrint().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let foods_need_print  = Mapper<Food>().mapArray(JSONObject: response.data){
                    dLog(foods_need_print.toJSON())
                    if (foods_need_print.count > 0) {
                        self.presentModalDialogConfirmViewController(dialog_type: 1, title: "THÔNG BÁO GỬI BẾP/BAR", content: "Hiện tại còn món chưa gửi Bếp/Bar bạn có muốn gửi Bếp/Bar trước khi thanh toán không?")
                    }else{
                        self.callAPICompletePayment()
                    }
                 
                }

            }
        }).disposed(by: rxbag)
        
    }
    func getFoodsNeedPrint(print_type:Int){
        viewModel.getFoodsNeedPrint().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get order Success...")
                if let foods_need_print  = Mapper<Food>().mapArray(JSONObject: response.data){
                    dLog(foods_need_print.toJSON())
                    self.print_foods = foods_need_print
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
                        self.viewModel.order_detail_ids.accept(order_details)
                        self.updateReadyPrinted()
                    }
                    if ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE {
                        self.viewModel.order_detail_ids.accept(order_details)
                        self.updateReadyPrinted()
                    }
                    
                }

            }
        }).disposed(by: rxbag)
        
    }
    func updateReadyPrinted(){
        viewModel.updateReadyPrinted().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Update  Print Success...")
                self.numberPrint = 0
                self.callAPICompletePayment()
            }else{
//                Toast.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", controller: self)
                dLog(response.message)
                JonAlert.showError(message:response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 2.0)
                
            }
        }).disposed(by: rxbag)
        
    }
    
    
/*
func checkNumberNeedPrint(order:OrderDetailData){
    if (ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_THREE) {
        for i in 0..<order.order_details.count {
            if order.order_details[i].is_combo == 0 {
                if(order.order_details[i].quantity != order.order_details[i].printed_quantity && order.order_details[i].is_allow_print == 1 && order.order_details[i].status !=  CANCEL_FOOD) {
                    self.numberPrint = self.numberPrint + 1
                }
            } else {
                self.numberPrint = self.numberPrint + order.order_details[i].food_in_combo_wait_print_quantity
            }
        }
        if (self.numberPrint > 0) {
            self.presentModalDialogConfirmViewController(dialog_type: 1, title: "THÔNG BÁO GỬI BÊP/BAR", content: "Hiện tại còn món chưa gửi Bếp/Bar bạn có muốn gửi Bếp/Bar trước khi thanh toán không?")
        }else{
            self.callAPICompletePayment()
        }
    }
}
  
 */
func updateCustomerNumberSlot(){
    viewModel.updateCustomerNumberSlot().subscribe(onNext: { (response) in
        if(response.code == RRHTTPStatusCode.ok.rawValue){
            dLog("update customer number slote Success...")
            self.getOrderDetail()
            
//            self.callAPIRequestPayment()

        }
    }).disposed(by: rxbag)
}
    func requestPaymentAPI(){
        viewModel.requestPayment().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
//                Toast.show(message: "Yêu cầu thanh toán thành công", controller: self)
                JonAlert.showSuccess(message: "Yêu cầu thanh toán thành công", duration: 2.0)
                self.viewModel.makePopViewController()
            }else{
                JonAlert.showError(message:response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
                
            }
            
        }).disposed(by: rxbag)
    }
    
    func requestPrintChefBar(){
        viewModel.requestPrintChefBar().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Request Print Success...")
                self.numberPrint = 0
                
                self.getOrderDetail()
            }
            else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
        
    }
    //in bill
    //1o1 1o2 không in bill
    func completedPaymentAPI(){
        viewModel.completedPayment().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
//                Toast.show(message: "Đã hoàn tất đơn hàng và in bill cho khách.", controller: self)
                JonAlert.showSuccess(message:  "Đã hoàn tất đơn hàng và in bill cho khách.", duration: 2.0)
                
                
                if (ManageCacheObject.getPrinterBill(cache_key: KEY_PRINTER_BILL).is_have_printer == ACTIVE && Utils.checkRoleIsPrintBill()){
                    // call print bill via printer networks here
                    self.createReceiptPrinter(food_prepare_prints: viewModel.orderDetailData.value.order_details)
                }
                
                //Sửa poop về màn hình đơn hàng
//                self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)

                self.viewModel.makePopViewControllerWithoutAnimation()
                callBackToPopViewController()

                
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
    func applyVAT(btnApply:UIButton){
        viewModel.applyVAT().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("apply VAT thanh cong ...")
                if(self.viewModel.is_include_vat.value == ACTIVE){
                    JonAlert.showSuccess(message:  "Áp dụng VAT thành công ...", duration: 2.0)
                   
                }else{
                    JonAlert.showSuccess(message: "Hủy áp dụng VAT thành công ...", duration: 2.0)
                }
                self.getOrderDetail(btnApply: btnApply)
            }else{
                JonAlert.showError(message:response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)

    }
}

extension PayMentViewController: DiscountDelegate{
    func presentModalDiscountViewController(order_id:Int) {
        let discountViewController = DiscountViewController()
        discountViewController.delegate = self
        discountViewController.view.backgroundColor = ColorUtils.blackTransparent()
        discountViewController.order_id = order_id

            let nav = UINavigationController(rootViewController: discountViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
           
            present(nav, animated: true, completion: nil)

        }
    
    func callbackDiscount() {
        JonAlert.showSuccess(message: "Giảm giá thành công...", duration: 2.0)
//        Toast.show(message: "Giảm giá thành công...", controller: self)
        getOrderDetail()
    }
}
//MARK: -- show review food contrloller
extension PayMentViewController: TechresDelegate{
    func presentModalReviewFoodViewController(order_id:Int) {
        let reviewFoodViewController = ReviewFoodViewController()

        reviewFoodViewController.view.backgroundColor = ColorUtils.blackTransparent()
        reviewFoodViewController.order_id = order_id
        reviewFoodViewController.delegate = self
            let nav = UINavigationController(rootViewController: reviewFoodViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
           
            present(nav, animated: true, completion: nil)

        }
    func callBackReload() {
        getOrderDetail()
    }
}
//MARK: -- show update customer slot contrloller
extension PayMentViewController: UpdateCustomerSloteDelegate{
    func presentModalUpdateCustomerSlotViewController() {
        let updateCustomerSlotViewController = UpdateCustomerSlotViewController()
        updateCustomerSlotViewController.delegate = self
        updateCustomerSlotViewController.view.backgroundColor = ColorUtils.blackTransparent()

            let nav = UINavigationController(rootViewController: updateCustomerSlotViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
           
            present(nav, animated: true, completion: nil)

        }
    func callbackPeopleQuantity(number_slot: Int) {
        
        if(number_slot >= 1){
            viewModel.customer_slot_number.accept(number_slot)
            self.updateCustomerNumberSlot()
        }else{
            JonAlert.showError(message:"Vui lòng nhật số người trên bàn phải lớn hơn 0", duration: 3.0)
        }
       
    }
}

extension PayMentViewController{

    func checkReviewFoodBeforeRequestPayment(){
        self.getFoodsNeedReview()
//        for order_detail in self.viewModel.dataOrderDetails.value {
//            if  order_detail.status == DONE {
//                if order_detail.review_score == 0 && order_detail.is_allow_review == ACTIVE && order_detail.quantity > 0{
//                    self.presentModalReviewFoodViewController(order_id: order_id)
//                    return
//                }
//
//            }
//        }
//        requestPaymentAPI()
    }
    
    func getFoodsNeedReview(){
        viewModel.getFoodsNeedReview().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let reviews = Mapper<OrderDetail>().mapArray(JSONObject: response.data) {
                    if(reviews.count > 0){
                        self.presentModalReviewFoodViewController(order_id: self.order_id)
                    }else{
                        self.requestPaymentAPI()
                    }
                }
                
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.")
            }
            
        }).disposed(by: rxbag)
    }
    
    
    func requestPayment() {// Only apply level 3
        
        let order = viewModel.orderDetailData.value
        if(order.status != ORDER_STATUS_WAITING_WAITING_COMPLETE){
            if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_TWO){
                if(ManageCacheObject.getSetting().is_require_update_customer_slot_in_order == ACTIVE){
                    if(order.customer_slot_number > 0){
                        payment_method = 1
                        self.checkReviewFoodBeforeRequestPayment()
                    }else {
                        //call update customer slot
                        self.presentModalUpdateCustomerSlotViewController()
                    }
                }else{
                    payment_method = 1
                    self.checkReviewFoodBeforeRequestPayment()
                }
               
            }else{
                payment_method = 1
                callAPIRequestPayment()
            }
            
        }else{
            JonAlert.showError(message:"Bạn không được phép thao tác chức năng này trên order đang chờ thu tiền", duration: 3.0)
//            Toast.show(message: "Bạn không được phép thao tác chức năng này trên order đang chờ thu tiền", controller: self)
        }
         
    }
    
    func callAPICompletePayment() {
        if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO
           && ManageCacheObject.getSetting().is_print_bill_on_mobile_app == DEACTIVE
           && ManageCacheObject.getSetting().is_print_kichen_bill_on_mobile_app == ACTIVE){
            self.requestPrintChefBar()
        }
        //CALL API COMPLETED ORDER
        self.completedPaymentAPI()
    }
        func callAPIRequestPayment()
        {
            // check level khac 3 thì tiến hành xử lý in phiếu che bien
            if(ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_THREE){ // Level 3 tro len
                if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO){ // Level 2
                    if(ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_TWO){
                        self.requestPrintChefBar()
                    }
                }
            }
            // CALL API REQUEST PAYMENT
            self.requestPaymentAPI()
        }
        
    func checkLevel(){
        if (Utils.checkRoleOwnerOrCashier(permission: ManageCacheObject.getCurrentUser().permissions)
            && ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_THREE
            && ManageCacheObject.getSetting().service_restaurant_level_id < GPQT_LEVEL_ONE) {
            //Level 1
            if (ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE) {//Thu tiền
                
                Utils.isHideView(isHide: true, view: view_request_payment)
                Utils.isHideView(isHide: false, view: view_completed_bill)
                is_request_payment = 1
                
            } else {// Level 2 //Yêu cầu thanh toán
               
                is_request_payment = 0
                Utils.isHideView(isHide: false, view: view_request_payment)
                Utils.isHideView(isHide: true, view: view_completed_bill)
                
                if ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE {// Thu tien
                    
                    Utils.isHideView(isHide: true, view: view_request_payment)
                    Utils.isHideView(isHide: false, view: view_completed_bill)
                    
                    is_request_payment = 1
                }
            }
        } else {//Yêu cầu thanh toán
            //  request payment order here
            Utils.isHideView(isHide: false, view: view_request_payment)
            Utils.isHideView(isHide: true, view: view_completed_bill)
            is_request_payment = 0
        }
    }
}
extension PayMentViewController{
    
    // ============== Handler printer ==============
//
//    func createReceiptDatas(food_prepare_prints:[OrderDetail]) {
//        let order = viewModel.orderDetailData.value
//        let textData: NSMutableString = NSMutableString()
//
//        let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
//
//        let remind_number_title = PrinterUtils.getLineSpace80().count - ConverHelper.convertVietNam(text: String(format: "%@", "HOA DON")).count
//        let left_space = remind_number_title/2
//        let right_space = remind_number_title/2
//
//        for _ in (0...left_space) {
//            textData.append(" ")
//        }
//        textData.append(String(format: "%@", "HOA DON"))
//
//        for _ in (0...right_space) {
//            textData.append(" ")
//        }
//        textData.append(PrinterUtils.getBreakLine())
//
//
//
//        let remind_number_bill = PrinterUtils.getLineSpace80().count - ConverHelper.convertVietNam(text: String(format: "Hoa don so: %d ", order.id)).count
//        let left_space_bill_number = remind_number_bill/2
//        let right_space_bill_number = remind_number_bill/2
//
//        for _ in (0...left_space_bill_number) {
//            textData.append(" ")
//        }
//        textData.append(String(format: "Hoá đơn số: %d ", order.id))
//
//        for _ in (0...right_space_bill_number) {
//            textData.append(" ")
//        }
//        textData.append(PrinterUtils.getBreakLine())
//
//
//        textData.append(String(format: "Ngày: %@", Utils.getFullCurrentDate()))
//        textData.append("\n")
//
//
//        textData.append(ConverHelper.convertVietNam(text: String(format: "Bàn: %@\n", order.table_name)))
//        textData.append(String(format: "Quan: %@\n", ConverHelper.convertVietNam(text: ManageCacheObject.getCurrentUser().branch_name)))
//        textData.append(String(format: "CSKH: %@\n", ConverHelper.convertVietNam(text: ManageCacheObject.getCurrentBranch().phone)))
//        textData.append(String(format: "Địa chỉ: %@\n", ConverHelper.convertVietNam(text: order.branch_address)))
//        textData.append(String(format: "Nhân viên: %@\n", ConverHelper.convertVietNam(text: order.employee_name)))
//        textData.append(String(format: "Số điện thoại: %@\n\n", ConverHelper.convertVietNam(text: ManageCacheObject.getSetting().branch_info.phone)))
////        textData.append(PrinterUtils.getLine80())
//        textData.append(String(format: "TEN MON                SL   DON GIA       T.Tien\n"))// 16 3 7
//        textData.append(PrinterUtils.getLine80())
//
//
//        // Section 2 : Purchaced items
//        for food in food_prepare_prints {
//
//            let total_amount = Float(food.price) * Float(food.quantity)
//
//
//            textData.append(String(format: "%@", ConverHelper.convertVietNam(text: food.name)))
//            let remind_number = left_space - ConverHelper.convertVietNam(text: food.name).count
//
//            if(remind_number > 0){
//
//                for _number in (0...remind_number) {
//                    textData.append(" ")
//                }
//
//            }
//            textData.append(String(format: "          %@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(total_amount))))
//
//
//            textData.append(String(format: "%d x %@", Int(food.quantity), Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(food.price))))
//
//            textData.append(PrinterUtils.getBreakLine())
//
//
//
//            textData.append(PrinterUtils.getLine80())
//            textData.append(PrinterUtils.getBreakLine())
//
//        }
//
//
//
//        textData.append(PrinterUtils.getLine80())
//
//        textData.append("THANH TIEN:")
//
//        for _ in (0...PrinterUtils.getLine80().count - 12 - Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.amount).count) {
//            textData.append(" ")
//        }
//
//        textData.append(Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.amount))
//
//        textData.append(PrinterUtils.getBreakLine())
//
//        textData.append("GIAM GIA:")
//
//        for _ in (0...PrinterUtils.getLine80().count - 10 - Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.discount_amount).count) {
//            textData.append(" ")
//        }
//
//        textData.append(Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.discount_amount))
//        textData.append(PrinterUtils.getBreakLine())
//
//        textData.append("VAT:")
//        for _ in (0...PrinterUtils.getLine80().count - 5 - Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.vat_amount).count) {
//            textData.append(" ")
//        }
//        textData.append(Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.vat_amount))
//        textData.append(PrinterUtils.getBreakLine())
//
//        textData.append("THANH TOAN:")
//
//        for _ in (0...PrinterUtils.getLine80().count - 12 - Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.total_amount).count) {
//            textData.append(" ")
//        }
//
//        textData.append(Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.total_amount))
//        textData.append(PrinterUtils.getBreakLine())
//
//        textData.append(PrinterUtils.getLine80())
//        textData.append(PrinterUtils.getBreakLine())
//
//        textData.append("              ")//10
//        textData.append("CHAN THANH CAM ON QUY KHACH!")
//        textData.append("              ")//10
//        textData.append(PrinterUtils.getBreakLine())
//        textData.append(PrinterUtils.getLine80())
//        textData.append("   ")//3
//        textData.append(String(format: "%@", "TECHRES.VN DUOC PHAT TRIEN BOI OVERATE-VNTECH"))//36
//        textData.append("    ")//4
//        textData.append(PrinterUtils.getBreakLine())
//
//        textData.append(PrinterUtils.getBreakLine())
//        textData.append(PrinterUtils.getBreakLine())
//        textData.append(PrinterUtils.getBreakLine())
//        textData.append(PrinterUtils.getBreakLine())
//        textData.append(PrinterUtils.getBreakLine())
//        textData.append(PrinterUtils.getBreakLine())
////
////        textData.append("\n")
////        textData.append("\n")
////        textData.append("\n")
////
////        textData.append("\n")
////        textData.append("\n")
////        textData.append("\n")
////        textData.append("\n")
//
//        debugPrint(textData)
//
//        PrinterUtils.printTextData(client: self.client!, text_data: ConverHelper.convertVietNam(text: textData.substring(from: 0)))
//
//        self.viewModel.makePopViewController()
//
//    }
    func createReceiptPrinter(food_prepare_prints:[OrderDetail]) {
        let order = viewModel.orderDetailData.value
        
        let textData: NSMutableString = NSMutableString()
//        textData.append("")//20
        textData.append(String(format: "               %@               ", "HOA DON THANH TOAN"))
//        textData.append("               ")//15
        textData.append("\n")
        
        
        
//        textData.append("              ")//16
        textData.append(String(format: "                  SO: #%d ", order.id))
        textData.append("              ")//15
        textData.append("\n")
        
      
        textData.append(String(format: "Ngay: %@", Utils.getFullCurrentDate()))
        textData.append("\n")
        
        
//        textData.append(String(format: "Ban: %@\n","A1"))
//        textData.append(String(format: "Nhan vien: %@\n", ConverHelper.convertVietNam(text: ManageCacheObject.getCurrentUser().name)))
//        textData.append(String(format: "So Dien Thoai: %@\n", "0925 123 123"))
        textData.append(ConverHelper.convertVietNam(text: String(format: "Ban: %@\n", order.table_name)))
        textData.append(String(format: "Quan: %@\n", ConverHelper.convertVietNam(text: ManageCacheObject.getCurrentUser().branch_name)))
        textData.append(String(format: "CSKH: %@\n", ConverHelper.convertVietNam(text: ManageCacheObject.getCurrentBranch().phone)))
        dLog(ManageCacheObject.getCurrentBranch().phone)
        textData.append(String(format: "Dia chi: %@\n", ConverHelper.convertVietNam(text: order.branch_address)))
        textData.append(String(format: "Nhan vien: %@\n", ConverHelper.convertVietNam(text: order.employee_name)))
//        textData.append(String(format: "So dien thoai: %@\n\n", ConverHelper.convertVietNam(text: ManageCacheObject.getSetting().branch_info.phone)))
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        textData.append(String(format: "%@                               %@", "TEN MON", "THANH TIEN"))
        
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())

        // Section 2 : Purchaced items
        for food in food_prepare_prints {

            let total_amount = Float(food.price) * Float(food.quantity)
            
            textData.append(String(format: "%@", ConverHelper.convertVietNam(text: food.name)))
            textData.append(PrinterUtils.getBreakLine())
            for item in food.order_detail_combo{
                textData.append(String(format: " + %@", ConverHelper.convertVietNam(text: item.name)))
                textData.append(PrinterUtils.getBreakLine())
            }
            for item in food.order_detail_additions{
                textData.append(String(format: " + %@", ConverHelper.convertVietNam(text: item.name)))
                textData.append(PrinterUtils.getBreakLine())
            }

            var spaces = ""
            // lấy số space của food_price
            let food_price_space = String(format: "%.2f x %@", food.quantity, Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(food.price))).count
            //lấy số space của total_price
            let total_amount_space = String(format: "%.2f x %@", food.quantity, Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(total_amount))).count
            // lấy số lượng space cần tạo
            if (food.is_gift == ACTIVE){
                if(food_price_space > 0 && food_price_space > 0){
                    let max_space = 47 - food_price_space - "Món tặng".count
                    for _ in (0...max_space) {
                        spaces += " "
                    }
                }
            }else{
                if(food_price_space > 0 && food_price_space > 0){
                    let max_space = 58 - food_price_space - total_amount_space
                    for _ in (0...max_space) {
                        spaces += " "
                    }
                }
            }
            
            textData.append(PrinterUtils.getBreakLine())
            
            if(food.is_sell_by_weight == ACTIVE){
                textData.append(String(format: "%.2f x %@" + spaces + "%@", food.quantity, Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(food.price)), Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(total_amount))))
            }else if(food.is_gift == ACTIVE){
                textData.append(String(format: "%.2f x %@" + spaces + "%@", food.quantity, Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(food.price)), "Mon tang"))
            }else{
                textData.append(String(format: "%.0f x %@" + spaces + "%@", food.quantity, Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(food.price)), Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(total_amount))))
            }
           
            textData.append(PrinterUtils.getBreakLine())
            textData.append(PrinterUtils.getLine80())
            textData.append(PrinterUtils.getBreakLine())
            
        }
        
        var spaces2 = ""
        let order_total_amount_space = String(format: "%@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.total_amount))).count
        let total_space = String(format: "THANH TIEN:").count
        if(order_total_amount_space > 0 && total_space > 0){
            let max_space2 = 48 - order_total_amount_space - total_space // 48 là giới hạn space
            for _ in (0...max_space2) {
                spaces2 += " "
            }
        
        }
        textData.append(String(format: "THANH TIEN:" + spaces2 + "%@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.total_amount))))
        
        textData.append(PrinterUtils.getBreakLine())
        
        var spaces3 = ""
        let order_discount_amount_space = String(format: "%@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.discount_amount))).count
        let decrease_space = String(format: "GIAM GIA:").count
        if(order_discount_amount_space > 0 && decrease_space > 0){
            let max_space3 = 48 - order_discount_amount_space - decrease_space // 58 là giới hạn space
            for _ in (0...max_space3) {
                spaces3 += " "
            }
        
        }
        textData.append(String(format: "GIAM GIA:" + spaces3 + "%@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.discount_amount))))

        textData.append(PrinterUtils.getBreakLine())
        
        
        var spaces4 = ""
        let order_vat_amount_space = String(format: "%@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.vat_amount))).count
        let vat_space = String(format: "VAT:").count
        if(order_vat_amount_space > 0 && vat_space > 0){
            let max_space4 = 48 - order_vat_amount_space - vat_space // 48 là giới hạn space
            for _ in (0...max_space4) {
                spaces4 += " "
            }
        
        }
        textData.append(String(format: "VAT:" + spaces4 + "%@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.vat_amount))))

        textData.append(PrinterUtils.getBreakLine())
        
        
        
        var spaces5 = ""
        let order_total_final_amount_space = String(format: "%@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.total_final_amount))).count
        let payment_space = String(format: "THANH TOAN:").count
        if(order_total_final_amount_space > 0 && payment_space > 0){
            let max_space5 = 48 - order_total_final_amount_space - payment_space // 48 là giới hạn space
            for _ in (0...max_space5) {
                spaces5 += " "
            }
        
        }
        textData.append(String(format: "THANH TOAN:" + spaces5 + "%@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(order.total_final_amount))))

        textData.append(PrinterUtils.getBreakLine())
        
        textData.append(PrinterUtils.getLine80())
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        textData.append("              ")//10
        textData.append("CHAN THANH CAM ON QUY KHACH!")
        textData.append("              ")//10
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getLine80())
        textData.append(PrinterUtils.getBreakLine())
        textData.append("  ")//2
        textData.append(String(format: "%@", "TECHRES.VN DUOC PHAT TRIEN BOI OVERATE-VNTECH"))//45
        textData.append(" ")//1
        textData.append(PrinterUtils.getBreakLine())
        
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
               
        print(textData.substring(from: 0))

        PrinterUtils.printTextData(client: self.client!, text_data: ConverHelper.convertVietNam(text: textData.substring(from: 0)))

    }
    
    //    ========= End Handler printer ==============
}
extension PayMentViewController: DialogConfirmDelegate{
    func presentModalDialogConfirmViewController(dialog_type:Int, title:String, content:String) {
        let dialogConfirmViewController = DialogConfirmViewController()

        dialogConfirmViewController.view.backgroundColor = ColorUtils.blackTransparent()
        dialogConfirmViewController.dialog_type = dialog_type
        dialogConfirmViewController.dialog_title = title
        dialogConfirmViewController.content = content
        dialogConfirmViewController.delegate = self
            let nav = UINavigationController(rootViewController: dialogConfirmViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
           
            present(nav, animated: true, completion: nil)

        }
    
    func accept() {
        dLog("accept.....")

        // Call api gửi bếp/bar
        self.getFoodsNeedPrint(print_type: PRINT_TYPE_ADD_FOOD)
    }
    func cancel() {
        dLog("Cancel...")
    }
}
extension PayMentViewController{
    func presentModalDetailVATViewController(order_id:Int) {
        let detailVATViewController = DetailVATViewController()
        detailVATViewController.order_id = order_id
       
        detailVATViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: detailVATViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
           
            present(nav, animated: true, completion: nil)

        }
}
extension PayMentViewController{
    func setupSocketIO() {
        // socket io here
        let namespace = String(format: "/restaurants_%d_branches_%d", ManageCacheObject.getCurrentUser().restaurant_id, ManageCacheObject.getCurrentUser().branch_id)
        SocketIOManager.shareSocketRealtimeInstance().initSocketInstance(namespace)

        SocketIOManager.shareSocketRealtimeInstance().socketRealTime?.on("connect") {data, ack in
            self.real_time_url = String(format: "%@/%d/%@/%d/%@/%d","restaurants", ManageCacheObject.getCurrentUser().restaurant_id,"branches", ManageCacheObject.getCurrentUser().branch_id,"orders",self.order_id)
                    
            SocketIOManager.shareSocketRealtimeInstance().socketRealTime!.emit("join_room", self.real_time_url)
            

            SocketIOManager.shareSocketRealtimeInstance().socketRealTime!.on(self.real_time_url) {data, ack in
                dLog(data)
                self.getOrderDetail()
            }
        }
        
       
       
        
        // == End socket io
    }
}
