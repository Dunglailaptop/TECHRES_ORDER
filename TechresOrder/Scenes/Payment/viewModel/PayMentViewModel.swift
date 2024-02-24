//
//  PayMentViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class PayMentViewModel: BaseViewModel {
    private(set) weak var view: PayMentViewController?
    private var router: PayMentRouter?
   
    public var dataSectionArray : BehaviorRelay<[Int]> = BehaviorRelay(value: [])
    public var dataOrderDetails : BehaviorRelay<[OrderDetail]> = BehaviorRelay(value: [])
    
    public var orderDetailData : BehaviorRelay<OrderDetailData> = BehaviorRelay(value: OrderDetailData.init()!)
    
    var order_id = BehaviorRelay<Int>(value: 0)
    var branch_id = BehaviorRelay<Int>(value: 0)
    var print_type = BehaviorRelay<Int>(value: 1) // 2- Hủy món | 3- trả bia | 1- món mới
    var food_status = BehaviorRelay<String>(value: "")
    var is_print_bill = BehaviorRelay<Int>(value: 1)
    var customer_slot_number = BehaviorRelay<Int>(value: 0)
    var order_detail_height = BehaviorRelay<Int>(value: 0)
    var order_detail_height_payment_info = BehaviorRelay<Int>(value: 0)
    var order_detail_ids = BehaviorRelay<[Int]>(value: [])
    var payment_method = BehaviorRelay<Int>(value: 0)
    var is_include_vat = BehaviorRelay<Int>(value: 0)
    
    var cash_amount = BehaviorRelay<Int>(value: 0)
    var bank_amount = BehaviorRelay<Int>(value: 0)
    var transfer_amount = BehaviorRelay<Int>(value: 0)
    var payment_method_id = BehaviorRelay<Int>(value: 0)
    var tip_amount = BehaviorRelay<Int>(value: 0)
    
    var discount_type = BehaviorRelay<Int>(value: 0)
    var discount_percent = BehaviorRelay<Int>(value: 0)
    var note = BehaviorRelay<String>(value: "")

    
    
    
    func bind(view: PayMentViewController, router: PayMentRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
        
    }
    
    func makePopViewControllerWithoutAnimation(){
        router?.navigationToPopViewControllerWithoutAnimation()
        
    }
    
    func makeNavigatorReviewFoodViewController(){
        router?.navigateToReviewFoodViewController(order_id: self.order_id.value)
        
    }
    
    func makeNavigatorOrderDetailViewController(){
        router?.navigateToOrderDetailViewController(order_id: self.order_id.value)
        
    }
    
}
extension PayMentViewModel{
    func discount() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.discount(order_id:order_id.value, branch_id:branch_id.value, discount_type:discount_type.value, discount_percent:discount_percent.value, note:note.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getOrderDetail() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getOrderDetail(order_id: order_id.value, branch_id: branch_id.value, is_print_bill:is_print_bill.value, food_status:food_status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func updateCustomerNumberSlot() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateCustomerNumberSlot( branch_id: branch_id.value, order_id: order_id.value, customer_slot_number:customer_slot_number.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func requestPayment() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.requestPayment( branch_id: branch_id.value, order_id: order_id.value, payment_method:payment_method.value, is_include_vat:is_include_vat.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func completedPayment() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.completedPayment( branch_id: branch_id.value, order_id: order_id.value, cash_amount:cash_amount.value, bank_amount:bank_amount.value, transfer_amount:transfer_amount.value, payment_method_id:payment_method_id.value, tip_amount:tip_amount.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func applyVAT() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.applyVAT(branch_id: branch_id.value, order_id: order_id.value, is_apply_vat:is_include_vat.value))
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
    
    func updateReadyPrinted() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateReadyPrinted(order_id: order_id.value, order_detail_ids: order_detail_ids.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    //MARK: 2- Hủy món | 3- trả bia | 1- món mới
    func requestPrintChefBar() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.requestPrintChefBar(order_id: order_id.value, branch_id: branch_id.value, print_type:print_type.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func getFoodsNeedReview() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getFoodsNeedReview(branch_id:branch_id.value,order_id: order_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
}
