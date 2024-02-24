//
//  AddOtherFoodViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit

extension AddOtherFoodViewController:CaculatorInputQuantityDelegate, CalculatorMoneyDelegate {
    enum Direction : String {
        
        case north, east, south, west,wests,westss,westsss
        
        static var allValues = [Direction.north, .east, .south, .west, .wests, .westss, .westsss]
        
    }
    
    func callbackCaculatorInputQuantity(number: Float, position: Int) {
        dLog(number)
        lbl_quantity.text = String(format: "%.0f", number)
        viewModel.food_quantity.accept(number)
    }
    
    func callBackCalculatorMoney(amount: Int, position: Int) {
        textfield_food_price.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double( String(format: "%d", amount))!)
        viewModel.food_price.accept(amount)
    }
    
    
}

extension AddOtherFoodViewController{

    func presentModalCaculatorInputMoneyViewController() {
            let caculatorInputMoneyViewController = CaculatorInputMoneyViewController()
        caculatorInputMoneyViewController.checkMoneyFee = 100
        caculatorInputMoneyViewController.limitMoneyFee = 999999999
        caculatorInputMoneyViewController.result = self.viewModel.food_price.value
        
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

extension AddOtherFoodViewController{

    func presentModalInputQuantityViewController() {
            let inputQuantityViewController = InputQuantityViewController()
        inputQuantityViewController.max_quantity = 1000
      
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
      
    
}
extension AddOtherFoodViewController{
    func showChooseChef(){
        var listName = [String]()
        var listIcon = [String]()
           
        for kitchen_name in self.kitchen_names {
            listName.append(kitchen_name)
            listIcon.append("baseline_account_balance_black_48pt")
        }
           
        let controller = ArrayChooseViewController(Direction.allValues)
        
        controller.list_icons = listIcon
        controller.listString = listName
        controller.preferredContentSize = CGSize(width: 300, height: 300)
        controller.delegate = self
        
        showPopup(controller, sourceView: btnChooseChef)
    }
    
//    func showChooseVAT(){
//        var listName = [String]()
//        var listIcon = [String]()
//
//        for vat_name in self.vat_names {
//            listName.append(vat_name)
//            listIcon.append("baseline_account_balance_black_48pt")
//        }
//
//        let controller = ArrayChooseVATViewController(Direction.allValues)
//
//        controller.list_icons = listIcon
//        controller.listString = listName
//        controller.preferredContentSize = CGSize(width: 300, height: 300)
//        controller.delegate = self
//
//        showPopup(controller, sourceView: btnChooseVAT)
//    }
    
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
}
extension AddOtherFoodViewController: ArrayChooseViewControllerDelegate{
    func selectAt(pos: Int) {
        dLog(self.kitchen_names[pos])
        lbl_chef.text = self.kitchen_names[pos]
        viewModel.kitchen_id.accept(self.kitchense[pos].id)
    }
    
}
//extension AddOtherFoodViewController: ArrayChooseVATViewControllerDelegate{
//    func selectVATAt(pos: Int) {
//        dLog(self.vat_names[pos])
//        lbl_vat.text = self.vat_names[pos]
//        viewModel.vat_id.accept(self.vats[pos].id)
//    }
//
//}

