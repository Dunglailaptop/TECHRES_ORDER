//
//  ReportRevenueEmployeeViewModel.swift
//  Techres-Seemt
//
//   Created by Huynh Quang Huy on 11/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift

class ReportRevenueEmployeeViewModel: BaseViewModel {
    
    private(set) weak var view: ReportRevenueEmployeeViewController?
    private var router: ReportRevenueEmployeeRouter?
    
    public var report = BehaviorRelay<EmployeeRevenueReport>(value: EmployeeRevenueReport.init(reportType: REPORT_TYPE_THIS_MONTH, dateString: Utils.getCurrentDateTime().thisMonth))
    public var restaurant_brand_id : BehaviorRelay<Int> = BehaviorRelay(value: ManageCacheObject.getCurrentUser().restaurant_brand_id)
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: ManageCacheObject.getCurrentUser().branch_id)
    public var from_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var to_date : BehaviorRelay<String> = BehaviorRelay(value: "")
    

  
    
    func bind(view: ReportRevenueEmployeeViewController, router: ReportRevenueEmployeeRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    
    
}

extension ReportRevenueEmployeeViewModel {
    func getReportEmployee() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getRenueByEmployeeReport(restaurant_brand_id: restaurant_brand_id.value, branch_id: branch_id.value, report_type: report.value.reportType, date_string: report.value.dateString, from_date: from_date.value, to_date: to_date.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
}