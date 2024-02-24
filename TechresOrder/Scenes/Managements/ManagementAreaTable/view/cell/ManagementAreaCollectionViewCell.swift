//
//  ManagementAreaCollectionViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit

class ManagementAreaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view_cell: UIView!
    
    @IBOutlet weak var lbl_area_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public var data: Area? = nil{
        didSet{
            lbl_area_name.text = data?.name
            
            if(data?.status == DEACTIVE){
                view_cell.backgroundColor = ColorUtils.grayColor()
            }else{
                view_cell.backgroundColor = ColorUtils.blue_color()
            }
        }
    }

}
