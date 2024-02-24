//
//  LoginViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 26/01/2023.
//

import UIKit
import JonAlert
extension LoginViewController {

    
    func presentModalOpenWorkingSessionViewController() {
        let openWorkingSessionViewController = OpenWorkingSessionViewController()

        openWorkingSessionViewController.view.backgroundColor = ColorUtils.blackTransparent()
       
            let nav = UINavigationController(rootViewController: openWorkingSessionViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
           
            present(nav, animated: true, completion: nil)

        }
    
    func presentDialogRegisterAccountViewController() {
        let dialogRegisterAccountViewController = DialogRegisterAccountViewController()
//        openWorkingSessionViewController.view.backgroundColor = ColorUtils.blackTransparent()
       
        let nav = UINavigationController(rootViewController: dialogRegisterAccountViewController)
        // 1
        nav.modalPresentationStyle = .overCurrentContext
        // 2
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                
                // 3
                sheet.detents = [.large()]
                
            }
        } else {
            // Fallback on earlier versions
        }
        // 4
        present(nav, animated: true, completion: nil)
    }
    
    
}
extension LoginViewController{
    
    func getSessions(){
        viewModel.getSessions().subscribe(onNext: { (response) in
            dLog(response.toJSON())
          
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog(response)
                self.sessions_str = response.data as! String
                self.getConfig()
            }else{
//                Toast.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", controller: self)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại")
            }
          
          
        }).disposed(by: rxbag)
        
    }
    
}
