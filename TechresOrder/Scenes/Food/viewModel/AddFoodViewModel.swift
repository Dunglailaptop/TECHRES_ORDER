//
//  AddFoodViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 16/01/2023.
//

import UIKit
import RxSwift
import RxRelay


class AddFoodViewModel: BaseViewModel {
    private(set) weak var view: AddFoodViewController?
    private var router: AddFoodRouter?
    
    public var order_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var restaurant_brand_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var area_id : BehaviorRelay<Int> = BehaviorRelay(value: -1)
    public var category_id : BehaviorRelay<Int> = BehaviorRelay(value: -1)
    public var category_type : BehaviorRelay<Int> = BehaviorRelay(value: -1)
    public var is_allow_employee_gift : BehaviorRelay<Int> = BehaviorRelay(value: -1)
    public var is_sell_by_weight : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var is_out_stock : BehaviorRelay<Int> = BehaviorRelay(value: -1)
    public var is_use_point : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var table_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)

    public var key_word : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var addtionFoods : BehaviorRelay<[FoodInCombo]> = BehaviorRelay(value: [])
    public var dataArray : BehaviorRelay<[Food]> = BehaviorRelay(value: [])
    public var allFoods : BehaviorRelay<[Food]> = BehaviorRelay(value: [])

    public var extraFoods : BehaviorRelay<[FoodInCombo]> = BehaviorRelay(value: [])
    
    public var dataFoodRequest : BehaviorRelay<[FoodRequest]> = BehaviorRelay(value: [])
    public var dataFoodSelected : BehaviorRelay<[Food]> = BehaviorRelay(value: [])

    
    public var table_name = BehaviorRelay<String>(value: "")

    public var limit : BehaviorRelay<Int> = BehaviorRelay(value: 200)
    
    func bind(view: AddFoodViewController, router: AddFoodRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makeOrderDetailViewController(){
        router?.navigateToOrderDetailViewController(order_id: order_id.value, table_name:table_name.value)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
 
}
extension AddFoodViewModel{
    func foods() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.foods(
            branch_id: branch_id.value,
            area_id: self.area_id.value,
            category_id: self.category_id.value,
            category_type: self.category_type.value,
            is_allow_employee_gift: self.is_allow_employee_gift.value,
            is_sell_by_weight: self.is_sell_by_weight.value,
            is_out_stock: self.is_out_stock.value, key_word: self.key_word.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func addFoods() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.addFoods(
                branch_id: branch_id.value,
                order_id: self.order_id.value,
                foods: self.dataFoodRequest.value,
                is_use_point: self.is_use_point.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func addGiftFoods() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.addGiftFoods(
                branch_id: branch_id.value,
                order_id: self.order_id.value,
                foods: self.dataFoodRequest.value,
                is_use_point: self.is_use_point.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func openTable() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.openTable(
                table_id: table_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func healthCheckDataChangeFromServer() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.healthCheckChangeDataFromServer(branch_id: branch_id.value, restaurant_brand_id: restaurant_brand_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}

