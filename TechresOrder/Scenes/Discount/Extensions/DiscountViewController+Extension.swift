//
//  DiscountViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 20/01/2023.
//

import UIKit
import JonAlert
//MARK: CALL API GET DATA FROM SERVER
extension DiscountViewController {

}
enum Direction : String {
    
    case north, east, south, west,wests,westss,westsss
    
    static var allValues = [Direction.north, .east, .south, .west, .wests, .westss, .westsss]
    
}

extension DiscountViewController {
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    func showChooseReasonDiscount(){
       

        let listIcon = ["baseline_account_balance_black_48pt","baseline_account_balance_black_48pt","baseline_account_balance_black_48pt","baseline_account_balance_black_48pt"]
           
      
        let controller = ArrayChooseDiscountReasonViewController(Direction.allValues)
        
        controller.list_icons = listIcon
        controller.listString = listName
        controller.preferredContentSize = CGSize(width: 300, height: 200)
        controller.delegate = self
        
        showPopup(controller, sourceView: self.btnDiscountReason)
    }
}
extension DiscountViewController: ArrayChooseReasonDiscountViewControllerDelegate{
    func selectReasonDiscount(pos: Int) {
        dLog(self.listName[pos])
        self.textfield_discount_reason.text = self.listName[pos]
        self.viewModel.note.accept(self.listName[pos])
    }
    
}
extension DiscountViewController{
    func applyDiscount(){
        viewModel.discount().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog(response.message)
                self.delegate?.callbackDiscount()
                self.viewModel.makePopViewController()
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
//                Toast.show(message: response.message ?? "Có lỗi trong quá trình thêm món", controller: self)
            }
         
        }).disposed(by: rxbag)
    }
    
}
