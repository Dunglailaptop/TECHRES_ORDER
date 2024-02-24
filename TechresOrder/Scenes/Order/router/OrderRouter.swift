//
//  OrderRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit

class OrderRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = OrderViewController(nibName: "OrderViewController", bundle: Bundle.main)
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
        sourceView?.navigationController?.pushViewController(payMentViewController, animated: true)
    }
    func navigateToQRCodeCashbackViewController(order_id : Int, table_name:String){
        let qRCodeCashbackBillViewController = QRCodeCashbackBillRouter().viewController as! QRCodeCashbackBillViewController
        qRCodeCashbackBillViewController.order_id = order_id
        qRCodeCashbackBillViewController.table_name = table_name
        qRCodeCashbackBillViewController.delegate = sourceView as! QRCodeCashbackBillDelegate
        sourceView?.navigationController?.pushViewController(qRCodeCashbackBillViewController, animated: true)
    }
    
    func navigateToAddFoodViewController(is_gift:Int = 0, order_id:Int = 0, table_name:String = ""){
        let addFoodViewController = AddFoodRouter().viewController as! AddFoodViewController
        addFoodViewController.table_name = table_name
        addFoodViewController.order_id = order_id
        addFoodViewController.is_gift = is_gift
        sourceView?.navigationController?.pushViewController(addFoodViewController, animated: true)
    }
    
    func navigateToEmployeeSharePointViewController(order_id : Int, table_name:String){
        let chooseEmployeeNeedShareViewController = ChooseEmployeeNeedShareRouter().viewController as! ChooseEmployeeNeedShareViewController
        chooseEmployeeNeedShareViewController.order_id = order_id
        chooseEmployeeNeedShareViewController.table_name = table_name
        sourceView?.navigationController?.pushViewController(chooseEmployeeNeedShareViewController, animated: true)
    }
    
    func navigateToGiftDetailViewController(qrcode:String, order_id:Int){
        let dialogGiftDetailViewController = DialogGiftDetailRouter().viewController as! DialogGiftDetailViewController
        dialogGiftDetailViewController.qrcode = qrcode
        dialogGiftDetailViewController.order_id = order_id
        sourceView?.navigationController?.pushViewController(dialogGiftDetailViewController, animated: true)
    }
    
    
}
