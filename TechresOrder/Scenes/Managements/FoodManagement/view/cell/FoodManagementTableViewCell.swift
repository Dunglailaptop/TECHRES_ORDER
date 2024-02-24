//
//  FoodManagementTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit

class FoodManagementTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar_food: UIImageView!
    
    @IBOutlet weak var lbl_food_price: UILabel!
    @IBOutlet weak var lbl_food_name: UILabel!
    
    @IBOutlet weak var lbl_food_unit: UILabel!
    
    @IBOutlet weak var lbl_food_status: UILabel!
    
    
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
    
    var viewModel: FoodManagementViewModel? {
           didSet {
              
               
           }
    }
    
    // MARK: - Variable -
    public var data: Food? = nil {
        didSet {
            
//            print(data!.name + " " + String(data!.restaurant_kitchen_place_id))
            dLog(data?.toJSON())
            dLog(data?.temporary_price)
            dLog(data?.temporary_percent)
            dLog(data?.temporary_price_from_date)
            dLog(data?.temporary_price_to_date)
            dLog(ManageCacheObject.getCurrentBranch().id)
            //khi có giảm hoặc tăng giá món ăn
            if (((data!.temporary_price) != 0) || ((data!.temporary_percent) != 0)){
                
                let temporary_price_from_date = "\((data?.temporary_price_from_date)!)"
                let temporary_price_to_date = "\((data?.temporary_price_to_date)!)"
                let current_date_string = Utils.getFullCurrentDate()
                
                
                let dateFormat = "dd-MM-yyyy HH:mm"

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = dateFormat

                let startDate = dateFormatter.date(from: temporary_price_from_date)
                let endDate = dateFormatter.date(from: temporary_price_to_date)
                let current_date = dateFormatter.date(from: current_date_string)
                
                if (current_date ?? Date() >= startDate ?? Date() && current_date ?? Date() <= endDate ?? Date()){//khi thời gian hiện tại nằm trong giờ giảm hoặc tăng giá món ăn
                    var food_price = Float(data!.price)
                    let temporary_price = Float(data!.temporary_price)
                    food_price += temporary_price
                    dLog(data!.temporary_price)
                    dLog(temporary_price)
                    dLog(food_price)
                    lbl_food_price.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: food_price)// hiển thị giá giảm hoặc tăng
                }else{
                    self.lbl_food_price.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data!.price))// hiển thị giá gốc khi chưa đến thời gian áp dụng giá thời vụ
                }
            }else{
                lbl_food_price.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data!.price))// giá gốc của món ăn
            }
            
            
            lbl_food_name.text = data?.name
            lbl_food_status.text = data?.status == ACTIVE ? "ĐANG BÁN" : "NGỪNG BÁN"
            lbl_food_status.textColor = data?.status == ACTIVE ? ColorUtils.green_online() : ColorUtils.grayColor() // MÀU ĐỎ CHO lbl_food_status
//            lbl_food_price.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data!.price))
            lbl_food_unit.text = String(format: "/%@", data?.unit_type ?? "")
            
            dLog(Utils.getFullMediaLink(string: data!.avatar))
            avatar_food.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: data!.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
            
        }
    }
    
    
}
