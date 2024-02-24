//
//  CreatePrinterViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 31/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class CreatePrinterViewModel: BaseViewModel {
    private(set) weak var view: CreatePrinterViewController?
    private var router = CreatePrinterRouter()
    
  
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    // Khai báo biến để hứng dữ liệu từ VC
    var printerName = BehaviorRelay<String>(value: "")
    var printerIPAddress = BehaviorRelay<String>(value: "")
    var printerPort = BehaviorRelay<String>(value: "")
    public var kitchen : BehaviorRelay<Kitchen> = BehaviorRelay(value: Kitchen.init()!)
    func bind(view: CreatePrinterViewController, router: CreatePrinterRouter){
        self.view = view
        self.router = router
        self.router.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router.navigateToPopViewController()
        
    }
}
extension CreatePrinterViewModel{
//    func updatePrinter() -> Observable<APIResponse> {
//        return appServiceProvider.rx.request(.updatePrinter(printer: printer.value))
//               .filterSuccessfulStatusCodes()
//               .mapJSON().asObservable()
//               .showAPIErrorToast()
//               .mapObject(type: APIResponse.self)
//       }
//
    func updateKitchen() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateKitchen(branch_id: branch_id.value, kitchen: kitchen.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
}
