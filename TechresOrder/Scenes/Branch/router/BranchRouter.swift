//
//  BrandRouter.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit

class BranchRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = BranchViewController(nibName: "BranchViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
}
