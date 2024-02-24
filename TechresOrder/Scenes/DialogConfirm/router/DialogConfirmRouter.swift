//
//  DialogConfirmRouter.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 30/01/2023.
//

import UIKit

class DialogConfirmRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = DialogConfirmViewController(nibName: "DialogConfirmViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    func navigateToPopViewController(){
        sourceView?.navigationController?.dismiss(animated: true)
    }
}
