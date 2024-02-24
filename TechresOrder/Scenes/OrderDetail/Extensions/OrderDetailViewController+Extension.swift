//
//  OrderDetailViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit
import ObjectMapper
import JonAlert
extension OrderDetailViewController: DialogConfirmDelegate{
    
    
    //dialog_type = 1 logout
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
        
        // CALL API UPDATE QUANTITY FOOD ORDER HERE...
        self.repairUpdateFoods()
        self.updateFoodsToOrder()
        viewModel.makePopViewController()
    }
    func cancel() {
        dLog("Cancel...")
        viewModel.makePopViewController()
    }
}

extension OrderDetailViewController:CaculatorInputQuantityDelegate{

    func presentModalInputQuantityViewController(position:Int) {
        let inputQuantityViewController = QuantityInputViewController()
        inputQuantityViewController.max_quantity = 999
        inputQuantityViewController.current_quantity = self.orderData?.order_details[position].quantity
        inputQuantityViewController.is_sell_by_weight = (self.orderData?.order_details[position].is_sell_by_weight)!
        inputQuantityViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: inputQuantityViewController)
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
        inputQuantityViewController.current_quantity = (self.orderData?.order_details[position].quantity)!
        inputQuantityViewController.delegate_quantity = self
        inputQuantityViewController.position = position
            present(nav, animated: true, completion: nil)

        }
      
    func callbackCaculatorInputQuantity(number: Float, position: Int) {
        var foods = viewModel.dataArray.value
        foods[position].quantity = number
       
        foods[position].isChange = Float(ACTIVE)
        viewModel.dataArray.accept(foods)
        viewModel.isChange.accept(ACTIVE)
        
//        let indexPath = IndexPath(item: position, section: 0)
//        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}

extension OrderDetailViewController{
   
    
    func presentModalNoteViewController(pos:Int, note:String = "", food_id:Int) {
            let noteViewController = NoteViewController()
            noteViewController.delegate = self
            noteViewController.pos = pos
            noteViewController.food_note = note
            noteViewController.food_id = food_id
            noteViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: noteViewController)
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
      
    
    func presentModalReasonCancelFoodViewController(order_detail_id:Int, is_extra_charge:Int, quantity:Int) {
            let reasonCancelFoodViewController = ReasonCancelFoodViewController()
        reasonCancelFoodViewController.order_detail_id = order_detail_id
        reasonCancelFoodViewController.branch_id = branch_id
        reasonCancelFoodViewController.is_extra_charge = is_extra_charge
        reasonCancelFoodViewController.quantity = quantity
        reasonCancelFoodViewController.delegate = self
        reasonCancelFoodViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: reasonCancelFoodViewController)
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
      
    
    func presentModalReturnBeerViewController(order_detail_id:Int) {
            let returnFoodViewController = ReturnFoodViewController()
//        reasonCancelFoodViewController.order_detail_id = order_detail_id
//        reasonCancelFoodViewController.branch_id = branch_id
//            returnFoodViewController.delegate = self
        
            returnFoodViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: returnFoodViewController)
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
    
    
    
    func presentModalSeparateFoodViewController(table_name:String, table_id:Int, only_one:Int = 0) {
            let separateFoodViewController = SeparateFoodViewController()
        separateFoodViewController.table_id = table_id
        separateFoodViewController.table_name = table_name
        separateFoodViewController.order_id = order_id
        separateFoodViewController.only_one = only_one
       
        
//        reasonCancelFoodViewController.branch_id = branch_id
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
    
  
    
}
extension OrderDetailViewController{
    public func handleNoteFood(pos:Int, note:String, food_id:Int) {
        print("handleNoteFood")
        self.presentModalNoteViewController(pos: pos, note: note, food_id:food_id)
    }

    public func handleSplitFood(table_name: String, table_id:Int) {
        print("handleSplitFood")
        if(Utils.checkRoleManagerOrder(permission: ManageCacheObject.getCurrentUser().permissions)){
            self.presentModalSeparateFoodViewController(table_name: table_name, table_id:table_id, only_one:1)
        }else{
            JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)

        }
            
       
    }

    public func handleCancelFood(order_detail_id:Int, is_extra_charge:Int, quantity:Int) {
       dLog(String(format: "order detail: %d", order_detail_id))
//        viewModel.quantity.accept(quantity)
        if(is_extra_charge == DEACTIVE){
            if(Utils.checkRoleCancelFoodCompleted(permission: ManageCacheObject.getCurrentUser().permissions)){
                self.presentModalReasonCancelFoodViewController(order_detail_id: order_detail_id, is_extra_charge: is_extra_charge, quantity:quantity)
            }else{
                JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)

            }
        }else{
            self.presentModalReasonCancelFoodViewController(order_detail_id: order_detail_id, is_extra_charge: is_extra_charge, quantity:quantity)
        }
        
      
    }

   
}
extension OrderDetailViewController:NotFoodDelegate{
    func callBackNoteFood(pos: Int, note: String) {
        viewModel.note.accept(note)
        viewModel.order_detail_id.accept(self.viewModel.dataArray.value[pos].id)
        //CALL API
        self.addNoteToFood()
    }
}


