//
//  FoodManagementRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit

class FoodManagementRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = FoodManagementViewController(nibName: "FoodManagementViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    func navigateToCreateFoodViewController(food:Food = Food.init()){
        let createFoodViewController = CreateFoodRouter().viewController as! CreateFoodViewController
        createFoodViewController.food = food
        createFoodViewController.delegate =  self.sourceView as! TechresDelegate
        sourceView?.navigationController?.pushViewController(createFoodViewController, animated: true)
    }
    
}
