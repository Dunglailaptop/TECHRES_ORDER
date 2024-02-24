//
//  OrderViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 15/01/2023.
//

import UIKit
import ObjectMapper
import SocketIO
import JonAlert

//MARK: -- show update customer slot contrloller
extension OrderViewController: UpdateCustomerSloteDelegate{
    func presentModalUpdateCustomerSlotViewController(current_quantity:Int) {
        let updateCustomerSlotViewController = UpdateCustomerSlotViewController()
        updateCustomerSlotViewController.delegate = self
        updateCustomerSlotViewController.current_quantity = current_quantity
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
//            Toast.show(message: "Vui lòng nhật số người trên bàn phải lớn hơn 0", controller: self)
            JonAlert.showError(message: "Vui lòng nhật số người trên bàn phải lớn hơn 0", duration: 2.0)
        }
       
    }
}

extension OrderViewController{
    
    func updateCustomerNumberSlot(){
        viewModel.updateCustomerNumberSlot().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("update customer number slote Success...")
                self.fetchOrders(key_word: "")
            }
        }).disposed(by: rxbag)
    }
    
}
extension OrderViewController:TechresDelegate {
     // Thêm biến employee_id:Int
    func presentModalMoreAction(order_id:Int, destination_table_id:Int, destination_table_name:String, employee:Account) {
        let orderActionViewController = OrderActionViewController()
        orderActionViewController.delegate = self
        orderActionViewController.order_id = order_id
        orderActionViewController.employee = employee
        orderActionViewController.destination_table_name = destination_table_name
        orderActionViewController.destination_table_id = destination_table_id
        orderActionViewController.view.backgroundColor = ColorUtils.blackTransparent()

        let nav = UINavigationController(rootViewController: orderActionViewController)
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
//        orderActionViewController.delegate = self
//        newFeedBottomSheetActionViewController.newFeed = newFeed
//        newFeedBottomSheetActionViewController.index = position
        present(nav, animated: true, completion: nil)

    }
    
    func presentModalChooseTableNeedMoveViewController( table_name:String, table_id:Int) {
            let chooseTableNeedMoveViewController = ChooseTableNeedMoveViewController()
        chooseTableNeedMoveViewController.table_id = table_id
        chooseTableNeedMoveViewController.table_name = table_name
        chooseTableNeedMoveViewController.delegateCallBack = self
        chooseTableNeedMoveViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: chooseTableNeedMoveViewController)
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
    
    func presentModalChooseTableNeedMergeViewController( table_name:String, table_id:Int) {
            let chooseTableNeedMergeViewController = ChooseTableNeedMergeViewController()
        chooseTableNeedMergeViewController.table_id = table_id
        chooseTableNeedMergeViewController.table_name = table_name
        chooseTableNeedMergeViewController.delegateCallBackReload = self
//        chooseTableNeedMoveViewController.delegate = self
        chooseTableNeedMergeViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: chooseTableNeedMergeViewController)
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
    
    func presentModalSeparateFoodViewController(order_id:Int, table_name:String, table_id:Int) {
        let separateFoodViewController = SeparateFoodViewController()
        separateFoodViewController.table_id = table_id
        separateFoodViewController.table_name = table_name
        separateFoodViewController.order_id = order_id
        separateFoodViewController.delegate = self
        separateFoodViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: separateFoodViewController)
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
    
