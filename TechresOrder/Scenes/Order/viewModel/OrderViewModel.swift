//
//  OrderViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit
import RxSwift
import RxRelay
class OrderViewModel:BaseViewModel{
    private(set) weak var view: OrderViewController?
    private var router: OrderRouter?
//    private let disposeBag = DisposeBag()
    
    // MARK: - Variable -
    // listing data array observe by rxswift
    public var dataArray : BehaviorRelay<[Order]> = BehaviorRelay(value: [])
    public var allOrders : BehaviorRelay<[Order]> = BehaviorRelay(value: [])
    
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var key_word : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var order_status : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var order_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var table_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var employee_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var table_name = BehaviorRelay<String>(value: "")
    public var qrcode = BehaviorRelay<String>(value: "")
    var is_gift = BehaviorRelay<Int>(value: 0)
    var customer_id  = BehaviorRelay<Int>(value: 0)
    var customer_slot_number = BehaviorRelay<Int>(value: 0)
    public var page : BehaviorRelay<Int> = BehaviorRelay(value: 1)
//    public var customer_name = BehaviorRelay<String>(value: "")
//    public var customer_phone = BehaviorRelay<String>(value: "")
//    public var customer_address = BehaviorRelay<String>(value: "")
    
    func bind(view: OrderViewController, router: OrderRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makeOrderDetailViewController(){
        router?.navigateToOrderDetailViewController(order_id: order_id.value, table_name:table_name.value)
    }
    
    
    func makePayMentViewController(){
        router?.navigateToPayMentViewController(order_id: order_id.value)
    }
    func makeScanBillViewController(){
        router?.navigateToQRCodeCashbackViewController(order_id: order_id.value, table_name: table_name.value)
    }
   
    func makeNavigatorAddFoodViewController(){
        router?.navigateToAddFoodViewController(is_gift:self.is_gift.value, order_id: self.order_id.value, table_name: table_name.value)
    }
    func makeChooseEmployeeSharePointViewController(){
        router?.navigateToEmployeeSharePointViewController(order_id: order_id.value, table_name: table_name.value)
    }
    func makeGiftDetailViewController(){
        router?.navigateToGiftDetailViewController(qrcode:qrcode.value, order_id: order_id.value)
    }
 
}
extension OrderViewModel{
    
    func updateCustomerNumberSlot() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateCustomerNumberSlot( branch_id: branch_id.value, order_id: order_id.value, customer_slot_number:customer_slot_number.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    
    func getOrders() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.orders(userId: employee_id.value, order_status: order_status.value, key_word:self.key_word.value, branch_id:self.branch_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func assignCustomerToBill() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.assignCustomerToBill(order_id: order_id.value, qr_code: qrcode.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func closeTable() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.closeTable(table_id: table_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func checkVersion() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.checkVersion)
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
}
