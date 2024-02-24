//
//  CreateNoteViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 01/02/2023.
//

import UIKit
import JonAlert
extension CreateNoteViewController{

}
extension CreateNoteViewController{
    func createUpdateNote(){
        viewModel.createUpdateNote().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Create Note Success...")
                self.delegate?.callBackReload()
                self.viewModel.makePopViewController()
                if(self.note!.id > 0){
                    JonAlert.showSuccess(message: "Chỉnh sửa thành công!")
                }else{
                    JonAlert.showSuccess(message: "Tạo mới ghi chú thành công!")
                }

            }else{
                JonAlert.showError(message: response.message ?? "")
            }
        }).disposed(by: rxbag)
}
    
}