extension OrderDetailViewController:ReasonCancelFoodDelegate{
    func callBackReasonCancelFood(order_detail_id: Int, is_extra_charge:Int, reason:ReasonCancel, quantity:Int) {
        if(reason.content.count > 0){
            //CALL API CANCEL FOOD
            viewModel.order_detail_id.accept(order_detail_id)
            viewModel.reason_cancel_food.accept(reason.content)
            viewModel.order_id.accept(order_id)
            viewModel.quantity.accept(quantity)
            is_extra_charge == ACTIVE ? self.cancelExtraCharge() : self.cancelFood()
//            self.cancelFood()
        }else{
//            Toast.show(message: "Vui lòng chọn lý do hủy món", controller: self)
            JonAlert.showError(message: "Vui lòng chọn lý do hủy món!", duration: 2.0)
        }
      
    }
   
}

extension OrderDetailViewController{

    func CountSave(order:OrderDetailData = OrderDetailData()!) {
        self.view_number_update_food.isHidden = false
        let order_details = viewModel.dataArray.value
        var nDem = 0
        for index in 0..<order_details.count {
            if(order_details[index].isChange == 1) {
               nDem += 1
            }
        }
        
        if nDem == 0 {
            
            self.isHideRootUpdateFood(isHide: true)
            if(self.numberPrint == 0){
                self.height_total_estimate_constraint.constant = 10
                self.height_tableview_order_detail_constraint.constant = 70
            }else{
                self.height_total_estimate_constraint.constant = 56
                self.height_tableview_order_detail_constraint.constant = 120
            }
        } else {
            Utils.isHideAllView(isHide: true, view: root_view_review_food)
            
            self.height_total_estimate_constraint.constant = 56
            self.height_tableview_order_detail_constraint.constant = 120
            self.isHideRootUpdateFood(isHide: false)
            self.lbl_number_food_need_update.text = String(nDem)
        }
        
        if(order.is_allow_review == ACTIVE){
            checkShowReviewFood(numberNeedUpdate: nDem)
        }
        
       
    }
    
