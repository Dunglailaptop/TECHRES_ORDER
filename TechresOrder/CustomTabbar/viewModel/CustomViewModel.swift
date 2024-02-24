//
//  CustomViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class CustomViewModel: BaseViewModel {
    private(set) weak var view: ViewController?
    private var router: CustomViewRouter?
    
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
      public var emplpoyee_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
      public var order_session_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    func bind(view: ViewController, router: CustomViewRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func makeLoginViewController(){
        router?.navigateToLoginViewController()
    }
    
}
extension CustomViewModel{
//    func openSession() -> Observable<APIResponse> {
//        return appServiceProvider.rx.request(.openSession(
//            before_cash: before_cash.value, branch_working_session_id:branch_working_session_id.value))
//               .filterSuccessfulStatusCodes()
//               .mapJSON().asObservable()
//               .showAPIErrorToast()
//               .mapObject(type: APIResponse.self)
//       }
    
    func workingSessions() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.workingSessions(
            branch_id: branch_id.value, empaloyee_id:emplpoyee_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func checkWorkingSessions() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.checkWorkingSessions)
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func assignWorkingSessions() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.assignWorkingSession(branch_id: branch_id.value, order_session_id: order_session_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
