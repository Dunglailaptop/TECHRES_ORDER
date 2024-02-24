//
//  FeeManagerViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class FeeManagerViewModel: BaseViewModel {
    private(set) weak var view: FeeManagerViewController?
    private var router: FeeManagerRouter?
   
    var status = BehaviorRelay<Int>(value: 0)
    
    var type = BehaviorRelay<Int>(value: 1)
    var amount = BehaviorRelay<Int>(value: 0)
    var note = BehaviorRelay<String>(value: "")
    
    var date = BehaviorRelay<String>(value: "")
    var paymentMethodEnum = BehaviorRelay<String>(value: "")
    var branch_id = BehaviorRelay<Int>(value: -1)
    var addition_fee_reason_type_id = BehaviorRelay<Int>(value: 8)
    var other_fees = BehaviorRelay<[Fee]>(value: [])

    
    // Khai báo biến để hứng dữ liệu từ VC
    var noteText = BehaviorRelay<String>(value: "")
    var titleText = BehaviorRelay<String>(value: "")
    var dateText = BehaviorRelay<String>(value: "")
    var amountText = BehaviorRelay<String>(value: "")
    // Khai báo viến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
    var isValidTitle: Observable<Bool> {
        return self.titleText.asObservable().map { title in
            title.count >= Constants.ADDITION_FEE_FORM_REQUIRED.requiredNameLength &&
            title.count <= Constants.ADDITION_FEE_FORM_REQUIRED.requiredNameLengthMax
        }
    }
    
    var isValidNote: Observable<Bool> {
        return self.noteText.asObservable().map { note in
            note.count >= Constants.ADDITION_FEE_FORM_REQUIRED.requiredNoteMinLength &&
            note.count <= Constants.ADDITION_FEE_FORM_REQUIRED.requiredNoteMaxLength
        }
    }
    // Khai báo viến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
    var isValidDate: Observable<Bool> {
        return self.dateText.asObservable().map { date in
            date.count >= Constants.ADDITION_FEE_FORM_REQUIRED.requiredDateMinLength &&
            date.count <= Constants.ADDITION_FEE_FORM_REQUIRED.requiredDateMaxLength
        }
    }
    
    // Khai báo biến để lắng nghe kết quả của cả 3 sự kiện trên
    var isValid: Observable<Bool> {
        return Observable.combineLatest(isValidNote, isValidDate, isValidTitle) {$0 && $1 && $2}
    }
    
    
    func bind(view: FeeManagerViewController, router: FeeManagerRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}

// CALL API HERE...
extension FeeManagerViewModel{
    func createFee() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.createFee(branch_id: branch_id.value, type: type.value, amount: amount.value, title:titleText.value, note: noteText.value, date: dateText.value, addition_fee_reason_type_id:addition_fee_reason_type_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
