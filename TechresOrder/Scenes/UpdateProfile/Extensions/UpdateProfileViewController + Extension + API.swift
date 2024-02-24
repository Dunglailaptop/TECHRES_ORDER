//
//  UpdateProfileViewController + Extension + API.swift
//  ORDER
//
//  Created by Pham Khanh Huy on 24/06/2023.
//

import UIKit
import ObjectMapper
import JonAlert
extension UpdateProfileViewController {
    //MARK: CALL API
    func getProfile(){
        viewModel.getProfile().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Profile Success...")
                if let account = Mapper<Account>().map(JSONObject: response.data){
                    dLog(account)
                    self.setProfile(account: account)
                }
            }
        }).disposed(by: rxbag)
    }
    
    func updateProfile(){
        viewModel.updateProfile().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Update Profile Success...")
//                Toast.show(message: "Update Profile Success...", controller: self)
                JonAlert.showSuccess(message: "Cập nhật tài khoản thành công...",duration: 2.0)
                if (imagecover.count > 0){
                    var cloneAccount = ManageCacheObject.getCurrentUser()
                    cloneAccount.avatar = viewModel.avatar.value
                    ManageCacheObject.saveCurrentUser(cloneAccount)
                }
                self.viewModel.makePopViewController()
            }else{
//                Toast.show(message: response.message ?? "Qúa trình kết nối máy chủ gặp sự cố vui lòng thử lại sau.", controller: self)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }

}
