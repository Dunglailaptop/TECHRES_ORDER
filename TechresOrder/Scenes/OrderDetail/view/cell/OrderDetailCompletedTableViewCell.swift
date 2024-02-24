//
//  OrderDetailCompletedTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 15/01/2023.
//

import UIKit

class OrderDetailCompletedTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar_food: UIImageView!
    
    @IBOutlet weak var lbl_food_name: UILabel!
    
    @IBOutlet weak var lbl_status: UILabel!
    
    
    @IBOutlet weak var lbl_amount: UILabel!
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var btnSub: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel: OrderDetailViewModel? {
           didSet {
               lbl_food_name.text = data?.name
               lbl_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: data!.total_price * data!.quantity)
               
              
               let link_image = Utils.getFullMediaLink(string: data?.food_avatar ?? "")
               avatar_food.kf.setImage(with: URL(string: link_image), placeholder: UIImage(named: "image_defauft_medium"))
         
               if(data?.status == 2){
                   lbl_status.text = "HOÀN THÀNH".uppercased()
                   lbl_status.textColor = ColorUtils.green_online()
               }else if(data?.status == 0){
                   lbl_status.text = "ĐANG CHẾ BIẾN".uppercased()
                   lbl_status.textColor = ColorUtils.blue_color()
               }else{
                   lbl_status.text = "ĐÃ HỦY".uppercased()
                   lbl_status.textColor = ColorUtils.red_color()
               }
           }
    }
    
    // MARK: - Variable -
       public var data: OrderDetail? = nil {
           didSet {
               
           }
       }
}


