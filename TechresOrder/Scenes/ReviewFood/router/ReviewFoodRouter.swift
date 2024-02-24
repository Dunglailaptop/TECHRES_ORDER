//
//  ReviewFoodRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 22/01/2023.
//

import UIKit

class ReviewFoodRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = ReviewFoodViewController(nibName: "ReviewFoodViewController", bundle: Bundle.main)
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
