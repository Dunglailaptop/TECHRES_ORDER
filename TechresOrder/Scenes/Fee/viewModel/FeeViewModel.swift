//
//  FeeViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit
import RxSwift
import RxRelay
class FeeViewModel: BaseViewModel {
    private(set) weak var view: FeeViewController?
    private var router:FeeRouter?
    public var dataSectionArray : BehaviorRelay<[Int]> = BehaviorRelay(value: [0,1,2])
    
    public var materialFees : BehaviorRelay<[Fee]> = BehaviorRelay(value: [])
    public var otherFees : BehaviorRelay<[Fee]> = BehaviorRelay(value: [])
    
    var material_fee_height = BehaviorRelay<Int>(value: 0)
    var other_fee_height = BehaviorRelay<Int>(value: 0)
    
    var branch_id = BehaviorRelay<Int>(value: 0)
    var status = BehaviorRelay<Int>(value: 0)
    
    var restaurant_budget_id = BehaviorRelay<Int>(value: -1)
    var from = BehaviorRelay<String>(value: "")
    var to = BehaviorRelay<String>(value: "")
    var type = BehaviorRelay<Int>(value: 1)
    var is_take_auto_generated = BehaviorRelay<Int>(value: -1)
    var order_session_id = BehaviorRelay<Int>(value: -1)
    var report_type = BehaviorRelay<Int>(value: 1)
    var addition_fee_statuses = BehaviorRelay<String>(value: "0,1,2,3,4,5")
    var is_paid_debt = BehaviorRelay<Int>(value: -1)
    
    
    var material_fee_total_amount = BehaviorRelay<Float>(value: 0.0)
    var other_fee_total_amount = BehaviorRelay<Float>(value: 0.0)
    var fee_total_amount = BehaviorRelay<Float>(value: 0.0)

    func bind(view: FeeViewController, router: FeeRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    func makeToCreateFeeViewController(){
        router?.navigateToCreateFeeViewController()
    }
    
    func makeToUpdateFeeMaterialViewController(materialFeeId:Int){
        router?.navigateToUpdateFeeMaterialViewController(materialFeeId: materialFeeId)
    }
    
    func makeToUpdateOtherFeedViewController(fee: Fee){
        router?.navigateToUpdateOtherFeedViewController(fee: fee)
    }
    
}
//MARK: CALL API
extension FeeViewModel{
    func fees() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.fees(branch_id: branch_id.value, restaurant_budget_id: restaurant_budget_id.value, from: from.value, to: to.value, type:type.value, is_take_auto_generated:is_take_auto_generated.value, order_session_id:order_session_id.value, report_type:report_type.value, addition_fee_statuses:addition_fee_statuses.value, is_paid_debt:is_paid_debt.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
