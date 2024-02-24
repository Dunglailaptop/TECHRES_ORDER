//
//  ManagerTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit

class ManagerTableViewCell: UITableViewCell {

    @IBOutlet weak var btnManagementArea: UIButton!
    
    @IBOutlet weak var btnManagementFood: UIButton!
    
    @IBOutlet weak var btnManagementOrder: UIButton!
    
    
    @IBOutlet weak var view_area_manager: UIView!
    @IBOutlet weak var view_food_manager: UIView!
    @IBOutlet weak var view_order_manager: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if(ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_ONE){
            Utils.isHideAllView(isHide: true, view: view_area_manager)
            Utils.isHideAllView(isHide: true, view: view_food_manager)
//            view_food_manager.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
