//
//  UpdateKitchenViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 31/01/2023.
//

import UIKit
import RxRelay
import RxSwift

class UpdateKitchenViewModel: BaseViewModel {
    private(set) weak var view: UpdateKitchenViewController?
    private var router = UpdateKitchenRouter()
    
  
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var kitchen : BehaviorRelay<Kitchen> = BehaviorRelay(value: Kitchen.init()!)
    
    // Khai báo biến để hứng dữ liệu từ VC
    var printerName = BehaviorRelay<String>(value: "")
    var printerIPAddress = BehaviorRelay<String>(value: "")
    var printerPort = BehaviorRelay<String>(value: "")
    
    func bind(view: UpdateKitchenViewController, router: UpdateKitchenRouter){
        self.view = view
        self.router = router
        self.router.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router.navigateToPopViewController()
        
    }
}
// CALL API HERE...
extension UpdateKitchenViewModel{
    func updateKitchen() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateKitchen(branch_id: branch_id.value, kitchen: kitchen.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
