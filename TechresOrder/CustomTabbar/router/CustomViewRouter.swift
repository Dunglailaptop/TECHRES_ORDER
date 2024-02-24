//
//  CustomViewRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit

class CustomViewRouter {
    private var sourceView:UIViewController?
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToLoginViewController(){
          let loginViewController = LoginRouter().viewController
          sourceView?.navigationController?.pushViewController(loginViewController, animated: true)
      }
    
}
