//
//  ChooseCityViewModel.swift
//  Techres-Seemt
//
//  Created by Kelvin on 02/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
class ChooseCityViewModel: BaseViewModel {
    private(set) weak var view: ChooseCityViewController?
    private var router: ChooseCityRouter?
    
    public var country_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var city_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var district_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var ward_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    public var dataArray : BehaviorRelay<[Cities]> = BehaviorRelay(value: [])
    public var dataFilter : BehaviorRelay<[Cities]> = BehaviorRelay(value: [])
    
    func bind(view: ChooseCityViewController, router: ChooseCityRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
        
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    
}
//MARK: CALL API
extension ChooseCityViewModel {
    func cities() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.cities())
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
}
