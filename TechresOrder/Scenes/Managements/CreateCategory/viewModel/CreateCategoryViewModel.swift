//
//  CreateCategoryViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import RxRelay
import RxSwift

class CreateCategoryViewModel: BaseViewModel {
    private(set) weak var view: CreateCategoryViewController?
    private var router: CreateCategoryRouter?
    var branch_id = BehaviorRelay<Int>(value: 0)
    var id = BehaviorRelay<Int>(value: 0)
    var status = BehaviorRelay<Int>(value: 0)
    
    var description = BehaviorRelay<String>(value: "")
    var code = BehaviorRelay<String>(value: "")
    var categoryType = BehaviorRelay<Int>(value: 0)
    
    
    // Khai báo biến để hứng dữ liệu từ VC
     var name = BehaviorRelay<String>(value: "")
    
    // Khai báo viến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
    var isValidName: Observable<Bool> {
        return self.name.asObservable().map { name in
            name.count >= Constants.CATEGORY_FORM_REQUIRED.requiredUserIDMinLength &&
            name.count <= Constants.CATEGORY_FORM_REQUIRED.requiredUserIDMaxLength
        }
    }
    // Khai báo biến để lắng nghe kết quả của cả 3 sự kiện trên
    var isValid: Observable<Bool> {
        return isValidName
    }
    
    
    func bind(view: CreateCategoryViewController, router: CreateCategoryRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    
}
extension CreateCategoryViewModel{
    func createCategory() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.createCategory(name: name.value, code: code.value, description: description.value, categoryType: categoryType.value, status:status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func updateCategory() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateCategory(id:id.value, name: name.value, code: code.value, description: description.value, categoryType: categoryType.value, status:status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
