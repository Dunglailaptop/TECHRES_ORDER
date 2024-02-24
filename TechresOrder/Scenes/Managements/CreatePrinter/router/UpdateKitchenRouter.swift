//
//  UpdateKitchenRouter.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 31/01/2023.
//

import UIKit

class UpdateKitchenRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = UpdateKitchenViewController(nibName: "UpdateKitchenViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToPopViewController(){
       sourceView?.navigationController?.popViewController(animated: true)
    }
}
