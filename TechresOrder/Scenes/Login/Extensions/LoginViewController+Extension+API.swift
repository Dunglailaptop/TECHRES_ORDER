//
//  LoginViewController+Extension+API.swift
//  ORDER
//
//  Created by Pham Khanh Huy on 04/07/2023.
//

import UIKit
import JonAlert
import ObjectMapper
extension LoginViewController{

    func registerDeviceUDID(){
        // Get data from Server
        viewModel.registerDeviceUDID().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Register Device UDID Success...")
            }
         
        }).disposed(by: rxbag)
    }
    
    func getConfig(){
        if viewModel.isLoginFace.value{
            viewModel.restaurantNameText.accept(ManageCacheObject.getRestaurantName())
            viewModel.usernameText.accept(ManageCacheObject.getUsername())
            viewModel.passwordText.accept(ManageCacheObject.getPassword())
        }
        viewModel.getConfig().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let config  = Mapper<Config>().map(JSONObject: response.data){
                    var obj_config = config
                    let basic_token = String(format: "%@:%@", self.sessions_str, obj_config.api_key)
                    obj_config.api_key = basic_token
                    ManageCacheObject.setConfig(obj_config)
                    
                    // call api login here...
                    self.login()
                }
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", duration: 2.0)
//                Toast.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", controller: self)
                dLog(response.message ?? "")
            }
          
          
        }).disposed(by: rxbag)
        
    }
    
    
    func login(){
        // Get data from Server
        viewModel.login().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Login Success...")
                if let account  = Mapper<Account>().map(JSONObject: response.data){
                    if(!Utils.checkRoleOrderFood(permission: account.permissions)){
                        JonAlert.showError(message: "Bạn chưa có quyền gọi món. Vui lòng liên hệ quản lý để được cấp quyền.", duration: 3.0)
                        return
                    }
                    dLog(account.toJSON())
                    ManageCacheObject.saveCurrentUser(account)
                    ManageCacheObject.setAccessToken(account.access_token)
                    ManageCacheObject.setUsername(account.username)
                    ManageCacheObject.setPassword(self.text_field_password.text!)
                    ManageCacheObject.setRestaurantName(account.restaurant_name)
                    
                    
                    
                   
                    
                    self.viewModel.branch_id.accept(account.branch_id)
                    
                    var brand =  Brand.init()
                    brand.id =  account.restaurant_brand_id
                    brand.name = account.brand_name
                    
                    var branch = Branch.init()
                    branch.id = account.branch_id
                    branch.address = account.branch_address
                    branch.name = account.branch_name
                    branch.phone = account.phone_number
                    
                    ManageCacheObject.saveCurrentBranch(branch)
                    ManageCacheObject.saveCurrentBrand(brand)
                    
                    JonAlert.showSuccess(message: "Đăng nhập thành công...", duration: 2.0)
                    self.getSetting()
                    
                }

            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", duration: 2.0)
//                Toast.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", controller: self)
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
//    func loginBiometrict(){
//        viewModel.login().subscribe(onNext: { (response) in
//            if(response.code == RRHTTPStatusCode.ok.rawValue){
//                if let account  = Mapper<Account>().map(JSONObject: response.data){
//                    ManageCacheObject.saveCurrentUser(account)
//                    ManageCacheObject.setAccessToken(account.access_token)
//                    self.viewModel.branch_id.accept(account.branch_id)
//
//                    var brand =  Brand.init()
//                    brand.name = account.brand_name
//                    brand.id =  account.restaurant_brand_id
//
//                    var branch = Branch.init()
//
//                    branch.id = account.branch_id
//                    branch.name = account.branch_name
//                    ManageCacheObject.saveCurrentBranch(branch)
//                    ManageCacheObject.saveCurrentBrand(brand)
//                    self.getSetting()
//
//                }
//            }else{
//                Toast.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", controller: self)
//
//            }
//        }).disposed(by: rxbag)
//    }
//
    
    func getSetting(){
        viewModel.getSetting().subscribe(onNext: { (settingResponse) in
            dLog(settingResponse.toJSON())
            guard let setting = settingResponse.setting else {
                     return
                 }
            dLog(setting)
           
          
           
            
            
            
            if(setting.branch_type == BRANCH_TYPE_LEVEL_ONE){
                ManageCacheObject.setSetting(setting)
                // call api sync data
                self.syncData()
                
                self.loadMainView()
            }else{
                // call api sync data
                self.syncData()
                
                self.fetBranches()
            }
                
//            ManageCacheObject.setSetting(setting)
            // call  load main view  here...
            
            
//            NotificationCenter.default.post(Notification(name: .refreshAllTabs))
        }).disposed(by: rxbag)
        
    }
    func getSettingBranchOrder(){
        viewModel.getSetting().subscribe(onNext: { (settingResponse) in
            dLog(settingResponse.toJSON())
            guard let setting = settingResponse.setting else {
                     return
                 }
            dLog(setting)
            ManageCacheObject.setSetting(setting)
            // call  load main view  here...
            
            self.loadMainView()
//            NotificationCenter.default.post(Notification(name: .refreshAllTabs))
        }).disposed(by: rxbag)
        
    }
    private func fetBranches(){
        viewModel.status.accept(ACTIVE)
//        viewModel.key_word.accept("")
        
        viewModel.getBranches().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let branches = Mapper<Branch>().mapArray(JSONObject: response.data) {
                    if(branches.count > 0){
                        let branches_filter = branches.filter({$0.is_office == DEACTIVE})// Loại trừ chi nhánh văn phòng ra khỏi mảng
                        ManageCacheObject.saveCurrentBranch(branches_filter[0])
                        
                        self.viewModel.branch_id.accept(branches_filter[0].id)
                        self.getSettingBranchOrder()
                    }
                }
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    
}

