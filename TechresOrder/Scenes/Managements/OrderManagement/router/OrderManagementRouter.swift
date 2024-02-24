//
//  OrderManagementRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 25/01/2023.
//

import UIKit

class OrderManagementRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = OrderManagementViewController(nibName: "OrderManagementViewController", bundle: Bundle.main)
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
        sourceView?.navigationController?.pushViewController(orderDetailViewController, animated: true)
    }
    func navigateToPayMentViewController(order_id : Int){
        let payMentViewController = PayMentRouter().viewController as! PayMentViewController
        payMentViewController.order_id = order_id
        payMentViewController.change_icon_prev = true
        sourceView?.navigationController?.pushViewController(payMentViewController, animated: true)
    }
    
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
}
