//
//  SettingTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    @IBOutlet weak var btnSettingPrinter: UIButton!
    @IBOutlet weak var btnRegisterMemberShipCard: UIButton!
    @IBOutlet weak var view_intro_customer_register: UIView!
    @IBOutlet weak var view_print_config: UIView!
    
    
//    @IBOutlet weak var height_of_stack_view: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
