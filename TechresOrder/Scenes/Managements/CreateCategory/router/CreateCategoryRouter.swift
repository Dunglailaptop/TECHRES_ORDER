//
//  CreateCategoryRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit

class CreateCategoryRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = CreateCategoryViewController(nibName: "CreateCategoryViewController", bundle: Bundle.main)
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
