//
//  ReasonCancelFoodTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit

class ReasonCancelFoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_reason_name: UILabel!
    @IBOutlet weak var image_check: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public var data: ReasonCancel? = nil{
        didSet{
            lbl_reason_name.text = data?.content
            if(data?.is_select == 1){ //
                image_check.image = UIImage(named: "outline_radio_button_checked_black_48pt")
                image_check.tintColor = ColorUtils.main_color()

            }else{
                image_check.image = UIImage(named: "baseline_panorama_fish_eye_black_48pt")
                image_check.tintColor = ColorUtils.grayColor()
            }


        }
    }
}
