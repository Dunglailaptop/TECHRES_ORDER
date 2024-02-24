//
//  CreateAreaViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import RxRelay
import RxSwift

class CreateAreaViewModel: BaseViewModel {
    private(set) weak var view: CreateAreaViewController?
    private var router: CreateAreaRouter?
    
    public var areaRequest : BehaviorRelay<AreaRequest> = BehaviorRelay(value: AreaRequest.init())
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var status : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    // Khai báo biến để hứng dữ liệu từ VC
     var areaNameText = BehaviorRelay<String>(value: "")
    
    // Khai báo viến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
    var isValidName: Observable<Bool> {
        return self.areaNameText.asObservable().map { name in
            name.count >= Constants.AREA_FORM_REQUIRED.requiredAreaNameMinLength &&
            name.count <= Constants.AREA_FORM_REQUIRED.requiredAreaNameMaxLength
        }
    }
    // Khai báo biến để lắng nghe kết quả của cả 3 sự kiện trên
    
    var isValid: Observable<Bool> {
        return isValidName
      

    }
     //chặn khoảng trắng đầu input
    var checkAreaNameText: Observable<String> {
        return self.areaNameText.asObservable().map { areaNameText in
            areaNameText
        }
    }
     
    
    func bind(view: CreateAreaViewController, router: CreateAreaRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
}
// MARK: CALL API HERE...
extension CreateAreaViewModel{
    func createArea() -> Observable<APIResponse> {
        
        return appServiceProvider.rx.request(.createArea(branch_id: branch_id.value, areaRequest: areaRequest.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
