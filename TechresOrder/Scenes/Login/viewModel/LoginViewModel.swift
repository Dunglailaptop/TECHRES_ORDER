//
//  LoginViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class LoginViewModel : BaseViewModel{

    private(set) weak var view: LoginViewController?
    private var router: LoginRouter?
//    private let disposeBag = DisposeBag()
    
   // Khai báo biến để hứng dữ liệu từ VC
    var usernameText = BehaviorRelay<String>(value: "")
    var passwordText = BehaviorRelay<String>(value: "")
    var restaurantNameText = BehaviorRelay<String>(value: "")
    public var status : BehaviorRelay<Int> = BehaviorRelay(value: 0)

    var deviceRequest = BehaviorRelay<DeviceRequest>(value: DeviceRequest.init()!)
    
    
    var isLoginFace = BehaviorRelay<Bool>(value: false)
    
    var phone = ""
    var pass = ""
    var restaurant_name = ""
    
    
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
//    public var area_id : BehaviorRelay<Int> = BehaviorRelay(value: -1)
//    public var key_word : BehaviorRelay<String> = BehaviorRelay(value: "")
//    public var category_id : BehaviorRelay<Int> = BehaviorRelay(value: -1)
//    public var category_type : BehaviorRelay<Int> = BehaviorRelay(value: -1)
//    public var is_allow_employee_gift : BehaviorRelay<Int> = BehaviorRelay(value: -1)
//    public var is_sell_by_weight : BehaviorRelay<Int> = BehaviorRelay(value: 0)
//    public var is_out_stock : BehaviorRelay<Int> = BehaviorRelay(value: -1)
//    public var is_use_point : BehaviorRelay<Int> = BehaviorRelay(value: 0)
           
   // Khai báo viến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
   var isValidUsername: Observable<Bool> {
       return self.usernameText.asObservable().map { username in
           username.count >= Constants.LOGIN_FORM_REQUIRED.requiredUserIDMinLength &&
           username.count <= Constants.LOGIN_FORM_REQUIRED.requiredUserIDMaxLength
       }
   }
    
   
    
   
   var isValidPassword: Observable<Bool> {
       return self.passwordText.asObservable().map {
           password in
           password.count <= Constants.UPDATE_INFO_FORM_REQUIRED.requiredPasswordMax &&  password.count >= Constants.UPDATE_INFO_FORM_REQUIRED.requiredPasswordMin
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
       return Observable.combineLatest(isValidUsername, isValidPassword, isValidRestaurantName) {$0 && $1 && $2}
     
//       return Observable.combineLatest(isValidUsername, isValidPassword) {$0 && $1}

   }
    
   
    
    func bind(view: LoginViewController, router: LoginRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makeResetPasswordViewController(){
        router?.navigateToResetPasswordViewController()
    }
    
}
extension LoginViewModel{
    // get data from server by rxswift with alamofire
    func getSessions() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.sessions)
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    func registerDeviceUDID() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.regisDevice(deviceRequest: deviceRequest.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
       }
    
    func getConfig() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.config(restaurant_name: restaurantNameText.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func login() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.login(username: usernameText.value, password: passwordText.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
    
 
    
    
    func getSetting() -> Observable<SettingResponse> {
        return appServiceProvider.rx.request(.setting(branch_id: branch_id.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: SettingResponse.self)
       }
    
    func getBranches() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.branches(brand_id: branch_id.value, status: status.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
    
//    func foods() -> Observable<APIResponse> {
//        return appServiceProvider.rx.request(.foods(
//            branch_id: branch_id.value,
//            area_id: self.area_id.value,
//            category_id: self.category_id.value,
//            category_type: self.category_type.value,
//            is_allow_employee_gift: self.is_allow_employee_gift.value,
//            is_sell_by_weight: self.is_sell_by_weight.value,
//            is_out_stock: self.is_out_stock.value, key_word: self.key_word.value))
//               .filterSuccessfulStatusCodes()
//               .mapJSON().asObservable()
//               .showAPIErrorToast()
//               .mapObject(type: APIResponse.self)
//       }
    
}
