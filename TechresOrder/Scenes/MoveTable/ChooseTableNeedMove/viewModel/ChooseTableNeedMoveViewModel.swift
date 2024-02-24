//
//  ChooseTableNeedMoveViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class ChooseTableNeedMoveViewModel: BaseViewModel {
    private(set) weak var view: ChooseTableNeedMoveViewController?
    private var router: ChooseTableNeedMoveRouter?
    
    var branch_id = BehaviorRelay<Int>(value: 0)
    var order_id = BehaviorRelay<Int>(value: 0)
    var table_name = BehaviorRelay<String>(value: "")
    var status = BehaviorRelay<String>(value: "0")
    var status_area = BehaviorRelay<Int>(value: 0)
    public var table_array : BehaviorRelay<[TableModel]> = BehaviorRelay(value: [])
    public var area_array : BehaviorRelay<[Area]> = BehaviorRelay(value: [])
    var area_id = BehaviorRelay<Int>(value: 0)
    var exclude_table_id = BehaviorRelay<Int>(value: 0)
    
    var destination_table_id = BehaviorRelay<Int>(value: 0)
    var target_table_id = BehaviorRelay<Int>(value: 0)
    
    func bind(view: ChooseTableNeedMoveViewController, router: ChooseTableNeedMoveRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
  
}
extension ChooseTableNeedMoveViewModel{
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
    
    func moveTable() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.moveTable(branch_id: branch_id.value, destination_table_id: destination_table_id.value, target_table_id: target_table_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
                                                                                      
}