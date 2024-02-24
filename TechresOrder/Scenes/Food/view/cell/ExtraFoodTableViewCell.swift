//
//  ExtraFoodTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 02/02/2023.
//

import UIKit
import RxSwift

class ExtraFoodTableViewCell: UITableViewCell {

    @IBOutlet weak var btnCheck: UIButton!
    
    @IBOutlet weak var lbl_food_name: UILabel!
    
    @IBOutlet weak var lbl_food_price: UILabel!

    
    @IBOutlet weak var btnSub: UIButton!
    
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var lbl_food_loss: UILabel!
    @IBOutlet weak var btnQuantity: UIButton!
    
    var is_sell_by_weight = 0
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        bringSubviewToFront(lbl_food_loss)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionSelectedFood(_ sender: Any) {
        
    }
    var viewModel: AddFoodViewModel? {
           didSet {
              dLog("da vao day roi nha ")
               
           }
    }
}
