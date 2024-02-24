//
//  CreateFoodViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class CreateFoodViewModel: BaseViewModel {
    private(set) weak var view: CreateFoodViewController?
    private var router:CreateFoodRouter?
    var branch_id = BehaviorRelay<Int>(value: 0)
    var brand_id = BehaviorRelay<Int>(value: 0)
    var kitchen_id = BehaviorRelay<Int>(value: 0)
    var status = BehaviorRelay<Int>(value: 0)
    var vat_id = BehaviorRelay<Int>(value: 0)
    var text_tempory_price_by_time = BehaviorRelay<String>(value: "")
    var text_percent_tempory = BehaviorRelay<String>(value: "")
    
    
    public var dataArray : BehaviorRelay<[Category]> = BehaviorRelay(value: [])
    
    var foodRequest = BehaviorRelay<CreateFoodRequest>(value: CreateFoodRequest.init())
    
    func bind(view: CreateFoodViewController, router: CreateFoodRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    var isValidTextPercentTempory: Observable<Bool> {
        return self.text_percent_tempory.asObservable().map { percent in
            percent.count >= Constants.DISCOUNT_FORM_REQUIRED.requiredDiscountPercentMinLength &&
            percent.count <= Constants.DISCOUNT_FORM_REQUIRED.requiredDiscountPercentMaxLengthString
        }
    }
    
 
    
}
extension CreateFoodViewModel{
    
    func getKitchenes() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.kitchenes(branch_id: branch_id.value, brand_id: brand_id.value, status:status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getCategories() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.categoriesManagement(branch_id:branch_id.value,status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getUnits() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.units)
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func createFood() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.createFood(branch_id: branch_id.value, foodRequest: foodRequest.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func updateFood() -> Observable<APIResponse> {
        dLog(foodRequest.value)
        return appServiceProvider.rx.request(.updateFood(branch_id: branch_id.value, foodRequest: foodRequest.value))
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
    
}
