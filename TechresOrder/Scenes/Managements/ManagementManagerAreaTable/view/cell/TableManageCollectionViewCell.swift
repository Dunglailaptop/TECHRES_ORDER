//
//  TableManageCollectionViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit

class TableManageCollectionViewCell: UICollectionViewCell {

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
            
            
            if(data?.status == ACTIVE){
                image_table.image = UIImage(named: "icon-table-active")
            }else{
                image_table.image = UIImage(named: "icon-table-inactive")
                lbl_table_name.textColor = ColorUtils.dimGrayColor()
            }
            
//            if(data?.status == 2){ // Dang su dung
//                image_table.image = UIImage(named: "icon-table-active")
//
//            }else if(data?.status == 0){// Ban trong
//                image_table.image = UIImage(named: "icon-table-inactive")
//                lbl_table_name.textColor = ColorUtils.dimGrayColor()
//            }else if(data?.status == 3){// Ban gộp với bàn khác
//                image_table.image = UIImage(named: "icon-table-waiting-payment")
//            }else{
//                image_table.image = UIImage(named: "icon-table-booking")
//            }

            

        }
    }
    
}
