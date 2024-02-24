//
//  SettingPrinterViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 26/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class SettingPrinterViewModel: BaseViewModel {
    private(set) weak var view: SettingPrinterViewController?
    private var router:SettingPrinterRouter?
    public var dataSectionArray : BehaviorRelay<[Int]> = BehaviorRelay(value: [])
    
    public var printersBill : BehaviorRelay<[Kitchen]> = BehaviorRelay(value: [])
    public var printersChefBar : BehaviorRelay<[Kitchen]> = BehaviorRelay(value: [])
    
    var printer_bill_height = BehaviorRelay<Int>(value: 0)
    var printer_chef_bar_height = BehaviorRelay<Int>(value: 0)
    var kitchen = BehaviorRelay<Kitchen>(value: Kitchen.init()!)
    var printer = BehaviorRelay<Kitchen>(value: Kitchen.init()!)
    
    var branch_id = BehaviorRelay<Int>(value: 0)
    var status = BehaviorRelay<Int>(value: 1)
    var is_have_printer = BehaviorRelay<Int>(value: 1)
    
    var isBillPrinterOn =  BehaviorRelay<Bool>(value: true)
    
    func bind(view: SettingPrinterViewController, router: SettingPrinterRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    func makeCreatePrinterViewController(){
        router?.navigateToCreatePrinterViewController()
    }
    
    func makeUpdatePrinterViewController(){
        router?.navigateToUpdatePrinterViewController(printer: printer.value)
    }
    
    func makeUpdateKitchenViewController(){
        router?.navigateToUpdateKitchenViewController(kitchen: kitchen.value)
    }
    
    
    
}
extension SettingPrinterViewModel{
//    func printers(is_print_bill:Int = 0) -> Observable<APIResponse> {
//        return appServiceProvider.rx.request(.prints(branch_id: branch_id.value, is_have_printer: is_have_printer.value, is_print_bill: is_print_bill, status: status.value))
//               .filterSuccessfulStatusCodes()
//               .mapJSON().asObservable()
//               .showAPIErrorToast()
//               .mapObject(type: APIResponse.self)
//       }
    
    func updateKitchen() -> Observable<APIResponse> {
           return appServiceProvider.rx.request(.updateKitchen(branch_id: branch_id.value, kitchen: (printersBill.value.first ?? Kitchen())!))
                  .filterSuccessfulStatusCodes()
                  .mapJSON().asObservable()
                  .showAPIErrorToast()
                  .mapObject(type: APIResponse.self)
       }
    
    func kitchens() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.kitchens(branch_id: branch_id.value, status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
