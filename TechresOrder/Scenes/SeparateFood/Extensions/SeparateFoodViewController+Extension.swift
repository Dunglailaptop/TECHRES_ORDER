//
//  SeparateFoodViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import ObjectMapper
extension SeparateFoodViewController {
    func presentModalConfirmSeparateFoodViewController(order_id: Int, destination_table_name:String, target_table_name:String, destination_table_id:Int, target_table_id:Int, target_order_id:Int) {
            let confirmSeparateFoodViewController = ConfirmSeparateFoodViewController()
            confirmSeparateFoodViewController.destination_table_name = destination_table_name
            confirmSeparateFoodViewController.target_table_name = target_table_name
        confirmSeparateFoodViewController.destination_table_id = destination_table_id
        confirmSeparateFoodViewController.target_table_id = target_table_id
        confirmSeparateFoodViewController.target_order_id = target_order_id
        confirmSeparateFoodViewController.order_id = order_id
        confirmSeparateFoodViewController.only_one = self.only_one
            confirmSeparateFoodViewController.delegate = self
            confirmSeparateFoodViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: confirmSeparateFoodViewController)
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
extension SeparateFoodViewController:MoveFoodDelegate{
    func callBackComfirmSelectTableNeedMoveFood(order_id:Int, destination_table_name:String, target_table_name:String, destination_table_id:Int, target_table_id:Int, target_order_id:Int) {
        dLog("callBackComfirmSelectTableNeedMoveFood")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.delegate?.callBackNavigatorViewControllerNeedMoveFood(order_id:order_id, destination_table_name:destination_table_name, target_table_name:target_table_name, destination_table_id:destination_table_id, target_table_id:target_table_id, only_one:self.only_one, target_order_id: target_order_id)

            self.navigationController?.dismiss(animated: true)
        }
    }
    
}

//MARK: call API here
extension SeparateFoodViewController {
    func getAreas(){
        viewModel.getAreas().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Areas Success...")
                if let areas  = Mapper<Area>().mapArray(JSONObject: response.data){
                    dLog(areas.toJSON())
                    self.areas = areas
                    if(self.areas.count > 0){
                        var allArea = Area.init()
                        allArea?.id = -1
                        allArea?.status = ACTIVE
                        allArea?.name = "Tất cả"
                        self.areas.insert(allArea!, at: 0)
                        self.areas[0].is_select = 1
                        
                        self.viewModel.area_array.accept(self.areas)
                        self.viewModel.area_id.accept(-1)
                        self.getTables()
                    }
                    
                }
               
            }
            
           
        }).disposed(by: rxbag)
        
    }
    func getTables(){
        viewModel.getTables().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Tables Success...")
                if let tables  = Mapper<TableModel>().mapArray(JSONObject: response.data){
                    dLog(tables.toJSON())
                    //không hiển cả những bàn đang chờ thu tiền
                    self.viewModel.table_array.accept(tables.filter({
                        $0.status != ORDER_STATUS_WAITING_WAITING_COMPLETE &&
                        $0.status != STATUS_TABLE_BOOKING &&
                        $0.order_status != 4
                    }))
                }

            }
        }).disposed(by: rxbag)
        
    }
}
