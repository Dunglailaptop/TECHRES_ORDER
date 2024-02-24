//
//  ChooseTableNeedMergeViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import ObjectMapper
import JonAlert
extension ChooseTableNeedMergeViewController {
    
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
extension ChooseTableNeedMergeViewController:MoveTableDelegate{
    func callBackComfirmMoveTable(destination_table_name:String, target_table_name:String, destination_table_id:Int, target_table_id:Int) {
        dLog("callBackComfirmMoveTable")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.viewModel.destination_table_id.accept(destination_table_id)
//            self.viewModel.target_table_ids.accept(target_table_id)
//            self.viewModel.branch_id.accept(ManageCacheObject.getCurrentUser().branch_id)
            self.mergeTable()
        }
    }
    
   
    
}
//MARK: CALL API TO SERVER
extension ChooseTableNeedMergeViewController {
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
                    self.viewModel.table_array.accept(tables.filter({$0.status != 1 && $0.status != 3 && $0.order_status != 1 && $0.order_status != 4}))
                    self.view_nodata.isHidden = tables.count > 0 ? true : false
                }
            }
        }).disposed(by: rxbag)
    }
    
    func mergeTable(){
        viewModel.mergeTable().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Merge Tables Success...")
                Toast.show(message: "Gộp bàn thành công", controller: self)
                self.delegateCallBackReload?.callBackReload()
                self.navigationController?.dismiss(animated: true)
            }else{
                JonAlert.showError(message:response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
        
    }
}