    func presentModalSlitFoodViewController(order_id:Int, branch_id:Int, destination_table_id:Int, target_table_id:Int, destination_table_name:String, target_table_name:String, target_order_id:Int) {
        let splitFoodViewController = SplitFoodViewController()
        splitFoodViewController.delegate = self
        splitFoodViewController.view.backgroundColor = ColorUtils.blackTransparent()
        splitFoodViewController.branch_id = branch_id
        splitFoodViewController.order_id = order_id
        splitFoodViewController.destination_table_id = destination_table_id
        splitFoodViewController.target_table_id = target_table_id
        splitFoodViewController.destination_table_name = destination_table_name
        splitFoodViewController.target_table_name = target_table_name
        splitFoodViewController.target_order_id = target_order_id
            let nav = UINavigationController(rootViewController: splitFoodViewController)
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
        self.fetchOrders(key_word: "")
    }
  
    
    
}
extension OrderViewController:OrderActionViewControllerDelegate, QRCodeCashbackBillDelegate{
    func callBackComfirmMoveTable(order_id:Int, destination_table_name: String, target_table_name: String, destination_table_id: Int, target_table_id: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.presentModalSeparateFoodViewController(order_id:order_id, table_name: destination_table_name, table_id: destination_table_id)
            
        }
    }
    
    func callBackOrderAction(destination_table_id:Int, destination_table_name:String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.presentModalChooseTableNeedMoveViewController(table_name: destination_table_name, table_id: destination_table_id)
        }
        
        
    }
    func callBackOrderActionMergeTable(destination_table_id:Int, destination_table_name:String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.presentModalChooseTableNeedMergeViewController(table_name: destination_table_name, table_id: destination_table_id)
        }
    }
    // Thay trường employeeId -> enployee_id
    // Thêm biến employee_id:Int
    func callBackOrderActionSharePoint(order_id: Int, table_name:String, employeeId:Int) {
        dLog(ManageCacheObject.getCurrentUser().employee_rank_id)
        if(Utils.checkRoleManagerOrder(permission: ManageCacheObject.getCurrentUser().permissions, employeeId: employeeId)){
            viewModel.order_id.accept(order_id)
            viewModel.table_name.accept(table_name)
            viewModel.makeChooseEmployeeSharePointViewController()
        }else{
            JonAlert.showError(message: "Bạn không có quyền chia điểm cho nhân viên khác hãy liên hệ quản lý để được cấp quyền.", duration: 3.0)
        }
        
    }
    func callBackOrderActionCloseTable(table_id: Int) {
        //CALL API CLOSE TABLE HERE...
        viewModel.table_id.accept(table_id)
        self.closeTable()
    }
    func callBackQRCodeCashbackBill(order_id: Int, qrcode: String) {
        dLog(qrcode)
                
//    CUSTOMER_GIFT:restaurant_id:restaurant_brand_id:customer_gift_id
        let str_qrcode = qrcode.components(separatedBy: [":"])
        
        if str_qrcode[0] == "CUSTOMER_GIFT"{
//            self.viewModel.qrcode.accept(qrcode)
//            self.viewModel.order_id.accept(order_id)
//            self.viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
//            self.viewModel.makeGiftDetailViewController()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.presentModalGifDetailViewController(order_id: order_id, branch_id: ManageCacheObject.getCurrentBranch().id, qrcode: qrcode)
            }
            
        } else {
            viewModel.order_id.accept(order_id)
            viewModel.qrcode.accept(qrcode)
            self.assignCustomerToBill()
        }
        
    }
    
}
extension OrderViewController{
    
    func setupSocketIO(){
        // socket io here
        let namespace = String(format: "/restaurants_%d_branches_%d", ManageCacheObject.getCurrentUser().restaurant_id, ManageCacheObject.getCurrentUser().branch_id)
        
        SocketIOManager.shareSocketRealtimeInstance().initSocketInstance(namespace)
        SocketIOManager.shareSocketRealtimeInstance().establishConnection()
        
        SocketIOManager.shareSocketRealtimeInstance().socketRealTime?.on("connect") {data, ack in
            
            self.real_time_url = String(format: "%@/%d/%@/%d/%@","restaurants", ManageCacheObject.getCurrentUser().restaurant_id,"branches", ManageCacheObject.getCurrentUser().branch_id,"orders")
            
            SocketIOManager.shareSocketRealtimeInstance().socketRealTime!.emit("join_room", self.real_time_url)
            
            SocketIOManager.shareSocketRealtimeInstance().socketRealTime!.on(self.real_time_url) {data, ack in
                let order = Mapper<Order>().map(JSONObject: data[0])!
                if(order.order_status == ORDER_STATUS_WAITING_MERGED){
                    self.fetchOrders(key_word: "")
                }else{
                    self.updateOrderInArray(order: order)
                }
                
            }
        }
        
        

    }
    
