//
//  ExtraFoodViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 21/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class ExtraFoodViewModel: BaseViewModel {
   
    private(set) weak var view: ExtraFoodViewController?
    private var router = ExtraFoodRouter()
    
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var extra_charge_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    public var order_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)

    public var name : BehaviorRelay<String> = BehaviorRelay(value: "")

    public var price : BehaviorRelay<Int> = BehaviorRelay(value: 0)

    public var quantity : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var note : BehaviorRelay<String> = BehaviorRelay(value: "")

    public var restaurant_brand_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var status : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    var food_name = BehaviorRelay<String>(value: "")
    var food_note = BehaviorRelay<String>(value: "")
    
    var isValidFoodName: Observable<Bool> {
        return self.food_name.asObservable().map {
            food_name in
            food_name.count >= 2 &&
            food_name.count <= 50
        }
    }
    
    var isValidFoodNote: Observable<Bool> {
       return  self.food_note.asObservable().map {
            food_note in
           food_note.count >= 0 &&
            food_note.count <= 255
           
//            if(self.extra_charge_id.value > 0){
//                food_note.count >= 2 &&
//                food_note.count <= 50
//            }else{
//                food_note.count >= 0 &&
//                food_note.count <= 50
//            }
           
        }
    }
    
    // Khai báo biến để lắng nghe kết quả của cả 3 sự kiện trên
    var isValid: Observable<Bool> {
        return isValidFoodNote
        return Observable.combineLatest(isValidFoodNote, isValidFoodName) {$0 && $1}
    }
    
    
    func bind(view: ExtraFoodViewController, router: ExtraFoodRouter){
        self.view = view
        self.router = router
        self.router.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router.navigateToPopViewController()
        
    }
    
}
// MARK: -- CALL API GET DATA FROM SERVER
extension ExtraFoodViewModel{
    func getExtraCharges() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.extra_charges(restaurant_brand_id:restaurant_brand_id.value, branch_id: branch_id.value, status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func addExtraCharge() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.addExtraCharge(
            branch_id: branch_id.value, order_id:order_id.value, extra_charge_id:extra_charge_id.value, name:name.value, price:price.value, quantity:quantity.value, note:note.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    
}
