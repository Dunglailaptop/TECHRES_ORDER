//
//  ItemFoodVATTableViewCell.swift
//  TECHRES - Bán Hàng
//
//  Created by Kelvin on 20/03/2023.
//

import UIKit

class ItemFoodVATTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar_food: UIImageView!
    
    @IBOutlet weak var food_name: UILabel!
    @IBOutlet weak var food_price: UILabel!
    @IBOutlet weak var food_vat_price: UILabel!
    
    @IBOutlet weak var lbl_discount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var viewModel: DetailVATViewModel? {
           didSet {
              
               
           }
    }
    // MARK: - Variable -
    public var data: DetailVAT? = nil {
        didSet {
//       
//            food_price.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: data!.price)
//            food_vat_price.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: data!.vat_amount)
//            food_name.text = data?.name
        }
    }
    
    
}
