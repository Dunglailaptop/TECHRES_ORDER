//
//  ChooseTableNeedMoveCollectionViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit

class ChooseTableNeedMoveCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl_table_name: UILabel!
    @IBOutlet weak var image_table: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public var data: TableModel? = nil{
        didSet{
            lbl_table_name.text = data?.name
            lbl_table_name.textColor = .white
            if(data?.status == 2){ // Dang su dung
                image_table.image = UIImage(named: "icon-table-active")

            }else if(data?.status == 0){// Ban trong
                image_table.image = UIImage(named: "icon-table-inactive")
                lbl_table_name.textColor = ColorUtils.dimGrayColor()
            }else{// Ban dat
                image_table.image = UIImage(named: "icon-table-booking")
            }
            
            


        }
    }
    

}
