//
//  VerifyOTPViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 24/02/2023.
//

import UIKit
import RxSwift
import RxRelay

class VerifyOTPViewModel: BaseViewModel {
    private(set) weak var view: VerifyOTPViewController?
    private var router: VerifyOTPRouter?
    
   // Khai báo biến để hứng dữ liệu từ VC
    var usernameText = BehaviorRelay<String>(value: "")
    var restaurantNameText = BehaviorRelay<String>(value: "")
    var verify_code = BehaviorRelay<String>(value: "")
           
   // Khai báo viến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
   var isValidUsername: Observable<Bool> {
       return self.usernameText.asObservable().map { username in
           username.count >= Constants.LOGIN_FORM_REQUIRED.requiredUserIDMinLength &&
           username.count <= Constants.LOGIN_FORM_REQUIRED.requiredUserIDMaxLength
       }
   }
    

    var isValidRestaurantName: Observable<Bool> {
        return    self.restaurantNameText.asObservable().map { restaurant_name in
            restaurant_name.count >= Constants.LOGIN_FORM_REQUIRED.requiredRestaurantMinLength &&
            restaurant_name.count <= Constants.LOGIN_FORM_REQUIRED.requiredRestaurantMaxLength
        }
    }
    
   
   // Khai báo biến để lắng nghe kết quả của cả 3 sự kiện trên
   
   var isValid: Observable<Bool> {
       return Observable.combineLatest(isValidUsername,  isValidRestaurantName) {$0 && $1}
   }
    
   
    
    func bind(view: VerifyOTPViewController, router: VerifyOTPRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    func makeVerifyPasswordViewController(){
        router?.navigateToVerifyPasswordViewController(username: usernameText.value, otp_code: verify_code.value)
    }
    
}
extension VerifyOTPViewModel{
    func verifyOTP() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.verifyOTP(restaurant_name: restaurantNameText.value, username: usernameText.value, verify_code: verify_code.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
