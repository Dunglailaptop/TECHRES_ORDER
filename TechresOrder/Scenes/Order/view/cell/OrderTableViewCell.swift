//
//  OrderTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import RxSwift

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_order_status: UILabel!
    @IBOutlet weak var lbl_booking_ready: UILabel!
    
    @IBOutlet weak var view_order_status: UIView!
    @IBOutlet weak var view_table_order_status: UIView!
    @IBOutlet weak var view_order_bill: UIView!
    @IBOutlet weak var view_more_action: UIView!
    @IBOutlet weak var view_gift_food: UIView!
    
    @IBOutlet weak var lbl_table_name: UILabel!
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    @IBOutlet weak var lbl_order_code: UILabel!
    
    @IBOutlet weak var lbl_order_time: UILabel!
    
    @IBOutlet weak var lbl_number_customer_slot: UILabel!
    
    @IBOutlet weak var btn_scan_bill: UIButton!
    
    
    @IBOutlet weak var btn_number_slot: UIButton!
    @IBOutlet weak var btn_payment: UIButton!
    
    @IBOutlet weak var btn_gif_food: UIButton!
    
    @IBOutlet weak var btn_more_action: UIButton!
    
    @IBOutlet weak var root_view_action: UIView!
    
    @IBOutlet weak var height_of_root_view_action: NSLayoutConstraint!
    @IBOutlet weak var lbl_table_merge: UILabel!
    
    @IBOutlet weak var root_view_action_scan_bill: UIView!
    
    @IBOutlet weak var lbl_deposit: UILabel!
    
    
    @IBOutlet weak var circularProgress: HorizontalProgressBar!
    var i_progress = 78.0
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view_order_status.roundCorners(.allCorners, radius: 4)
        
        self.circularProgress.showProgressText = false
        self.circularProgress.progress = CGFloat(i_progress)
        
        lbl_number_customer_slot.layer.masksToBounds = true
        lbl_number_customer_slot.layer.cornerRadius = 4
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var viewModel: OrderViewModel? {
           didSet {
              
               
           }
    }
    
    // MARK: - Variable -
       public var data: Order? = nil {
           didSet {
               lbl_order_code.text = String(format: "#%d", data?.id ?? 0)
               lbl_table_name.text = data?.table_name
               lbl_number_customer_slot.text = String(format: "%d", data?.using_slot ?? 0)
               lbl_deposit.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: data!.deposit_amount)
               
               if(ManageCacheObject.getSetting().is_hide_total_amount_before_complete_bill == ACTIVE && !Utils.checkRoleOwnerAndGeneralManager(permission: ManageCacheObject.getCurrentUser().permissions)){
                   if(data!.total_amount > 1000){
                       lbl_total_amount.text = Utils.hideTotalAmount(amount: data!.total_amount)
                   }else{
                       lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: data!.total_amount)
                   }
               }else{
                   lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: data!.total_amount)
               }
               
               
               lbl_order_time.text =  data?.using_time_minutes_string
               lbl_table_merge.text = data?.table_merged_names.joined(separator: ",")
               
               if(data?.order_status == ORDER_STATUS_REQUEST_PAYMENT){
                   lbl_order_status.text = "Yêu cầu thanh toán".uppercased()
                   
                   view_table_order_status.backgroundColor = ColorUtils.bg_request_payment()
                   lbl_table_name.textColor = ColorUtils.main_color()
                   
                   
                   lbl_total_amount.textColor = ColorUtils.main_color()
                   view_order_status.backgroundColor = ColorUtils.bg_request_payment()
                   lbl_order_status.textColor = ColorUtils.main_color()
                   
                   // check action avalible ?
                   btn_scan_bill.setImage(UIImage(named: "icon-order-scan-bill-status-request-payment"), for: .normal)
                   btn_payment.setImage(UIImage(named: "icon-order-payment-status-request-payment"), for: .normal)
                   btn_gif_food.setImage(UIImage(named: "icon-order-gift-food-status-request-payment"), for: .normal)
                   btn_more_action.setImage(UIImage(named: "icon-order-more-action-status-request-payment"), for: .normal)
                   
                   lbl_booking_ready.textColor = ColorUtils.main_color()
                   lbl_number_customer_slot.backgroundColor =  ColorUtils.bg_request_payment()
                   lbl_number_customer_slot.textColor = ColorUtils.main_color()
                   
               }else if(data?.order_status == ORDER_STATUS_WAITING_WAITING_COMPLETE){
                   lbl_order_status.text = "Chờ thanh toán".uppercased()
                  
                   view_table_order_status.backgroundColor = ColorUtils.bg_waiting_payment()
                   lbl_table_name.textColor = ColorUtils.red_color()
                   
                   
                   lbl_total_amount.textColor = ColorUtils.red_color()
                   view_order_status.backgroundColor = ColorUtils.bg_waiting_payment()
                   lbl_order_status.textColor = ColorUtils.red_color()
                   
                   lbl_booking_ready.textColor = ColorUtils.red_color()
                   
                   lbl_number_customer_slot.backgroundColor =  ColorUtils.bg_waiting_payment()
                   lbl_number_customer_slot.textColor = ColorUtils.red_color()
                   
                   btn_number_slot.isUserInteractionEnabled = false
               }else{
                   lbl_order_status.text = "Đang phục vụ".uppercased()
                   lbl_total_amount.textColor = ColorUtils.blue_color()
                   
                   view_table_order_status.backgroundColor = ColorUtils.bg_opening()
                   lbl_table_name.textColor = ColorUtils.lableBlack()
                   
                   view_order_status.backgroundColor = ColorUtils.bg_opening()
                   lbl_order_status.textColor = ColorUtils.blue_color()
                   
                   // check action avalible ?
                   btn_scan_bill.setImage(UIImage(named: "icon-order-scan-qrcode-action"), for: .normal)
                   btn_payment.setImage(UIImage(named: "icon-order-payment-action"), for: .normal)
                   btn_gif_food.setImage(UIImage(named: "icon-order-gif-action"), for: .normal)
                   btn_more_action.setImage(UIImage(named: "icon-order-more-action"), for: .normal)
                   
                   
                   
                   lbl_booking_ready.textColor = ColorUtils.blue_color()
                   
                   lbl_number_customer_slot.backgroundColor =  ColorUtils.bg_opening()
                   lbl_number_customer_slot.textColor = ColorUtils.blue_color()
               }
               
               lbl_booking_ready.isHidden = data!.booking_infor_id > 0 ? false : true
               btn_scan_bill.isEnabled = data!.booking_status == STATUS_BOOKING_SET_UP ? false : true
               btn_gif_food.isEnabled = data!.booking_status == STATUS_BOOKING_SET_UP ? false : true
               btn_more_action.isEnabled = data!.booking_status == STATUS_BOOKING_SET_UP ? false : true
           }
       }
}


//else if (data!.table_merged_names.count > 0){
//    lbl_order_status.text = "Đang phục vụ".uppercased()
//    lbl_total_amount.textColor = ColorUtils.red_600()
//
//    view_table_order_status.backgroundColor = ColorUtils.bg_opening_merged_table()
//    lbl_table_name.textColor = ColorUtils.red_600()
//
//    view_order_status.backgroundColor = ColorUtils.bg_opening_merged_table()
//    lbl_order_status.textColor = ColorUtils.red_600()
//
//    // check action avalible ?
//    btn_scan_bill.setImage(UIImage(named: "icon-order-scan-qrcode-action"), for: .normal)
//    btn_payment.setImage(UIImage(named: "icon-order-payment-action"), for: .normal)
//    btn_gif_food.setImage(UIImage(named: "icon-order-gif-action"), for: .normal)
//    btn_more_action.setImage(UIImage(named: "icon-order-more-action"), for: .normal)
//
//
//
//    lbl_booking_ready.textColor = ColorUtils.blue_color()
//
//    lbl_number_customer_slot.backgroundColor =  ColorUtils.bg_opening()
//    lbl_number_customer_slot.textColor = ColorUtils.blue_color()
//
//}
