//
//  CreateTableViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class CreateTableViewModel: BaseViewModel {
    private(set) weak var view: CreateTableViewController?
    private var router: CreateTableRouter?
    var branch_id = BehaviorRelay<Int>(value: 0)
    var area_id = BehaviorRelay<Int>(value: 0)
    var status = BehaviorRelay<Int>(value: 0)
  
    var table_name = BehaviorRelay<String>(value: "")
    var total_slot = BehaviorRelay<Int>(value: 0)
    var is_active = BehaviorRelay<Int>(value: 0)
    var table_id = BehaviorRelay<Int>(value: 0)
    
    
    public var table_array : BehaviorRelay<[TableModel]> = BehaviorRelay(value: [])
    public var area_array : BehaviorRelay<[Area]> = BehaviorRelay(value: [])
    public var number_slot : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    
    
    // Khai báo biến để hứng dữ liệu từ VC
     var tableNameText = BehaviorRelay<String>(value: "")
     var numberSlotText = BehaviorRelay<String>(value: "")
    
    var checkTableNameText: Observable<String> {
        return self.tableNameText.asObservable().map { tableNameText in
            tableNameText
        }
    }
    
    // Khai báo viến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
    var isValidName: Observable<Bool> {
        return self.tableNameText.asObservable().map { name in
//            name.count >= 2 &&
//            name.count <= 6
            name.count >= Constants.AREA_TABLE_REQUIRED.requiredAreaTableMinLength &&
            name.count <= Constants.AREA_TABLE_REQUIRED.requiredAreaTableMaxLength

        }
    }
    var isValidNumberSlot: Observable<Bool> {
        return self.numberSlotText.asObservable().map { numberSlot in
            numberSlot.count > 0 &&
            numberSlot.count <= 6
        }
    }
    // Khai báo biến để lắng nghe kết quả của cả 3 sự kiện trên
    
    var isValid: Observable<Bool> {
        return isValidName
//              return Observable.combineLatest(isValidName, isValidNumberSlot) {$0 && $1}
    }
    
    func bind(view: CreateTableViewController, router: CreateTableRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}

extension CreateTableViewModel{
    func getAreas() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.areas(branch_id: branch_id.value, status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func getTables() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.tablesManager(area_id:area_id.value,branch_id:branch_id.value, status:status.value, is_deleted: 0))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func createTable() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.createTable(branch_id: branch_id.value, table_id: table_id.value,
                                                          table_name:table_name.value, area_id:area_id.value, total_slot:total_slot.value, status:status.value, is_active:is_active.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
