//
//  ManagementAreaViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper
import RxRelay

class ManagementAreaViewModel: BaseViewModel {
    private(set) weak var view: ManagementAreaViewController?
    private var router: ManagementAreaRouter?
    
    var branch_id = BehaviorRelay<Int>(value: 0)
    var status = BehaviorRelay<Int>(value: 0)
    public var area_array : BehaviorRelay<[Area]> = BehaviorRelay(value: [])
    var area_id = BehaviorRelay<Int>(value: 0)
    var exclude_table_id = BehaviorRelay<Int>(value: 0)
    
    
    func bind(view: ManagementAreaViewController, router: ManagementAreaRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
extension ManagementAreaViewModel{
    func getAreas() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.areas(branch_id: branch_id.value, status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
}
