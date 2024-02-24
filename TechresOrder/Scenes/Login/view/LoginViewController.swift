//
//  LoginViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper
import LocalAuthentication
import JonAlert

class LoginViewController: BaseViewController {
//    var window: UIWindow?

     var viewModel = LoginViewModel()

    private var router = LoginRouter()
    
    var iconClick = false

    var sessions_str = ""
    
    
    // MARK: - IBOutlet -
    @IBOutlet weak var text_field_phone: UITextField!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var text_field_password: UITextField!
    @IBOutlet weak var btn_hide_password: UIButton!
    @IBOutlet weak var image_biometric: UIImageView!
    @IBOutlet weak var btn_forgot_password: UIButton!
    
    @IBOutlet weak var btn_faceid: UIButton!
    @IBOutlet weak var text_field_restaurant: UITextField!
    
    @IBOutlet weak var lbl_noti_phone: UILabel!
    
    @IBOutlet weak var lbl_noti_pass: UILabel!
    
    @IBOutlet weak var lbl_noti_restaurant: UILabel!
    
    @IBOutlet weak var view_faceid: UIView!
    
    // MARK: - Variable - User -
    var context = LAContext()
    var err: NSError?
    
    override func viewDidLoad() {

        text_field_restaurant.text = ManageCacheObject.getRestaurantName()
        text_field_phone.text = ManageCacheObject.getUsername()
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        var deviceRequest = DeviceRequest.init()
        deviceRequest?.app_type = Utils.getAppType()
        deviceRequest?.device_uid = Utils.getUDID()
        deviceRequest?.push_token = ManageCacheObject.getPushToken()
        viewModel.deviceRequest.accept(deviceRequest!)

        self.registerDeviceUDID()
        
        text_field_phone.delegate = self
        
        self.hideKeyboardWhenTappedAround()

       

        text_field_phone.rx.controlEvent(.editingChanged).throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
        .withLatestFrom(text_field_phone.rx.text)
        .subscribe(onNext:{ query in
                   self.text_field_phone.text = query!.replacingOccurrences(of: " ", with: "")
            
                    }).disposed(by: rxbag)
        
        //bind value of textfield to variable of viewmodel
        _ = text_field_restaurant.rx.text.map { $0 ?? "" }.bind(to: viewModel.restaurantNameText)
        _ = text_field_phone.rx.text.map { $0!.replacingOccurrences(of: " ", with: "") }.bind(to: viewModel.usernameText)
        _ = text_field_password.rx.text.map { $0 ?? "" }.bind(to: viewModel.passwordText)
        
        
        //  subscribe result of variable isValid in LoginViewModel then handle button login is enable or not?
        _ = viewModel.isValid.subscribe({ [weak self] isValid in
            dLog(isValid)
            guard let strongSelf = self, let isValid = isValid.element else { return }
            strongSelf.btn_login.isEnabled = isValid
            strongSelf.btn_login.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
        })
        
        _ = viewModel.isValidRestaurantName.subscribe({ [weak self] isValid in
            guard let strongSelf = self, let isValid = isValid.element else { return }
            if isValid{
                strongSelf.lbl_noti_restaurant.isHidden = true
                
            }else{
                if(self!.text_field_restaurant.text!.count > 0){
                    strongSelf.lbl_noti_restaurant.isHidden = false
                    strongSelf.text_field_restaurant.text = String(strongSelf.text_field_restaurant.text!.prefix(Constants.LOGIN_FORM_REQUIRED.requiredRestaurantMaxLength))
                }
                
            }

        })
        
        
        _ = viewModel.isValidUsername.subscribe({ [weak self] isValid in
            guard let strongSelf = self, let isValid = isValid.element else { return }
            
            if isValid{
//                self!.phone_password.constant = 10
                strongSelf.lbl_noti_phone.isHidden = true
                
            }else{
//                self!.phone_password.constant = 30
                if(self!.text_field_phone.text!.count > 0){
                    strongSelf.lbl_noti_phone.isHidden = false
                    strongSelf.text_field_phone.text = String(strongSelf.text_field_phone.text!.prefix(Constants.LOGIN_FORM_REQUIRED.requiredUserIDMaxLength))
                    strongSelf.lbl_noti_phone.text = "* Mã nhân viên từ 8 đến 10 ký tự"
                }
                
            }
          

        })
        
        _ = viewModel.isValidPassword.subscribe({ [weak self] isValid in
            guard let strongSelf = self, let isValid = isValid.element else { return }
            if isValid{
                strongSelf.lbl_noti_pass.isHidden = true
            }else{
                if(self!.text_field_phone.text!.count > 0){
                    strongSelf.lbl_noti_pass.isHidden = false
                    strongSelf.text_field_password.text = String(strongSelf.text_field_password.text!.prefix(Constants.LOGIN_FORM_REQUIRED.requiredPasswordLengthMax))
                }
                
            }

        })
        
        text_field_password.delegate = self
        
        

        lbl_noti_pass.isHidden = true
        lbl_noti_phone.isHidden = true
        
       
        // set layout
        checkBiometricFunctionality()
    }
    
    private func checkBiometricFunctionality(){
        self.iconClick = false
        view_faceid.isHidden = true
        
        if ManageCacheObject.getBiometric() == "1"{
            if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){

                if context.biometryType == .faceID{
                    if #available(iOS 13.0, *) {
                        view_faceid.isHidden = false
                        image_biometric.image = UIImage(named: "icon-face-id")
                    } else {
                        // Fallback on earlier versions
                    }
                }else{
                    if #available(iOS 13.0, *) {
                        image_biometric.image = UIImage(systemName: "touchid")
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }else{
//                UIAlertController.showAlert(title: nil, message: "Vân tay/Face ID chưa thiết lập")
            }
        }
    }
    
   

    @IBAction func actionLogin(_ sender: Any) {
        // call api login here...
        self.viewModel.isLoginFace.accept(false)
        self.getSessions()
    }
    @IBAction func actionForgotPassword(_ sender: Any) {
        viewModel.makeResetPasswordViewController()
    }
    
    @IBAction func actionLoginBiometric(_ sender: Any) {
        
        let localString =  "Biometric Authentication"
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){
            if ManageCacheObject.getUsername() == "" || ManageCacheObject.getPassword() == "" {
                let alert = UIAlertController(title: "THÔNG BÁO" , message: "Tính năng chỉ có thể sử dụng lần đăng nhập kế tiếp", preferredStyle:.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString){ [self]
                    (success, error) in
                    if success{
                        DispatchQueue.main.async {
                            self.viewModel.isLoginFace.accept(true)
                            getSessions()
                        }
                    }
                }
            }

        }
    }
    
    
    @IBAction func actionShowPassword(_ sender: Any) {
        text_field_password.becomeFirstResponder()
        
        if(iconClick == true) {
            text_field_password.isSecureTextEntry = false
            btn_hide_password.setImage(UIImage(named: "eye"), for: .normal)
        } else {
            btn_hide_password.setImage(UIImage(named: "icon_eye_pass"), for: .normal)
            text_field_password.isSecureTextEntry = true
        }
       
        iconClick = !iconClick
    }
    
    @IBAction func actionRegisterAccount(_ sender: Any) {
          presentDialogRegisterAccountViewController()
    }
    

}
extension LoginViewController: UITextFieldDelegate{

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if Utils.isCheckCharacterVN(string: string) && (textField == text_field_password ) {
            return false
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == text_field_password {
            return false; //do not show keyboard nor cursor
        }
        return true
    }
    
    
}

