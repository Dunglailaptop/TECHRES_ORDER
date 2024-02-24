//
//  AreaCollectionViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 14/01/2023.
//

import UIKit

class AreaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl_area_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
    public var data: Area? = nil{
        didSet{
            lbl_area_name.text = data?.name
            lbl_area_name.textColor = ColorUtils.main_color()
  
            lbl_area_name.layer.cornerRadius = 16
            lbl_area_name.sizeToFit()
            lbl_area_name.layer.masksToBounds = true
            if(data!.is_select == 1){
                lbl_area_name.backgroundColor = ColorUtils.main_color()
                lbl_area_name.textColor = ColorUtils.white()
            }else{
                lbl_area_name.backgroundColor = ColorUtils.white()
                lbl_area_name.textColor = ColorUtils.main_color()
            }

        }
    }
    

}
