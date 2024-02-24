//
//  OrderManagementTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 25/01/2023.
//

import UIKit
import RxSwift

class OrderManagementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_order_status: UILabel!
    
    @IBOutlet weak var view_order_status: UIView!
    
    
    @IBOutlet weak var lbl_table_name: UILabel!
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    @IBOutlet weak var lbl_order_code: UILabel!
    
    @IBOutlet weak var lbl_order_time: UILabel!
    
    @IBOutlet weak var lbl_number_customer_slot: UILabel!
    
    
    @IBOutlet weak var view_order_bg_status: UIView!
    
    
    @IBOutlet weak var lbl_table_merge: UILabel!
    
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
    var viewModel: OrderManagementViewModel? {
           didSet {
              
               
           }
    }
    
    // MARK: - Variable -
       public var data: Order? = nil {
           didSet {
               
               lbl_order_code.text = String(format: "#%d", data?.id ?? 0)
               lbl_table_name.text = data?.table_name
               lbl_number_customer_slot.text = data?.employee.name
               lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: data!.total_amount)
               lbl_order_time.text =  data?.payment_date
               lbl_table_merge.text = data?.table_merged_names.joined(separator: ",")
//               data?.order_status=8
               
               if (data?.order_status == ORDER_STATUS_COMPLETE || data?.order_status == ORDER_STATUS_DEBT_COMPLETE) {
                   self.lbl_order_status.text = "Hoàn Thành".uppercased()
               }else{
                 
                   self.lbl_order_status.text = "Đã Huỷ".uppercased()
                   self.view_order_status.backgroundColor = ColorUtils.red_000()
                   self.view_order_bg_status.backgroundColor = ColorUtils.red_000()
                   
                   self.lbl_order_status.textColor = ColorUtils.red_600()
                   self.lbl_table_name.textColor = ColorUtils.red_600()
                   self.lbl_total_amount.textColor = ColorUtils.red_600()
               }
              // lbl_table_merge.text = data?.table_merged_names.joined(separator: ",")
    
           }
       }
}
