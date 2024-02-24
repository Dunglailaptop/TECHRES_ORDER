//
//  OrderManagementViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 25/01/2023.
//

import UIKit
import RxRelay
import RxSwift

class OrderManagementViewModel: BaseViewModel {
    private(set) weak var view: OrderManagementViewController?
    private var router: OrderManagementRouter?
    
    // MARK: - Variable -
    // listing data array observe by rxswift
    public var dataArray : BehaviorRelay<[Order]> = BehaviorRelay(value: [])
    public var allOrders : BehaviorRelay<[Order]> = BehaviorRelay(value: [])
    
    public var id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var report_type : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var time : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var limit : BehaviorRelay<Int> = BehaviorRelay(value: 50)
    public var page : BehaviorRelay<Int> = BehaviorRelay(value: 1)
    
    public var order_id : BehaviorRelay<Int> = BehaviorRelay(value: 1)
    public var table_name : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var key_search : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var isGetFullData : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    func bind(view: OrderManagementViewController, router: OrderManagementRouter){
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
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
extension OrderManagementViewModel {
    func orders() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.ordersHistory(id: id.value, report_type: report_type.value, time: time.value, limit: limit.value, page: page.value, key_search: key_search.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
                                             
       }
    
    
}