    func updateOrderInArray(order:Order) {
        list_orders = self.viewModel.dataArray.value
        
        if list_orders.first(where: { $0.id == order.id }) != nil {
            //do something
            
            if(list_orders.count > 0 ){
                //phần tử nào hiện đã được thanh toán thì xoá khỏi list_order (danh sách hiển thị local)
                list_orders.removeAll { $0.order_status == ORDER_STATUS_COMPLETE }
                for i in 0..<list_orders.count {
                    
                        if(list_orders[i].id == order.id){
                            debugPrint(String(format: "order.total_order_detail_customer_request: %d", order.total_order_detail_customer_request))
                            switch order.order_status {
                            case ORDER_STATUS_OPENING:
                                dLog(i)
                                list_orders.remove(at: i)
                                list_orders.insert(order, at: i)
                                break
                            case ORDER_STATUS_REQUEST_PAYMENT:
                                dLog(i)
                                list_orders.remove(at: i)
                                list_orders.insert(order, at: 0)//sort order to top list
                                break
                            case ORDER_STATUS_WAITING_WAITING_COMPLETE:
                                dLog(i)
                                list_orders.remove(at: i)
                                list_orders.insert(order, at: 0)//sort order to top list
                                break
                            case ORDER_STATUS_COMPLETE:
                                dLog(i)
                                //                            list_orders.remove(at: i)//remove order done out array
                                list_orders[i].order_status = ORDER_STATUS_COMPLETE
//                                list_orders.removeAll { $0.id == order.id }
                                break
                            case ORDER_STATUS_WAITING_MERGED:
                                dLog(i)
                                list_orders.remove(at: i)//remove order done out array
                                break
                            default:
                                list_orders.remove(at: i)
                                list_orders.insert(order, at: i)
                                
                            }
                    }
                }
            }
          
        }else{
            list_orders.insert(order, at: list_orders.count)
        }
        //xoá bỏ dữ liệu cũ đã lưu
        self.viewModel.dataArray.accept([])
        self.viewModel.allOrders.accept([])
        //lưu giữ liệu mới
        self.viewModel.dataArray.accept(list_orders)
        self.viewModel.allOrders.accept(list_orders)
        
        //giải pháp có thể dùng tạm - nhưng khả năng realtime giảm
       
        dLog(list_orders.toJSON())
    }
    
    
}
extension OrderViewController:OrderMoveFoodDelegate{
    func callBackNavigatorViewControllerNeedMoveFood(order_id:Int, destination_table_name:String, target_table_name:String, destination_table_id:Int, target_table_id:Int, only_one:Int, target_order_id:Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.presentModalSlitFoodViewController(order_id: order_id, branch_id: ManageCacheObject.getCurrentBranch().id, destination_table_id:destination_table_id,  target_table_id:target_table_id,destination_table_name:destination_table_name, target_table_name:target_table_name, target_order_id: target_order_id)
        }
    }
}
extension OrderViewController{
    func checkLevelShowCurrentPointOfEmployee(){
        if(ManageCacheObject.getSetting().service_restaurant_level_id < GPQT_LEVEL_ONE){
            Utils.isHideAllView(isHide: true, view: view_btn_filter_all)
            Utils.isHideAllView(isHide: true, view: view_btn_filter_my_order)
            Utils.isHideAllView(isHide: true, view: view_btn_filter_opening)
            Utils.isHideAllView(isHide: true, view: view_btn_filter_request_payment)
            Utils.isHideAllView(isHide: true, view: view_btn_filter_waiting_payment)
            constraint_widht_search.constant = self.view.frame.size.width - 16
            root_view_point.isHidden = true
            height_of_root_view_point.constant = 0
  
        }
    }
    
  
    
}
extension OrderViewController{
    func presentModalDialogUpdateVersionViewController(is_require_update:Int, content:String) {
        let dialogConfirmUpdateVersionViewController = DialogConfirmUpdateVersionViewController()
        dialogConfirmUpdateVersionViewController.is_require_update = is_require_update
        dialogConfirmUpdateVersionViewController.content = content
       
        dialogConfirmUpdateVersionViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: dialogConfirmUpdateVersionViewController)
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
extension OrderViewController: UsedGiftDelegate{

    func presentModalGifDetailViewController(order_id:Int, branch_id:Int, qrcode:String) {
            let dialogGiftDetailViewController = DialogGiftDetailViewController()
            dialogGiftDetailViewController.delegate = self
            dialogGiftDetailViewController.order_id = order_id
            dialogGiftDetailViewController.qrcode = qrcode
            dialogGiftDetailViewController.branch_id = branch_id
        
            dialogGiftDetailViewController.view.backgroundColor = ColorUtils.blackTransparent()

           
            let nav = UINavigationController(rootViewController: dialogGiftDetailViewController)
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
    func callBackUsedGift(order_id: Int) {
        self.viewModel.order_id.accept(order_id)
        self.viewModel.makeOrderDetailViewController()
    }
}
