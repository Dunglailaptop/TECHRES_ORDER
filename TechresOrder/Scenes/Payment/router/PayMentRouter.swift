//
//  PayMentRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit

class PayMentRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = PayMentViewController(nibName: "PayMentViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    func navigateToPopViewController(){
       sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func navigationToPopViewControllerWithoutAnimation(){
        sourceView?.navigationController?.popViewController(animated: false)
    }
    
    func navigateToReviewFoodViewController(order_id : Int){
        let reviewFoodViewController = ReviewFoodRouter().viewController as! ReviewFoodViewController
        reviewFoodViewController.order_id = order_id
        sourceView?.navigationController?.pushViewController(reviewFoodViewController, animated: true)
    }
    func navigateToOrderDetailViewController(order_id : Int, table_name:String = ""){
        let orderDetailViewController = OrderDetailRouter().viewController as! OrderDetailViewController
        orderDetailViewController.order_id = order_id
        orderDetailViewController.table_name = table_name
        sourceView?.navigationController?.pushViewController(orderDetailViewController, animated: true)
    }
    
}
