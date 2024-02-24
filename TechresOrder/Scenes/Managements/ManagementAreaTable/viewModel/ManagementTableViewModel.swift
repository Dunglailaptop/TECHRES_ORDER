//
//  ManagementTableViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import RxSwift
import RxRelay
class ManagementTableViewModel: BaseViewModel {
    private(set) weak var view: ManagementTableViewController?
    private var router: ManagementTableRouter?
    
    
    
    var branch_id = BehaviorRelay<Int>(value: 0)
    var status = BehaviorRelay<String>(value: "0")
    var status_area = BehaviorRelay<Int>(value: 0)
    public var area_array : BehaviorRelay<[Area]> = BehaviorRelay(value: [])
    public var table_array : BehaviorRelay<[TableModel]> = BehaviorRelay(value: [])
    var area_id = BehaviorRelay<Int>(value: 0)
    var exclude_table_id = BehaviorRelay<Int>(value: 0)
    
    
    
    func bind(view: ManagementTableViewController, router: ManagementTableRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
extension ManagementTableViewModel{
    
    func getAreas() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.areas(branch_id: branch_id.value, status: status_area.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getTables() -> Observable<APIResponse> {
           return appServiceProvider.rx.request(.tablesManager(area_id:area_id.value,branch_id:branch_id.value, status:-1, is_deleted: 0))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
            
    
}
