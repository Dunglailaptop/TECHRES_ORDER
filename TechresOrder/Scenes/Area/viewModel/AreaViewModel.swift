//
//  AreaViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 14/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class AreaViewModel {
    private(set) weak var view: AreaViewController?
    private var router: AreaRouter?
    
    var branch_id = BehaviorRelay<Int>(value: 0)
    var order_id = BehaviorRelay<Int>(value: 0)
    var table_name = BehaviorRelay<String>(value: "")
    var status = BehaviorRelay<String>(value: "0")
    var status_area = BehaviorRelay<Int>(value: 0)
    public var table_array : BehaviorRelay<[TableModel]> = BehaviorRelay(value: [])
    public var area_array : BehaviorRelay<[Area]> = BehaviorRelay(value: [])
    var area_id = BehaviorRelay<Int>(value: 0)
    var exclude_table_id = BehaviorRelay<Int>(value: 0)
    var is_gift = BehaviorRelay<Int>(value: 0)
    var table_id = BehaviorRelay<Int>(value: 0)
    var order_statuses = BehaviorRelay<String>(value: "0")
    
    func bind(view: AreaViewController, router: AreaRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func makeOrderDetailViewController(){
        router?.navigateToOrderDetailViewController(order_id: order_id.value, table_name:table_name.value)
    }
    
    func makeNavigatorAddFoodViewController(){
        dLog(self.table_id.value)
        router?.navigateToAddFoodViewController(table_id: self.table_id.value, table_name:table_name.value, area_id: area_id.value) // Thêm biến area_id cho router gọi về AddFoodViewController
        
    }
    
 
}
extension AreaViewModel{
    func getAreas() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.areas(branch_id: branch_id.value, status: status_area.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
                                             
     func getTables() -> Observable<APIResponse> {
        
            return appServiceProvider.rx.request(.tables(branchId:branch_id.value, area_id:area_id.value, status:status.value, exclude_table_id: exclude_table_id.value))
                .filterSuccessfulStatusCodes()
                .mapJSON().asObservable()
                .showAPIErrorToast()
                .mapObject(type: APIResponse.self)
        }
    
    func closeTable() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.closeTable(table_id: table_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
                                                                                      
}
