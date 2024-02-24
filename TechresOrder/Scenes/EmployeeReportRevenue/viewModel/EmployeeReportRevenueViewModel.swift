//
//  EmployeeReportRevenueViewModel.swift
//  ORDER
//
//  Created by Kelvin on 13/05/2023.
//

import UIKit
import RxSwift
import RxRelay

class EmployeeReportRevenueViewModel: BaseViewModel{
    
    private(set) weak var view: EmployeeReportRevenueViewController?
    private var router:EmployeeReportRevenueRouter?
  
    public var restaurant_brand_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var report_type : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var date_string : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var from_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var to_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    public var revenues : BehaviorRelay<[RevenueEmployee]> = BehaviorRelay(value: [])

    func bind(view: EmployeeReportRevenueViewController, router: EmployeeReportRevenueRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
}
extension EmployeeReportRevenueViewModel{
    func reportRevenueByEmployee() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.report_revenue_by_all_employee(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: report_type.value, date_string: date_string.value, from_date: from_date.value, to_date: to_date.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
