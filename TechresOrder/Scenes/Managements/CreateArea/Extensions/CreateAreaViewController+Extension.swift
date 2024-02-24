//
//  CreateAreaViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import JonAlert


// Thêm phần mở rộng cho CreateAreaViewController
extension CreateAreaViewController {
    func checkValidInTextAreaName(textArea: String) -> Bool {
        if textArea.count >= Constants.AREA_FORM_REQUIRED.requiredAreaNameMinLength && textArea.count <= Constants.AREA_FORM_REQUIRED.requiredAreaNameMaxLength
        {
                    return false
        }
        return true
    }
}


//MARK: CALL API
extension CreateAreaViewController {
    func createArea(){
        viewModel.createArea().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Create Areas Success...")
//                Toast.show(message: "Thêm khu vực mới thành công", controller: self)
                
                // mới
                self.area!.id > 0 ? JonAlert.showSuccess(message: "Cập nhật khu vực thành công!", duration: 2.0) : JonAlert.showSuccess(message: "Thêm khu vực mới thành công!", duration: 2.0)
                self.delegate?.callBackReload()
                self.navigationController?.dismiss(animated: true)

            }else{
//                Toast.show(message: response.message ?? "Thêm khu vực mới có lỗi xảy ra", controller: self)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message)
            }
            self.isPressed = true
        }).disposed(by: rxbag)
}

}
