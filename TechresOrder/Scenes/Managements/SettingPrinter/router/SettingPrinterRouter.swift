//
//  SettingPrinterRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 26/01/2023.
//

import UIKit

class SettingPrinterRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = SettingPrinterViewController(nibName: "SettingPrinterViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToCreatePrinterViewController(){
        let createPrinterViewController = CreatePrinterRouter().viewController as! CreatePrinterViewController
        createPrinterViewController.isUpdate = 0
        sourceView?.navigationController?.pushViewController(createPrinterViewController, animated: true)
    }
    func navigateToUpdatePrinterViewController(printer:Kitchen){
        let updatePrinterViewController = CreatePrinterRouter().viewController as! CreatePrinterViewController
        updatePrinterViewController.isUpdate = ACTIVE
        updatePrinterViewController.printer = printer
        sourceView?.navigationController?.pushViewController(updatePrinterViewController, animated: true)
    }
    func navigateToUpdateKitchenViewController(kitchen:Kitchen){
        let updateKitchenViewController = UpdateKitchenRouter().viewController as! UpdateKitchenViewController
        updateKitchenViewController.kitchen = kitchen
        sourceView?.navigationController?.pushViewController(updateKitchenViewController, animated: true)
    }
}