    func checkNumberNeedPrint(order:OrderDetailData){
        self.numberPrint = 0
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
                self.isHideRootChefBar(isHide: false)
            } else {
                self.isHideRootChefBar(isHide: true)
            }
            self.lbl_number_need_update.text = String(self.numberPrint)
        }
    }
    //MARK: -- CHECK SHOW ACTION REVIEW FOOD
    func checkShowReviewFood(numberNeedUpdate:Int){
       
        self.numberNeedUpdate = numberNeedUpdate
        if ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_ONE {
            if(numberNeedUpdate > 0){
                Utils.isHideView(isHide: true, view: root_view_review_food)
//                self.height_total_estimate_constraint.constant = 56
//                self.height_tableview_order_detail_constraint.constant = 70
            }else{
                Utils.isHideView(isHide: false, view: root_view_review_food)
                self.height_total_estimate_constraint.constant = 56
//                self.height_tableview_order_detail_constraint.constant = 70
            }
           
        }else{
            Utils.isHideView(isHide: true, view: root_view_review_food)
        }
         
    }
    func repairUpdateFoods(){
        var foodsUpdateRequest = [FoodUpdateRequest]()
        
        let foods = viewModel.dataArray.value
        for index in 0..<foods.count
        {
            var foodUpdate = FoodUpdateRequest.init()
            if(foods[index].isChange == 1) {
                foodUpdate.order_detail_id = foods[index].id
                foodUpdate.quantity = foods[index].quantity
                foodUpdate.note = foods[index].note
                foodsUpdateRequest.append(foodUpdate)
                
        
            }
            
        }
        viewModel.dataUpdateFoodsRequest.accept(foodsUpdateRequest)
        
    }
    
    func printFoodAfterCancel(){
        // check level khac 3 thì tiến hành xử lý in phiếu huỷ món
        if(ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_THREE){ // Level 3 tro len
            if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE){ // Level 1
                if(ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_TWO ||
                   ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_THREE){
                    // Xu ly in phieu huy
                    self.getFoodsNeedPrint( print_type:PRINT_TYPE_CANCEL_FOOD)
                }
            }else{// Level 2
                // Xu ly in phieu huy
                if(ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE ){
                    // in món huỷ thông qua điện thoại iphone
                    self.getFoodsNeedPrint( print_type:PRINT_TYPE_CANCEL_FOOD)
                    // xu ly goi api bao cho app thu ngan in phieu che bien
                }else if(ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_TWO){
                    self.viewModel.print_type.accept(PRINT_TYPE_REQUEST_CANCEL_FOOD)
                    self.requestPrintChefBar()
                }
            }
        }
    }
}
extension OrderDetailViewController{
    @objc func giftFoodNoteUpdate(_ notification: Notification) {
//        Toast.show(message: "Món tặng hoặc món combo không được phép thay đổi số lượng", controller: self)
        JonAlert.showError(message: "Món tặng hoặc món combo không được phép thay đổi số lượng!", duration: 2.0)
    }
    @objc func cancelFoodWhenQuantitySub(_ notification: Notification) {
        let quantity = notification.userInfo?["quantity"] as? Int
        if let order_detail_id = notification.userInfo?["order_detail_id"] as? Int {
               // do something with your order_detail_id
           if let is_extra_charge = notification.userInfo?["is_extra_Charge"] as? Int{
               self.presentModalReasonCancelFoodViewController(order_detail_id: order_detail_id, is_extra_charge:is_extra_charge, quantity: quantity ?? 1)
           }else{
               self.presentModalReasonCancelFoodViewController(order_detail_id: order_detail_id, is_extra_charge:DEACTIVE, quantity: quantity ?? 1)
           }
           
        }
        
        
    }
}
extension OrderDetailViewController: TechresDelegate{
    func callBackReload() {
        self.getOrder()
    }
    func presentModalSlitFoodViewController(order_id:Int, branch_id:Int, destination_table_id:Int, target_table_id:Int, destination_table_name:String, target_table_name:String, only_one:Int = 0, target_order_id:Int) {
        let splitFoodViewController = SplitFoodViewController()
        splitFoodViewController.delegate = self
        splitFoodViewController.view.backgroundColor = ColorUtils.blackTransparent()
        splitFoodViewController.branch_id = branch_id
        splitFoodViewController.order_id = order_id
        splitFoodViewController.only_one = only_one
        splitFoodViewController.order_details = self.order_details
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
    

    
    func presentModalReturnBeerViewController(order_id:Int, order_detail_id:Int, quantity:Int) {
            let returnFoodViewController = ReturnFoodViewController()
        returnFoodViewController.order_id = order_id
        returnFoodViewController.order_detail_id = order_detail_id
        viewModel.order_detail_id.accept(order_detail_id)
        returnFoodViewController.total = Float(quantity)
        returnFoodViewController.type = 1
        returnFoodViewController.delegateReturnBeer = self
        returnFoodViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: returnFoodViewController)
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
//            returnFoodViewController.delegate = self
            present(nav, animated: true, completion: nil)

        }
    
    
}
extension OrderDetailViewController:OrderMoveFoodDelegate{
    func callBackNavigatorViewControllerNeedMoveFood(order_id:Int, destination_table_name:String, target_table_name:String, destination_table_id:Int, target_table_id:Int, only_one:Int, target_order_id: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.presentModalSlitFoodViewController(order_id: order_id, branch_id: self.branch_id, destination_table_id:destination_table_id,  target_table_id:target_table_id, destination_table_name:destination_table_name, target_table_name: target_table_name, only_one: only_one, target_order_id: target_order_id)
        }
    }
}
extension OrderDetailViewController:ReturnBeerDelegate{
    func callBackReturnBeer(note: String) {
        // Xu ly in phieu trả
//        self.getOrder()
        self.note_return = note
        self.getFoodsNeedPrint( print_type:PRINT_TYPE_RETURN_FOOD)
    }
}
//MARK: -- show review food contrloller
extension OrderDetailViewController{
    
