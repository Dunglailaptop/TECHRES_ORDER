//
//  ExtraFoodViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 21/01/2023.
//

import UIKit
import ObjectMapper
import JonAlert

extension ExtraFoodViewController {

    
    func getExtraCharges(){
        viewModel.getExtraCharges().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get ExtraCharges Success...")
                if let extraCharges  = Mapper<ExtraCharge>().mapArray(JSONObject: response.data){
                    dLog(extraCharges.toJSON())
                    self.extra_charges = extraCharges
                    self.textview_description.text = "   "
                    if(self.extra_charges.count == 0){
                        self.btnChooseMoney.isUserInteractionEnabled = true
                        self.textview_description.text = ""
                    }
                    var extraCharge = ExtraCharge.init()
                    extraCharge?.id = 0
                    extraCharge?.name = "Khác"
                    extraCharge?.price = 0
                    extraCharge?.quantity = 1
                    extraCharge?.description = ""
                    self.extra_charges.append(extraCharge!)
                    
                    self.lbl_extra_charge.text = self.extra_charges[0].name
                    self.textview_description.text = self.extra_charges[0].description.count > 0 ? self.extra_charges[0].description : ""
                    self.viewModel.note.accept(self.extra_charges[0].description.count > 0 ? self.extra_charges[0].description : "  ")
                    self.viewModel.price.accept(Int(self.extra_charges[0].price))
                    self.lbl_extra_charge_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(self.extra_charges[0].price))
                    self.viewModel.extra_charge_id.accept(self.extra_charges[0].id)
                   
                    for i in 0..<self.extra_charges.count {
                        self.extra_charges_names.append(self.extra_charges[i].name)
                    }
                    
                }

            }
        }).disposed(by: rxbag)
        
    }
    
func addExtraCharge(){
        viewModel.addExtraCharge().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog(response.message)
                JonAlert.showSuccess(message: "Thêm phụ thu thành công...", duration: 2.0)
                self.viewModel.makePopViewController()
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi trong quá trình thêm món", duration: 3.0)
            }
         
        }).disposed(by: rxbag)
    }
    
    
}
extension ExtraFoodViewController{
    func showChooseExtraCharges(){
        var listName = [String]()
        var listIcon = [String]()
           
        for extra_charges_name in self.extra_charges_names {
            listName.append(extra_charges_name)
            listIcon.append("baseline_account_balance_black_48pt")
        }
           
        let controller = ArrayChooseViewController(Direction.allValues)
        
        controller.list_icons = listIcon
        controller.listString = listName
        controller.preferredContentSize = CGSize(width: 300, height: 300)
        controller.delegate = self
        
        showPopup(controller, sourceView: btnChoosExtraCharger)
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
}
extension ExtraFoodViewController: ArrayChooseViewControllerDelegate{
    func selectAt(pos: Int) {
        
        viewModel.extra_charge_id.accept(self.extra_charges[pos].id)
        viewModel.name.accept(self.extra_charges[pos].name)
        viewModel.price.accept(Int(self.extra_charges[pos].price))
        viewModel.quantity.accept(1)
        viewModel.note.accept(self.extra_charges[pos].description)
        
        dLog(self.extra_charges_names[pos])
        lbl_extra_charge.text = self.extra_charges_names[pos]
        lbl_extra_charge_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(self.extra_charges[pos].price))
        viewModel.extra_charge_id.accept(self.extra_charges[pos].id)
        textview_description.text = self.extra_charges[pos].description
        dLog(self.extra_charges[pos].description)
        if(self.extra_charges[pos].id == 0){

            btnChooseMoney.isUserInteractionEnabled = true
            textview_description.text = ""
           
        }else{
            btnChooseMoney.isUserInteractionEnabled = false
//            textview_description.text = "   "
        }
    }
    
}

extension ExtraFoodViewController{
    func presentModalCaculatorInputMoneyViewController() {
            let caculatorInputMoneyViewController = CaculatorInputMoneyViewController()
            caculatorInputMoneyViewController.checkMoneyFee = 100 // Chỉnh thành 100
        caculatorInputMoneyViewController.limitMoneyFee = 500000000 // Chỉnh thành 500000000
            caculatorInputMoneyViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: caculatorInputMoneyViewController)
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
            caculatorInputMoneyViewController.delegate = self
    //        newFeedBottomSheetActionViewController.newFeed = newFeed
    //        newFeedBottomSheetActionViewController.index = position
            present(nav, animated: true, completion: nil)

        }
      
}
extension ExtraFoodViewController: CalculatorMoneyDelegate{
    func callBackCalculatorMoney(amount: Int, position: Int) {
        self.lbl_extra_charge_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(amount))
        self.viewModel.price.accept(amount)
        self.viewModel.quantity.accept(1)
        
    }
}
