//
//  DetailVATRouter.swift
//  TECHRES - Bán Hàng
//
//  Created by Kelvin on 19/03/2023.
//

import UIKit

class DetailVATRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = DetailVATViewController(nibName: "DetailVATViewController", bundle: Bundle.main)
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
