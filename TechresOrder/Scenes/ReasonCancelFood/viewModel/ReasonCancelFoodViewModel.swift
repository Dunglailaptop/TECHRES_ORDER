//
//  ReasonCancelFoodViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import RxRelay
class ReasonCancelFoodViewModel: BaseViewModel {
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var dataArray : BehaviorRelay<[ReasonCancel]> = BehaviorRelay(value: [])
    
    private(set) weak var view: ReasonCancelFoodViewController?
    private var router: ReasonCancelFoodRouter?
    
    
    func bind(view: ReasonCancelFoodViewController, router: ReasonCancelFoodRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
}
extension ReasonCancelFoodViewModel{
    func reasonCancelFoods() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.reasonCancelFoods(branch_id: branch_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
