//
//  UtilitiesViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit
import RxRelay
import RxSwift

class UtilitiesViewModel: BaseViewModel{

    private(set) weak var view: UtilitiesViewController?
    private var router: UtilitiesRouter?
   
    public var dataSectionArray : BehaviorRelay<[Int]> = BehaviorRelay(value: [])
    public var branch : BehaviorRelay<Branch> = BehaviorRelay(value: Branch.init())
    public var account : BehaviorRelay<Account> = BehaviorRelay(value: Account.init())
    
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var brand_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)

    public var employee_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    func bind(view: UtilitiesViewController, router: UtilitiesRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    func makeSettingAccountViewController(){
        router?.navigateToSettingAccountViewController()
    }
    func makeManagementAreaTableViewController(){
        router?.navigateToManagementAreaTableViewController()
    }
    func makeManagementCategoryFoodNoteViewController(){
        router?.navigateToManagementCategoryFoodNoteViewController()
    }
    
    func makeSettingPrinterViewController(){
        router?.navigateToSettingPrinterViewController()
    }
    func makeOrderManagementViewController(){
        router?.navigateToOrderManagementViewController()
    }
    
    func makeMemberRegisterViewController(){
        router?.navigateToMemberRegisterViewController()
    }
  
    func makeToRevenueDetailViewController(report_type:Int){
        router?.navigateToRevenueDetailViewController(report_type:report_type)
    }
    func makeToReportBusinessAnalyticsViewController(){
        router?.navigateToReportBusinessAnalyticsViewController()
    }
    func makeToReportBusinessViewController(){
        router?.navigateToReportBusinessViewController()
    }
    func makeToEmployeeReportRevenueViewController(){
        router?.navigateToEmployeeReportRevenueViewController()
        
    }
    func makeToUpdateBranchViewController() {
        router?.navigationToUpdateBranchViewController()
    }
}
extension UtilitiesViewModel{
    func getProfile() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.profile(branch_id: branch_id.value, employee_id: employee_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
  
}
