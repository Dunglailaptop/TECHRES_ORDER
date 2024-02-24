//
//  ChooseTableNeedMoveRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit

class ChooseTableNeedMoveRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = ChooseTableNeedMoveViewController(nibName: "ChooseTableNeedMoveViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
}
