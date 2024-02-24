//
//  TableCollectionViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit
import RxRelay

class TableCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl_table_name: UILabel!
    @IBOutlet weak var image_table: UIImageView!
    // Thêm area_id nhận dữ liệu area_id
    var area_id = BehaviorRelay<Int>(value: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public var data: TableModel? = nil{
        didSet{
            lbl_table_name.text = data?.name
            lbl_table_name.textColor = .white
            area_id.accept(data!.area_id) // Thêm area_id nhận dữ liệu area_id
            
            
            if(data?.status == STATUS_TABLE_USING){ // Dang su dung
                image_table.image = UIImage(named: "icon-table-active")

            }else if(data?.status == STATUS_TABLE_CLOSED){// Ban trong
                image_table.image = UIImage(named: "icon-table-inactive")
                lbl_table_name.textColor = ColorUtils.dimGrayColor()
            }else if(data?.status == STATUS_TABLE_MERGED){// Ban gộp với bàn khác
                image_table.image = UIImage(named: "icon-table-waiting-payment")
            }else{
                image_table.image = UIImage(named: "icon-table-booking")
            }

            

        }
    }
    
}
