//
//  AreaRouter.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 14/01/2023.
//

import UIKit

class AreaRouter {
    
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = AreaViewController(nibName: "AreaViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    

    
    func navigateToOrderDetailViewController(order_id : Int, table_name:String){
        let orderDetailViewController = OrderDetailRouter().viewController as! OrderDetailViewController
        orderDetailViewController.order_id = order_id
        orderDetailViewController.table_name = table_name
        sourceView?.navigationController?.pushViewController(orderDetailViewController, animated: true)
    }
    //Step 1: thêm biến area_id trong router gọi AddFoodViewController
    func navigateToAddFoodViewController(table_id : Int, table_name:String, area_id: Int){
        let addFoodViewController = AddFoodRouter().viewController as! AddFoodViewController
        addFoodViewController.area_id = area_id // Bổ sung mã khu vực cho gọi món theo giá khu vực
            addFoodViewController.table_id = table_id
        addFoodViewController.table_name = table_name
        sourceView?.navigationController?.pushViewController(addFoodViewController, animated: true)
    }
    
    
    
}
