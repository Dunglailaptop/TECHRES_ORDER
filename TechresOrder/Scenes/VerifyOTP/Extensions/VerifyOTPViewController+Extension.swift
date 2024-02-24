//
//  VerifyOTPViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 24/02/2023.
//

import UIKit
import OTPFieldView
import JonAlert
extension VerifyOTPViewController{

}
extension VerifyOTPViewController: OTPFieldViewDelegate {
    

    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        self.viewModel.verify_code.accept(self.OTPCode)
        self.viewModel.restaurantNameText.accept(self.restaurant_name_identify)
        self.viewModel.usernameText.accept(self.username)
        self.verifyOTP()
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
       
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        self.OTPCode = otpString
        
        
        if self.temp == 0{
//            self.viewModel.phone = self.phone
//            self.viewModel.verify_code.accept(otpString)
//            self.sendVerifyOTP()

        }
        else if self.temp >= 5{
//            Toast.show(message: "Bạn đã gửi quá nhiều lần vui lòng Chọn gửi lại OTP", controller: self)
            JonAlert.showError(message: "Bạn đã gửi quá nhiều lần vui lòng Chọn gửi lại OTP", duration: 2.0)
        }
        
        else  {
           
//            viewModel.phone = self.phone
//            viewModel.verify_code.accept(otpString)
//            viewModel.isForgotPassword = self.isForgotPassword
//            self.sendVerifyOTP()
        }

       
      
    }
    
 
}

extension VerifyOTPViewController : verifyOTPDelegate{
    func callback(temp: Int) {
        self.temp = temp
        
   //     self.time_await = self.temp*3
        dLog(self.time_await)
       
//
    }


}