    func presentModalReviewFoodViewController(order_id:Int){
        let reviewFoodViewController = ReviewFoodViewController()
        reviewFoodViewController.delegate = self
        reviewFoodViewController.order_id = order_id
        reviewFoodViewController.view.backgroundColor = ColorUtils.blackTransparent()

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
    
//    func presentModalReviewFoodViewController(order_id:Int) {
//        let reviewFoodViewController = ReviewFoodViewController()
//        reviewFoodViewController.order_id = order_id
//        reviewFoodViewController.delete = self
//
//        reviewFoodViewController.view.backgroundColor = ColorUtils.blackTransparent()
//            let nav = UINavigationController(rootViewController: reviewFoodViewController)
//            // 1
//            nav.modalPresentationStyle = .overCurrentContext
//
//
//            // 2
//            if #available(iOS 15.0, *) {
//                if let sheet = nav.sheetPresentationController {
//
//                    // 3
//                    sheet.detents = [.large()]
//
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//            // 4
////            returnFoodViewController.delegate = self
//            present(nav, animated: true, completion: nil)
//
//
//        }
    
    
}
extension OrderDetailViewController{
    func setupSocketIO() {
        // socket io here
        let namespace = String(format: "/restaurants_%d_branches_%d", ManageCacheObject.getCurrentUser().restaurant_id, ManageCacheObject.getCurrentUser().branch_id)
        
        SocketIOManager.shareSocketRealtimeInstance().initSocketInstance(namespace)
        SocketIOManager.shareSocketRealtimeInstance().establishConnection()
        dLog(namespace)
      
        SocketIOManager.shareSocketRealtimeInstance().socketRealTime?.on("connect") {data, ack in
            self.real_time_url = String(format: "%@/%d/%@/%d/%@/%d","restaurants", ManageCacheObject.getCurrentUser().restaurant_id,"branches", ManageCacheObject.getCurrentUser().branch_id,"orders",self.order_id)
                    
            SocketIOManager.shareSocketRealtimeInstance().socketRealTime!.emit("join_room", self.real_time_url)
            

            SocketIOManager.shareSocketRealtimeInstance().socketRealTime!.on(self.real_time_url) {data, ack in
                dLog(data)
                self.getOrder()
                
            }
            dLog(self.real_time_url)
        }
        
        
        
        // == End socket io
    }
}
