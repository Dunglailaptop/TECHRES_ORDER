//
//  ConfirmSeparateFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit

class ConfirmSeparateFoodViewController: UIViewController {

    @IBOutlet weak var root_view: UIView!
    var delegate:MoveFoodDelegate?

    var destination_table_name = ""
    var target_table_name = ""
    
    var destination_table_id = 0
    var target_table_id = 0
    var target_order_id = 0
    var order_id = 0
    var only_one = 0
    @IBOutlet weak var lbl_destination_table_name: UILabel!
    @IBOutlet weak var lbl_target_table_name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        root_view.round(with: .both, radius: 8)
        // Do any additional setup after loading the view.
        lbl_destination_table_name.text = destination_table_name
        lbl_target_table_name.text = target_table_name
    }

    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        delegate?.callBackComfirmSelectTableNeedMoveFood(order_id:self.order_id, destination_table_name: destination_table_name, target_table_name: target_table_name, destination_table_id: destination_table_id, target_table_id: target_table_id, target_order_id: target_order_id)
        self.navigationController?.dismiss(animated: true)
    }
    
   
}
