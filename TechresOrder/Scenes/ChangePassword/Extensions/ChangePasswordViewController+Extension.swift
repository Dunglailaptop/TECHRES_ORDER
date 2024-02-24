//
//  ChangePasswordViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 12/02/2023.
//

import UIKit
import JonAlert
extension ChangePasswordViewController {
    
    func changePassword(){
        viewModel.changePassword().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Update Info Profile Success...")
//                Toast.show(message: "Thay đổi mật khẩu thành công...", controller: self)
                JonAlert.showSuccess(message: "Thay đổi mật khẩu thành công...", duration: 2.0)
                self.logout()
            }else{
//                Toast.show(message: response.message ?? "Qúa trình kết nối máy chủ gặp sự cố vui lòng thử lại sau.", controller: self)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
        
    }
}
