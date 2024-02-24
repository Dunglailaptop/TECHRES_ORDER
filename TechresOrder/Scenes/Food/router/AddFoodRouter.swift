//
//  AddFoodRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 16/01/2023.
//

import UIKit

class AddFoodRouter: NSObject {

    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = AddFoodViewController(nibName: "AddFoodViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToOrderDetailViewController(order_id : Int, table_name:String = ""){
        let orderDetailViewController = OrderDetailRouter().viewController as! OrderDetailViewController
        orderDetailViewController.order_id = order_id
        orderDetailViewController.table_name = table_name
//        var vcArray = sourceView?.navigationController?.viewControllers
//        vcArray!.removeLast()
//        vcArray!.append(orderDetailViewController)
        
        sourceView?.navigationController?.pushViewController(orderDetailViewController, animated: true)
    }
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
}
