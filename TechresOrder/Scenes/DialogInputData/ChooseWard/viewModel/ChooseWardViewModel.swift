//
//  ChooseWardViewModel.swift
//  Techres-Seemt
//
//  Created by Kelvin on 02/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
class ChooseWardViewModel: BaseViewModel {
    private(set) weak var view: ChooseWardViewController?
    private var router: ChooseWardRouter?
    
    public var country_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var city_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var district_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var ward_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    public var dataArray : BehaviorRelay<[Ward]> = BehaviorRelay(value: [])
    public var dataFilter : BehaviorRelay<[Ward]> = BehaviorRelay(value: [])
    
    func bind(view: ChooseWardViewController, router: ChooseWardRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
        
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    
}
//MARK: CALL API
extension ChooseWardViewModel {
    func wards() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.wards(district_id: district_id.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
}
