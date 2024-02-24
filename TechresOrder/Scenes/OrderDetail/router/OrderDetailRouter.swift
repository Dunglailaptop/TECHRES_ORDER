//
//  OrderDetailRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit

class OrderDetailRouter: NSObject {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = OrderDetailViewController(nibName: "OrderDetailViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToPopViewController(){
       sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToAddFoodViewController(area_id : Int,is_gift:Int = 0, order_id:Int = 0, table_name:String = "", booking_status: Int = 0){
        let addFoodViewController = AddFoodRouter().viewController as! AddFoodViewController
        addFoodViewController.area_id = area_id
        addFoodViewController.table_name = table_name
        addFoodViewController.order_id = order_id
        addFoodViewController.is_gift = is_gift
        addFoodViewController.booking_status = booking_status
        sourceView?.navigationController?.pushViewController(addFoodViewController, animated: true)
    }
    
    func navigateToAddOtherFoodViewController(order_id:Int = 0, table_name:String = ""){
        let addOtherFoodViewController = AddOtherFoodRouter().viewController as! AddOtherFoodViewController
        addOtherFoodViewController.table_name = table_name
        addOtherFoodViewController.order_id = order_id
        sourceView?.navigationController?.pushViewController(addOtherFoodViewController, animated: true)
    }
    
    func navigateToPayMentViewController(order_id : Int){
        let payMentViewController = PayMentRouter().viewController as! PayMentViewController
        payMentViewController.order_id = order_id
        payMentViewController.callBackToPopViewController = navigateToPopViewController
        sourceView?.navigationController?.pushViewController(payMentViewController, animated: true)
    }
    
    func navigateToAddOtherOrExtraFoodViewController(order_id:Int = 0, table_name:String = ""){
        dLog(ManageCacheObject.getSetting().toJSON())
        if(ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_ONE){
            let managerOtherAndExtraFoodViewController = ManagerOtherAndExtraFoodRouter().viewController as! ManagerOtherAndExtraFoodViewController
            managerOtherAndExtraFoodViewController.table_name = table_name
            managerOtherAndExtraFoodViewController.order_id = order_id
            sourceView?.navigationController?.pushViewController(managerOtherAndExtraFoodViewController, animated: true)
        }else{
            let addOtherFoodViewController = AddOtherFoodRouter().viewController as! AddOtherFoodViewController
            addOtherFoodViewController.table_name = table_name
            addOtherFoodViewController.order_id = order_id
            sourceView?.navigationController?.pushViewController(addOtherFoodViewController, animated: true)
        }
       
    }
    
    
}
