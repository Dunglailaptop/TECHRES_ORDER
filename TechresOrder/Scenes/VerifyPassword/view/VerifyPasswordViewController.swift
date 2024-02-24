//
//  VerifyPasswordViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 30/01/2023.
//

import UIKit
import JonAlert
class VerifyPasswordViewController: BaseViewController {
    var viewModel = VerifyPasswordViewModel()
    var router = VerifyPasswordRouter()
    
    @IBOutlet weak var text_field_password: UITextField!
    
    @IBOutlet weak var lbl_new_pass: UILabel!
    @IBOutlet weak var text_field_confirm_password: UITextField!
    @IBOutlet weak var lbl_confirm_pass: UILabel!
    
    @IBOutlet weak var btnUpdatePassword: UIButton!
    
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var btnConfirmShowPassword: UIButton!
    
    var username = ""
    var otp_code = ""
    
    var iconPassClick = false
    var iconConfirmPassClick = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        viewModel.otp_code.accept(otp_code)
        viewModel.usernameText.accept(username)
        
        //bind value of textfield to variable of viewmodel
        _ = text_field_password.rx.text.map { $0 ?? "" }.bind(to: viewModel.new_password)
        _ = text_field_confirm_password.rx.text.map { $0 ?? "" }.bind(to: viewModel.confirm_new_password)
        
        
        //  subscribe result of variable isValid in LoginViewModel then handle button login is enable or not?
        _ = viewModel.isValid.subscribe({ [weak self] isValid in
            dLog(isValid)
            guard let strongSelf = self, let isValid = isValid.element else { return }
            strongSelf.btnUpdatePassword.isEnabled = isValid
            strongSelf.btnUpdatePassword.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
            
        })
        
        
        _ = viewModel.isValidNewPassword.subscribe({ [weak self] isValid in
            guard let strongSelf = self, let isValid = isValid.element else { return }
            if isValid{
                strongSelf.lbl_new_pass.isHidden = true
            }else{
                strongSelf.lbl_new_pass.isHidden = false
            }

        })
        
        
        _ = viewModel.isValidConfirmPassword.subscribe({ [weak self] isValid in
            guard let strongSelf = self, let isValid = isValid.element else { return }
            
            if isValid{
                strongSelf.lbl_confirm_pass.isHidden = true
                
            }else{
                strongSelf.lbl_confirm_pass.isHidden = false
            }
          

        })
        
      
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @IBAction func actionUpdatePassword(_ sender: Any) {
        if(text_field_password.text == text_field_confirm_password.text){
            self.verifyPassword()
        }else{
//            Toast.show(message: "Xác nhận mật khẩu không đúng", controller: self)
            JonAlert.showError(message: "Xác nhận mật khẩu không đúng", duration: 2.0)
        }
        
    }
    
    @IBAction func actionBackToLogin(_ sender: Any) {
        self.logout()
    }
    @IBAction func btnShowConfirmPass(_ sender: Any) {
        if(iconConfirmPassClick == true) {
            text_field_confirm_password.isSecureTextEntry = false
            btnConfirmShowPassword.setImage(UIImage(named: "eye"), for: .normal)
        } else {
            btnConfirmShowPassword.setImage(UIImage(named: "icon_eye_pass"), for: .normal)
            text_field_confirm_password.isSecureTextEntry = true
        }
       
        iconConfirmPassClick = !iconConfirmPassClick
    }
    
    @IBAction func btnShowPass(_ sender: Any) {
        
        if(iconPassClick == true) {
            text_field_password.isSecureTextEntry = false
            btnShowPassword.setImage(UIImage(named: "eye"), for: .normal)
        } else {
            btnShowPassword.setImage(UIImage(named: "icon_eye_pass"), for: .normal)
            text_field_password.isSecureTextEntry = true
        }
       
        iconPassClick = !iconPassClick
        
    }
}
extension VerifyPasswordViewController{
    func verifyPassword(){
            viewModel.verifyPassword().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                   // Verify password Success.
                    self.logout()
                }else{
                    dLog(response.message ?? "")
//                    Toast.show(message: response.message ?? "Có lỗi trong quá trình thêm món", controller: self)
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                }
             
            }).disposed(by: rxbag)
        }
}
