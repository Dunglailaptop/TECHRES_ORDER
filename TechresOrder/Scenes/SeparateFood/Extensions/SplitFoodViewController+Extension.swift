//
//  SplitFoodViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import ObjectMapper
import JonAlert

//MARK : Binding view
extension SplitFoodViewController{
    func registerCell() {
        let splitFoodTableViewCell = UINib(nibName: "SplitFoodTableViewCell", bundle: .main)
        tableView.register(splitFoodTableViewCell, forCellReuseIdentifier: "SplitFoodTableViewCell")
        
        tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine

    }
    
func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "SplitFoodTableViewCell", cellType: SplitFoodTableViewCell.self))
           {  (row, orderDetail, cell) in
               cell.data = orderDetail
               cell.viewModel = self.viewModel
               // action payment
               cell.btnQuantity.rx.tap.asDriver()
                              .drive(onNext: { [weak self] in
                                  dLog("action btnQuantity")
                                  
                                  var quantity:Float = 0.0
                                  if let text = cell.quantity_txt.text {
                                      quantity = Float(text)!
                                  }
                                  if(orderDetail.is_sell_by_weight == ACTIVE){
                                      JonAlert.showError(message: String(format: "Món bán theo kg không được tách nhỏ mà chỉ tách tất cả. Hãy chọn dấu + hoặc dấu -", quantity), duration: 4.0)
                                  }else{
                                      self!.presentModalInputQuantityViewController(position: row, current_quantity:Float(quantity))
                                  }
                                  
                              }).disposed(by: cell.disposeBag)
               
               cell.preservesSuperviewLayoutMargins = false
               cell.separatorInset = UIEdgeInsets.zero
               cell.layoutMargins = UIEdgeInsets.zero
               
           }.disposed(by: rxbag)
       }
}

extension SplitFoodViewController{
    func repairSplitFoods(){
        var foodSplitRequests = [FoodSplitRequest]()
        var foodSplitExtraRequests = [ExtraFoodSplitRequest]()
        let foods = viewModel.dataArray.value
        for index in 0..<foods.count
        {
            var foodSplitRequest = FoodSplitRequest.init()
            var foodSplitExtraRequest = ExtraFoodSplitRequest.init()
            if(foods[index].isChange > 0) {
                if(foods[index].is_extra_Charge == ACTIVE){
                    foodSplitExtraRequest.extra_charge_id = foods[index].id
                    foodSplitExtraRequest.quantity = foods[index].isChange
                    foodSplitExtraRequests.append(foodSplitExtraRequest)
                    
                }else{
                    foodSplitRequest.order_detail_id = foods[index].id
                    foodSplitRequest.quantity = foods[index].isChange
                    foodSplitRequests.append(foodSplitRequest)
                }
        
            }
            
        }
        viewModel.foods_extra_move.accept(foodSplitExtraRequests)
        viewModel.foods_move.accept(foodSplitRequests)
        
    }
}

extension SplitFoodViewController:CaculatorInputQuantityDelegate{

    func presentModalInputQuantityViewController(position:Int, current_quantity:Float) {
        let quantityInputViewController = QuantityInputViewController()
        let foods = self.viewModel.dataArray.value
        //            let inputQuantityViewController = InputQuantityViewController()
        quantityInputViewController.is_sell_by_weight = foods[position].is_sell_by_weight
        quantityInputViewController.current_quantity = current_quantity
        quantityInputViewController.max_quantity = foods[position].quantity
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
        var foods = self.viewModel.dataArray.value
        let quantity = foods[position].quantity
        var quantity_change = foods[position].isChange
        
        quantity_change = number < quantity ? number : quantity
        
        if(number > quantity){
            if(foods[position].is_sell_by_weight == ACTIVE){
                JonAlert.showError(message: String(format: "Số lượng tối đa là %.2f", quantity), duration: 2.0)
            }else{
                JonAlert.showError(message: String(format: "Số lượng tối đa là %.0f", quantity), duration: 2.0)
            }
        }
        
        foods.enumerated().forEach { (index, value) in
            if(foods[position].id == value.id){
                foods[index].isChange = quantity_change
                foods[index].food_quantity = quantity_change
            }
        }
        dLog(foods.toJSON())
        viewModel.dataArray.accept(foods)
    }
    
}
