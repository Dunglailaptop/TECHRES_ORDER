//
//  SeparateFoodViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import ObjectMapper
extension ChooseTableNeedMoveViewController {
    
    func presentModalConfirmMoveTableViewController(destination_table_name:String, target_table_name:String, destination_table_id:Int, target_table_id:Int) {
            let confirmMoveTableViewController = ConfirmMoveTableViewController()
            confirmMoveTableViewController.destination_table_name = destination_table_name
            confirmMoveTableViewController.target_table_name = target_table_name
            confirmMoveTableViewController.destination_table_id = destination_table_id
            confirmMoveTableViewController.target_table_id = target_table_id
            confirmMoveTableViewController.delegate = self
            confirmMoveTableViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: confirmMoveTableViewController)
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
extension ChooseTableNeedMoveViewController:MoveTableDelegate{
    func callBackComfirmMoveTable(destination_table_name:String, target_table_name:String, destination_table_id:Int, target_table_id:Int) {
        dLog("callBackComfirmMoveTable")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.viewModel.destination_table_id.accept(destination_table_id)
            self.viewModel.target_table_id.accept(target_table_id)
            self.viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
            self.moveTable()
            self.navigationController?.dismiss(animated: true)
        }
    }
    
}
//MARK: CALL API TO SERVER
extension ChooseTableNeedMoveViewController {
    
    func getAreas(){
        viewModel.getAreas().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Areas Success...")
                if let areas  = Mapper<Area>().mapArray(JSONObject: response.data){
                    dLog(areas.toJSON())
                    self.areas = areas
                    
                    var allArea = Area.init()
                    allArea?.id = -1
                    allArea?.status = ACTIVE
                    allArea?.name = "Tất cả khu vực"
                    self.areas.insert(allArea!, at: 0)
                    
                    self.areas[0].is_select = 1
                    self.viewModel.area_array.accept(self.areas)
                    self.viewModel.area_id.accept(self.areas[0].id)
                    self.getTables()
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
                    self.viewModel.table_array.accept(tables.filter({$0.status != ORDER_STATUS_WAITING_WAITING_COMPLETE && $0.status != STATUS_TABLE_BOOKING}))
                    
                    self.view_nodata.isHidden = tables.count > 0 ? true : false
                }
            }
        }).disposed(by: rxbag)
        
    }
    
    
    
    func moveTable(){
        viewModel.moveTable().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Tables Success...")
                self.delegateCallBack?.callBackReload()
                self.navigationController?.dismiss(animated: true)
            }
        }).disposed(by: rxbag)
        
    }
    
}
