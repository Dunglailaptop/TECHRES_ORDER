//
//  PaymentOrderDetailItemTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import RxSwift

class PaymentOrderDetailItemTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar_food: UIImageView!
    
    @IBOutlet weak var lbl_food_name: UILabel!
    @IBOutlet weak var lbl_food_price: UILabel!
    @IBOutlet weak var lbl_food_quantity: UILabel!
    @IBOutlet weak var lbl_food_status: UILabel!
    @IBOutlet weak var view_gift: UIView!
    @IBOutlet weak var lbl_gift_price: UILabel!
    @IBOutlet weak var height_constraint_food_status: NSLayoutConstraint!
    @IBOutlet weak var lbl_combo_food: UILabel!
    @IBOutlet weak var top_combo_food: NSLayoutConstraint!
    
    @IBOutlet weak var constraint_gift_price_view: NSLayoutConstraint!
    @IBOutlet weak var constraint_food_name_label: NSLayoutConstraint!
    @IBOutlet weak var height_cell: NSLayoutConstraint!
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var viewModel: PayMentViewModel? {
           didSet {
               bindViewModel()
           }
    }
    // MARK: - Variable -
       public var data: OrderDetail? = nil {
           didSet {
               
           }
       }

}
extension PaymentOrderDetailItemTableViewCell{
    
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    private func bindViewModel() {
        if let viewModel = viewModel {
            
            lbl_food_name.text = data?.name
            lbl_food_price.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: data!.total_price)
            
            if(data!.is_sell_by_weight == ACTIVE){
                lbl_food_quantity.text = String(format: "%.2f", data?.quantity ?? 0.0)
            }else{
                lbl_food_quantity.text = String(format: "%.0f", data?.quantity ?? 0.0)
            }
            if(data?.status == DONE){
                
                lbl_food_status.text = "HOÀN THÀNH".uppercased()
                lbl_food_status.textColor = ColorUtils.green_online()
                
            }else if(data?.status == COOKING){
                lbl_food_status.text = "ĐANG CHẾ BIẾN".uppercased()
                lbl_food_status.textColor = ColorUtils.blue_color()
                
            }else {// món mới đang chờ
                lbl_food_status.text = "CHỜ CHẾ BIẾN".uppercased()
                lbl_food_status.textColor = ColorUtils.main_color()
                
            }
            if(data?.is_gift == ACTIVE){
                height_constraint_food_status.constant = 16
                constraint_gift_price_view.constant = 0

                lbl_gift_price.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data!.price))
                Utils.isHideAllView(isHide: false, view: view_gift)
                //khoảng cách top so với lbl name food
                top_combo_food.constant = 0 // default
                constraint_food_name_label.constant = 8
            }else{
                height_constraint_food_status.constant = 4
                Utils.isHideAllView(isHide: true, view: view_gift)
                //khoảng cách top so với lbl name food
                top_combo_food.constant = 0 // default
                constraint_food_name_label.constant = 10
            }
            
            
            if((self.data?.order_detail_combo.count)! > 0){// món combo
                var string = ""
                for i in 0..<(self.data?.order_detail_combo.count)! - 1 {
                    let item = self.data?.order_detail_combo[i]
                    string = string + "+ " + item!.name + " x " + String(item!.quantity) + "\n"//+ " = " +
                }
                dLog(string)
                let item = self.data?.order_detail_combo.last
                string = string + "+ " + item!.name +  " x " + String(item!.quantity)
                lbl_combo_food.text = string
                let height = (data!.order_detail_combo.count * 12) + (data!.order_detail_additions.count * 12) + 70
                height_cell.constant = CGFloat(height)
                constraint_food_name_label.constant = 5
                constraint_gift_price_view.constant +=  heightForLabel(text: String.init(format: "%@",string), font: lbl_combo_food.font, width: 155) + 5
                height_constraint_food_status.constant +=  heightForLabel(text: String.init(format: "%@",string), font: lbl_combo_food.font, width: 155) + 10
                
            }else{
                lbl_combo_food.text = ""
                height_cell.constant = 69
            }
            dLog(height_cell.constant)
        }
            
     }
        
}
