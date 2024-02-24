//
//  SplitFoodViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class SplitFoodViewModel: BaseViewModel {
    private(set) weak var view: SplitFoodViewController?
    private var router: SplitFoodRouter?
    var order_id = BehaviorRelay<Int>(value: 0)
    var branch_id = BehaviorRelay<Int>(value: 0)
    var table_name = BehaviorRelay<String>(value: "")
    var order_detail_id = BehaviorRelay<Int>(value: 0)
    var food_status = BehaviorRelay<String>(value: "")
    
    // MARK: - Variable -
    // listing data array observe by rxswift
    public var dataArray : BehaviorRelay<[OrderDetail]> = BehaviorRelay(value: [])
    
    public var foods_move : BehaviorRelay<[FoodSplitRequest]> = BehaviorRelay(value: [])
    public var foods_extra_move : BehaviorRelay<[ExtraFoodSplitRequest]> = BehaviorRelay(value: [])
    var destination_table_id = BehaviorRelay<Int>(value: 0)
    var target_table_id = BehaviorRelay<Int>(value: 0)
    var target_order_id = BehaviorRelay<Int>(value: 0)
    func bind(view: SplitFoodViewController, router: SplitFoodRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
        
    }
}
extension SplitFoodViewModel{
    func getOrdersNeedMove() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.ordersNeedMove(branch_id:branch_id.value, order_id: order_id.value, food_status: food_status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    
    func moveFoods() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.moveFoods(branch_id:branch_id.value,order_id:order_id.value, destination_table_id: destination_table_id.value,target_table_id:target_table_id.value, foods: foods_move.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func moveExtraFoods() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.moveExtraFoods(branch_id:branch_id.value,order_id:order_id.value,target_order_id: target_order_id.value, foods: foods_extra_move.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
}
