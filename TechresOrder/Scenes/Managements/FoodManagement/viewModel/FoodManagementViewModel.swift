//
//  FoodManagementViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class FoodManagementViewModel: BaseViewModel {
    private(set) weak var view: FoodManagementViewController?
    private var router: FoodManagementRouter?
    var branch_id = BehaviorRelay<Int>(value: 0)
    var status = BehaviorRelay<Int>(value: 0)
    public var dataArray : BehaviorRelay<[Food]> = BehaviorRelay(value: [])
    public var dataFoodSearchArray : BehaviorRelay<[Food]> = BehaviorRelay(value: [])
    
    public var food : BehaviorRelay<Food> = BehaviorRelay(value: Food.init())// Only for update food
    
    
    func bind(view: FoodManagementViewController, router: FoodManagementRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    func makeCreateFoodViewController(){
        router?.navigateToCreateFoodViewController(food: food.value)
        
    }
}
extension FoodManagementViewModel{
    func getFoodsManagement() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.foodsManagement(branch_id:branch_id.value,status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
