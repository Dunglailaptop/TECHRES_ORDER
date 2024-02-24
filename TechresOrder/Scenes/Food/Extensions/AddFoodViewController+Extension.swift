//
//  AddFoodViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 17/01/2023.
//

import UIKit
import ObjectMapper
import JonAlert
extension AddFoodViewController {
    public func handleNoteFood(pos:Int, note:String) {
        print("handleNoteFood")
        self.presentModalNoteViewController(pos: pos, note: note)
    }
    
    func repairAddFoodToOrder(){
        let foods = self.viewModel.dataFoodSelected.value
        var foodRequests = [FoodRequest]()
        foods.enumerated().forEach { (index, value) in
            dLog(value.toJSON())
            var food_request = FoodRequest.init()
            food_request.id = value.id
            food_request.quantity = value.quantity
            food_request.note = value.note
           //CHECK ADDITION FOOD
            for item in foods[index].addition_foods {
                if item.is_selected == 1 && item.quantity > 0 {
                    food_request.addition_foods.append(item)
                }
            }
            // CHECK MUA 1 TANG 1
            for item in foods[index].food_list_in_promotion_buy_one_get_one {
                if item.is_selected == 1 && item.quantity > 0 {
                    food_request.buy_one_get_one_foods.append(item)
                }
            }
            
            foodRequests.append(food_request)
        }
        viewModel.dataFoodRequest.accept(foodRequests)
    }
}
extension AddFoodViewController{
    func presentModalNoteViewController(pos:Int, note:String = "") {
            let noteViewController = NoteViewController()
            noteViewController.delegate = self
            noteViewController.pos = pos
//        noteViewController.food_notes = self.foods[pos].food_notes
        noteViewController.food_id = self.foods[pos].id
            noteViewController.food_note = note
        
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
    
}

extension AddFoodViewController:NotFoodDelegate{
    func callBackNoteFood(pos: Int, note: String) {
//        var foods = viewModel.dataArray.value
        
        self.foods[pos].note = note
//        viewModel.dataArray.accept(foods)
        
        self.checkSelectFood()
        let indexPath = IndexPath(item: pos, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        
      
    }
}

extension AddFoodViewController:CaculatorInputQuantityDelegate{

    func presentModalInputQuantityViewController(position:Int) {
            let quantityInputViewController = QuantityInputViewController()
        
//            let inputQuantityViewController = InputQuantityViewController()
        quantityInputViewController.is_sell_by_weight = self.foods[position].is_sell_by_weight
        quantityInputViewController.current_quantity = self.foods[position].quantity
        quantityInputViewController.max_quantity = 1000
        quantityInputViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: quantityInputViewController)
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
        quantityInputViewController.delegate_quantity = self
        quantityInputViewController.position = position
            present(nav, animated: true, completion: nil)

        }
      
    func callbackCaculatorInputQuantity(number: Float, position: Int) {
        self.foods[position].quantity = number
        self.checkSelectFood()
        let indexPath = IndexPath(item: position, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}
extension AddFoodViewController:AdditionDelegate{
    func additionQuantity(quantity: Int, row: Int, itemIndex: Int, countGift: Int, food_addition_type:Int) {
        dLog(food_addition_type)
       
        if(food_addition_type == FOOD_ADDITION){
            if quantity == 0 {
                foods[row].addition_foods[itemIndex].is_selected = 0
                foods[row].addition_foods[itemIndex].quantity = 0
            }else {
                foods[row].addition_foods[itemIndex].is_selected = 1
                foods[row].addition_foods[itemIndex].quantity = quantity
            }
            dLog(foods[row].addition_foods)
        }else if(food_addition_type == FOOD_COMBO){
            if quantity == 0 {
                foods[row].food_in_combo[itemIndex].is_selected = 0
                foods[row].food_in_combo[itemIndex].combo_quantity = 0
            }
            else {
                foods[row].food_in_combo[itemIndex].is_selected = 1
                foods[row].food_in_combo[itemIndex].combo_quantity = quantity
            }
            dLog(foods[row].food_in_combo)
        }else{
            if quantity == 0 {
                foods[row].food_list_in_promotion_buy_one_get_one[itemIndex].is_selected = 0
                foods[row].food_list_in_promotion_buy_one_get_one[itemIndex].quantity = 0
            }
            else {
                foods[row].food_list_in_promotion_buy_one_get_one[itemIndex].is_selected = 1
                foods[row].food_list_in_promotion_buy_one_get_one[itemIndex].quantity = quantity
            }
            dLog(foods[row].food_list_in_promotion_buy_one_get_one)
        }
        self.checkSelectFood()
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)

    }
}

// MARK: CALL API
extension AddFoodViewController{
func openTable(){
        viewModel.openTable().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog(response)
                if let data  = Mapper<TableModel>().map(JSONObject: response.data){
                    self.order_id = data.order_id
                    self.viewModel.order_id.accept(self.order_id)
                    self.proccessAddFoodToOrder()
                }
            }else{
//                Toast.show(message: response.message ?? "Có lỗi trong quá trình giao tiếp server", controller: self)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    func healthCheckDataChangeFromServer(){
            viewModel.healthCheckDataChangeFromServer().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    dLog(response)
                    if let data  = Mapper<DataHealthCheck>().map(JSONObject: response.data){
                        if(data.is_update == ACTIVE){
                            // update data from server
                            self.syncData()
                        }else{
                            NotificationCenter.default
                                        .post(name: NSNotification.Name("vn.techres.sync.food"),
                                         object: nil)
                        }
                       
                       
                    }
                }
             
            }).disposed(by: rxbag)
        }
}
