//
//  BaseViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import ObjectMapper
extension BaseViewController {

        //MARK: Get all foods from server store local database
    public func syncDataFoods(area_id:Int){
            viewModels.areaId.accept(area_id)
            viewModels.getFoodSyncData().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    if let foods = Mapper<Food>().mapArray(JSONObject: response.data) {
                        // Save all Food To database local
                        ManagerRealmHelper.shareInstance().saveFoods(foods: foods, area_id: area_id)
                    }
                }else{
                    dLog(response.message ?? "")
                }
             
            }).disposed(by: rxbag)
        }
    
    public func syncDataArea(){
        viewModels.getAreasSyncData().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Areas Success...")
                
                if let areas  = Mapper<Area>().mapArray(JSONObject: response.data){
                    dLog(areas.toJSON())
                    var areaArray = areas
                    var area = Area()
                    area?.id = -1
                    area?.status = ACTIVE
                    area?.name = "Tất cả khu vực"
                    areaArray.insert(area!, at: 0)
                   
                    // Save all Area To database local
                    ManagerRealmHelper.shareInstance().saveAreas(areas: areaArray)
                    
                    for i in 0..<areas .count {
                        self.syncDataFoods(area_id:areas[i].id)
                       
                        if i == areas.count-1 {
                            JHProgressHUD.sharedHUD.hide()
                            NotificationCenter.default
                                        .post(name: NSNotification.Name("vn.techres.sync.food"),
                                         object: nil)
                        }
                    }
                }
               
            }
            
        }).disposed(by: rxbag)
    }
    public func syncData(){
        JHProgressHUD.sharedHUD.showInView(self.view)
        DbHelper.sharedDbHelper.deleteAll()
        self.syncDataArea()
        
    }
        
}
extension BaseViewController{
    func checkSyncData(){
//        viewModels.getSessions().subscribe(onNext: { (response) in
//            dLog(response.toJSON())
//          
//            if(response.code == RRHTTPStatusCode.ok.rawValue){
//                dLog(response)
//                let isUpdate = response.data as! Int
//                if isUpdate == ACTIVE {
//                    self.syncData()
//                }
//            }
//          
//          
//        }).disposed(by: rxbag)
        
    }
    
}
