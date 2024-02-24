//
//  DiscountViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 20/01/2023.
//

import UIKit
import RxRelay
import RxSwift

class DiscountViewModel: BaseViewModel {
    private(set) weak var view: DiscountViewController?
    private var router: DiscountRouter?
 
  
    
    // MARK: - Variable -
    // listing data array observe by rxswift
    var discountPercentText = BehaviorRelay<String>(value: "0")
    var discountReasonText = BehaviorRelay<String>(value: "")
    
    var order_id = BehaviorRelay<Int>(value: 0)
    var branch_id = BehaviorRelay<Int>(value: 0)
    var discount_type = BehaviorRelay<Int>(value: 0)
    var discount_percent = BehaviorRelay<Int>(value: 0)
    var note = BehaviorRelay<String>(value: "")

    
    // Khai báo viến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
//    var isValidDiscountReason: Observable<Bool> {
//
//        return self.discountReasonText.asObservable().map {
//            discountReasonText in
//            discountReasonText.count <= 3 && discountReasonText.count >= 50
//        }
//    }
     
    
     
    
    var isValidDiscountReason: Observable<Bool> {
        return self.note.asObservable().map {
            discountReason in
            discountReason.count >= Constants.DISCOUNT_FORM_REQUIRED.requiredDiscountReasonMinLength &&  discountReason.count <= Constants.DISCOUNT_FORM_REQUIRED.requiredDiscountReasonMaxLength
        }
    }
    
    // Khai báo biến để lắng nghe kết quả của cả 3 sự kiện trên
    
    var isValid: Observable<Bool> {
        return isValidDiscountReason
    }
     
    
    func bind(view: DiscountViewController, router: DiscountRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    
}
extension DiscountViewModel{
    func discount() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.discount(order_id:order_id.value, branch_id:branch_id.value, discount_type:discount_type.value, discount_percent:discount_percent.value, note:note.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
