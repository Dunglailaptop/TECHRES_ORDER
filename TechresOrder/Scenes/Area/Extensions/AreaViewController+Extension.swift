//
//  AreaViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 15/02/2023.
//

import UIKit
import JonAlert
import ObjectMapper
extension AreaViewController{
    func getAreas(){
        viewModel.getAreas().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Areas Success...")
                if let areas  = Mapper<Area>().mapArray(JSONObject: response.data){
                    dLog(areas.toJSON())
                    self.areas = areas
                    var area = Area()
                    area?.id = -1
                    area?.name = "Tất cả khu vực"
                    self.areas.insert(area!, at: 0)
                    
//                    if(areas.count > 0){
                        self.areas[0].is_select = 1
                        self.viewModel.area_array.accept(self.areas)
                        self.viewModel.area_id.accept(-1)
                        self.count += 1
                        self.getTables()
//                    }
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
                    dLog(tables.count)
                    self.viewModel.table_array.accept(tables)
                }

            }
        }).disposed(by: rxbag)
        
    }
    
    func closeTable(){
            viewModel.closeTable().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    Toast.show(message: "Đóng bàn thành công", controller: self)
                    self.getTables()
                }else{
//                    JonAlert.show(message: response.message ?? "Có lỗi xảy ra trong quá trình giao tiếp với hệ thống. Vui lòng thử lại sau. ", andIcon: UIImage(named: "icon-cancel"), duration: 3.0)
                    dLog(response.message ?? "")
                }
             
            }).disposed(by: rxbag)
        }
    
}
extension AreaViewController{
    func checkLevelShowCurrentPointOfEmployee(){
        if(ManageCacheObject.getSetting().service_restaurant_level_id < 2){
            self.constraint_filter_view.constant = 10
            root_view_point.isHidden = true
        }
    }
}





extension AreaViewController: DialogConfirmDelegate{
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
        // CALL API CLOSE TABLE
        self.closeTable()
    }
    func cancel() {
        dLog("Cancel...")
    }
}
