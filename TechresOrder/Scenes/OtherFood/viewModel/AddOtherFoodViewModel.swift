//
//  AddOtherFoodViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 17/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class AddOtherFoodViewModel:BaseViewModel{

    private(set) weak var view: AddOtherFoodViewController?
    private var router: AddOtherFoodRouter?
    
    public var order_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    public var brand_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var status : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    public var dataOtherFoodRequest : BehaviorRelay<OtherFoodRequest> = BehaviorRelay(value: OtherFoodRequest.init())

    
    
    
    // Khai báo biến để hứng dữ liệu từ VC
    var food_name = BehaviorRelay<String>(value: "")
    var food_price = BehaviorRelay<Int>(value: 0)
    var food_description = BehaviorRelay<String>(value: "")
    var food_quantity = BehaviorRelay<Float>(value: 1.0)
    var check_allow_print = BehaviorRelay<Int>(value: 0)
    var kitchen_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var vat_id = BehaviorRelay<Int>(value: 0)
    
    var isValidFoodName: Observable<Bool> {
        return self.food_name.asObservable().map {
            food_name in
            food_name.count >= 2 &&
            food_name.count <= 50
        }
    }
    
    var isValidFoodPrice: Observable<Bool> {
        return self.food_price.asObservable().map {
            food_price in
            food_price >= 1000
        }
    }
    
    var isValidFoodDescription: Observable<Bool> {
        return self.food_description.asObservable().map {
            food_description in
            food_description.count >= 0 &&
            food_description.count <= 255
        }
    }
    
    
    // Khai báo biến để lắng nghe kết quả của cả 3 sự kiện trên
    var isValid: Observable<Bool> {
//        return Observable.combineLatest(isValidFoodName, isValidFoodPrice, isValidFoodDescription) {$0 && $1 && $2}
        return isValidFoodName
    }
    
    
    func bind(view: AddOtherFoodViewController, router: AddOtherFoodRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
 
    
    
}
extension AddOtherFoodViewModel{
    func getKitchenes() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.kitchenes(branch_id: branch_id.value, brand_id: brand_id.value, status:status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getVAT() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.vats)
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func addOtherFoods() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.addOtherFoods(
                branch_id: branch_id.value,
                order_id: self.order_id.value,
                foods: self.dataOtherFoodRequest.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
