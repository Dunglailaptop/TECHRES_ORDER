//
//  OrderDetailViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit
import RxSwift
import RxRelay
import ObjectMapper

class OrderDetailViewModel: NSObject {
    private(set) weak var view: OrderDetailViewController?
    private var router: OrderDetailRouter?
    var order_id = BehaviorRelay<Int>(value: 0)
    var order_detail_ids = BehaviorRelay<[Int]>(value: [])
    var branch_id = BehaviorRelay<Int>(value: 0)
    var area_id = BehaviorRelay<Int>(value: 0)
    var table_name = BehaviorRelay<String>(value: "")
    var note = BehaviorRelay<String>(value: "")
    var order_detail_id = BehaviorRelay<Int>(value: 0)
    var quantity = BehaviorRelay<Int>(value: 0)
    var reason_cancel_food = BehaviorRelay<String>(value: "")
    var is_gift = BehaviorRelay<Int>(value: 0)
    var booking_status = BehaviorRelay<Int>(value: -1)
    var print_type = BehaviorRelay<Int>(value: 1) // 2- Hủy món | 3- trả bia | 1- món mới
    
    // MARK: - Variable -
    // listing data array observe by rxswift
    public var dataArray : BehaviorRelay<[OrderDetail]> = BehaviorRelay(value: [])
    
    public var dataUpdateFoodsRequest : BehaviorRelay<[FoodUpdateRequest]> = BehaviorRelay(value: [])

    
    var isChange = BehaviorRelay<Int>(value: 0)
    
    func bind(view: OrderDetailViewController, router: OrderDetailRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
        
    }
            
    func makeNavigatorAddFoodViewController(){
        router?.navigateToAddFoodViewController(area_id: self.area_id.value, is_gift:self.is_gift.value, order_id: self.order_id.value, table_name: table_name.value,booking_status: booking_status.value)
        
    }
    
    func makeNavigatorAddOtherOrExtraFoodViewController(){
        router?.navigateToAddOtherOrExtraFoodViewController(order_id: self.order_id.value, table_name: table_name.value)
        
    }
    
    
    func makePayMentViewController(){
        router?.navigateToPayMentViewController(order_id: order_id.value)
    }
    
    
  
    
}
extension OrderDetailViewModel{
    func getOrder() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.order(order_id: order_id.value, branch_id: branch_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func getFoodBookingStatus() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getFoodsBookingStatus(order_id: order_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func addNoteToOrderDetail() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.addNoteToOrderDetail(branch_id: branch_id.value, order_detail_id: order_detail_id.value, note:note.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func cancelFood() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.cancelFood(branch_id: branch_id.value, order_id: order_id.value, reason: reason_cancel_food.value, order_detail_id: order_detail_id.value, quantity: quantity.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func cancelExtraCharge() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.cancelExtraCharge(branch_id: branch_id.value, order_id: order_id.value, reason: reason_cancel_food.value, order_extra_charge: order_detail_id.value, quantity: quantity.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func updateFoods() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateFoods(
                branch_id: branch_id.value,
                order_id: self.order_id.value,
                foods: self.dataUpdateFoodsRequest.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getFoodsNeedPrint() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.foodsNeedPrint(order_id: order_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func requestPrintChefBar() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.requestPrintChefBar(order_id: order_id.value, branch_id: branch_id.value, print_type: print_type.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func updateReadyPrinted() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateReadyPrinted(order_id: order_id.value, order_detail_ids: order_detail_ids.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
}
