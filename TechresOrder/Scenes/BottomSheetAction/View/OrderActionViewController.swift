//
//  OrderActionViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 15/01/2023.
//

import UIKit
import JonAlert

class OrderActionViewController: UIViewController {

    var delegate:OrderActionViewControllerDelegate?
    var delegateMoveFood:MoveFoodDelegate?
    var destination_table_id = 0
    var destination_table_name = ""
    var target_table_name = ""
    var target_table_id = 0
    var order_id = 0
    var employee = Account()
    
  
    
    @IBOutlet weak var view_share_point: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Thêm điều kiện kiểm tra nếu là quản lý trở lên thì loại bỏ
        if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_FOUR){
            if(Utils.checkRoleManagerOrder(permission: ManageCacheObject.getCurrentUser().permissions, employeeId: employee.id)){
                Utils.isHideAllView(isHide: false, view: view_share_point)
            }
        }else{
            Utils.isHideAllView(isHide: true, view: view_share_point)
        }
    }

    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func actionMoveTable(_ sender: Any) {
        
        // check quyền trước khi thực hiện chuyển bàn
        if(Utils.checkRoleManagerOrder(permission: ManageCacheObject.getCurrentUser().permissions)){
            self.navigationController?.dismiss(animated: true)
            self.delegate?.callBackOrderAction(destination_table_id:destination_table_id, destination_table_name:destination_table_name)
        }else{
            JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)
        }
        
      
        
      
       
    }
    @IBAction func actionMergeTable(_ sender: Any) {
        // check quyền trước khi thực hiện gộp bàn
        if(Utils.checkRoleManagerOrder(permission: ManageCacheObject.getCurrentUser().permissions)){
            self.navigationController?.dismiss(animated: true)
            self.delegate?.callBackOrderActionMergeTable(destination_table_id: destination_table_id, destination_table_name:destination_table_name)        }else{
            JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)
        }
        
       
    }
    @IBAction func actionMoveFood(_ sender: Any) {
        
        // check quyền trước khi thực hiện chuyển bàn
        if(Utils.checkRoleManagerOrder(permission: ManageCacheObject.getCurrentUser().permissions)){
            self.delegate?.callBackComfirmMoveTable(order_id:self.order_id, destination_table_name: destination_table_name, target_table_name: "", destination_table_id: destination_table_id, target_table_id: 0)
            self.navigationController?.dismiss(animated: true)
            
        }else{
            JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)
        }
        
        
      
    }
    
    @IBAction func actionSplitPoint(_ sender: Any) {
        // check quyền trước khi thực hiện chia điểm
        if(Utils.checkRoleManagerOrder(permission: ManageCacheObject.getCurrentUser().permissions)){
            self.delegate?.callBackOrderActionSharePoint(order_id: self.order_id, table_name: destination_table_name, employeeId:employee.id)
            self.navigationController?.dismiss(animated: true)
            
        }else{
            JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)
        }
        
        
       
    }
    @IBAction func actionCancelTable(_ sender: Any) {
        self.delegate?.callBackOrderActionCloseTable(table_id: destination_table_id)
        self.navigationController?.dismiss(animated: true)
    }
}
