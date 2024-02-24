//
//  BrandViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class BranchViewModel: BaseViewModel {
    private(set) weak var view: BranchViewController?
    private var router: BranchRouter?
   
    public var key_word : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var status : BehaviorRelay<Int> = BehaviorRelay(value: -1)
    public var brand_id : BehaviorRelay<Int> = BehaviorRelay(value: -1)
    
    // MARK: - Variable -
    // listing data array observe by rxswift
    public var dataArray : BehaviorRelay<[Branch]> = BehaviorRelay(value: [])
    
    
    func bind(view: BranchViewController, router: BranchRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
}
extension BranchViewModel{
    func getBranches() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.branches(brand_id: brand_id.value, status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
