//
//  ReturnFoodViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 21/01/2023.
//

import UIKit
import JonAlert
//MARK: CALL API
extension ReturnFoodViewController{
    func returnBeer(){
            viewModel.returnBeer().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
//                    Toast.show(message: "Trả bia thành công...", controller: self)
                    JonAlert.showSuccess(message: "Trả bia thành công...", duration: 2.0)
                    self.delegateReturnBeer?.callBackReturnBeer(note: self.textfield_note.text)
                    self.viewModel.makePopViewController()
                }else{
                    dLog(response.message ?? "")
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
//                    Toast.show(message: response.message ?? "Có lỗi trong quá trình thêm món", controller: self)
                }
             
            }).disposed(by: rxbag)
        }
}
extension ReturnFoodViewController: CaculatorInputQuantityDelegate{
    
    func presentModalInputQuantityViewController() {
            let inputQuantityViewController = InputQuantityViewController()
        inputQuantityViewController.max_quantity = 1000
        inputQuantityViewController.current_quantity = self.quantity
        inputQuantityViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: inputQuantityViewController)
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
        inputQuantityViewController.delegate = self
    //        newFeedBottomSheetActionViewController.newFeed = newFeed
    //        newFeedBottomSheetActionViewController.index = position
            present(nav, animated: true, completion: nil)

        }
      
    
    
    func callbackCaculatorInputQuantity(number: Float, position: Int) {
        var quantity = number <= total ? number : total
        self.viewModel.quantity.accept(Int(quantity))
        self.lbl_quantity.text = String(format: "%.0f", quantity)
    }
}