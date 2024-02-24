//
//  PaymentFooterTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import RxSwift
class PaymentFooterTableViewCell: UITableViewCell {

    @IBOutlet weak var btn_checkbox_discount: UIButton!
    @IBOutlet weak var btn_checkbox_vat: UIButton!
    @IBOutlet weak var btn_checkbox_point: UIButton!
    @IBOutlet weak var lbl_total_temp_payment: UILabel!
    @IBOutlet weak var lbl_total_vat: UILabel!
    @IBOutlet weak var lbl_total_discount: UILabel!
    @IBOutlet weak var lbl_discount_percent: UILabel!
    @IBOutlet weak var btn_detail_vat: UIButton!
    @IBOutlet weak var lbl_total_used_point: UILabel!
    
    @IBOutlet weak var image_checked_vat: UIImageView!
    @IBOutlet weak var image_discount: UIImageView!
    
    @IBOutlet weak var lbl_name_vat: UILabel!
    @IBOutlet weak var lbl_name_discount: UILabel!
    @IBOutlet weak var lbl_name_total_point_used: UILabel!
    
    @IBOutlet weak var image_total_point_use: UIImageView!
    var isChangeImage = false
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

}
extension PaymentFooterTableViewCell{
    private func bindViewModel() {
            if let viewModel = viewModel {
                
                viewModel.orderDetailData.subscribe( // Thực hiện subscribe Observable
                  onNext: { [weak self] orderDetailData in
                      if(orderDetailData.id > 0){
                          
                         
                          
                          
                          if(orderDetailData.status == ORDER_STATUS_WAITING_WAITING_COMPLETE){
                              self?.viewModel?.makePopViewController()
                          }
                          self?.lbl_total_vat.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(orderDetailData.vat_amount))
                          
                          self?.lbl_total_discount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(orderDetailData.discount_amount))
                          
                          if(ManageCacheObject.getSetting().is_hide_total_amount_before_complete_bill == ACTIVE && !Utils.checkRoleOwnerAndGeneralManager(permission: ManageCacheObject.getCurrentUser().permissions)){
                              if(orderDetailData.amount > 1000){
                                  self?.lbl_total_temp_payment.text = Utils.hideTotalAmount(amount: Float(orderDetailData.amount))
                              }else{
                                  self?.lbl_total_temp_payment.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(orderDetailData.amount))
                              }
                          }else{
                              self?.lbl_total_temp_payment.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(orderDetailData.amount))
                          }
                          
                          
                          
                          self?.lbl_total_used_point.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(orderDetailData.total_point))
                          if(orderDetailData.discount_percent > 0){
                              self?.lbl_discount_percent.isHidden = false
                              
                                switch orderDetailData.discount_type{
                                    case 1:
                                        self?.lbl_discount_percent.text = String(format: "| %@: (%d%%)", "tổng bill",orderDetailData.discount_percent)
                                        break
                                    case 2:
                                        self?.lbl_discount_percent.text = String(format: "| %@: (%d%%)","món ăn",orderDetailData.discount_percent)
                                        break
                                    case 3:
                                        self?.lbl_discount_percent.text = String(format: "| %@: (%d%%)", "thức uống",orderDetailData.discount_percent)
                                        break
                                    default:
                                        return
                                }
                              self!.btn_checkbox_discount.setImage(UIImage(named: "check"), for: .normal)
                          }else{
                              self?.lbl_discount_percent.isHidden = true
                              self!.btn_checkbox_discount.setImage(UIImage(named: "icon-check-enable"), for: .normal)
                          }
                          
                          
                          
                          if(orderDetailData.is_apply_vat == ACTIVE){
                              self!.btn_checkbox_vat.setImage(UIImage(named: "check"), for: .normal)
                          }else{
                              self!.btn_checkbox_vat.setImage(UIImage(named: "icon-check-enable"), for: .normal)

                          }
                          if(orderDetailData.total_point > 0){
                              self!.btn_checkbox_point.setImage(UIImage(named: "check"), for: .normal)
                          }else{
                              self!.btn_checkbox_point.setImage(UIImage(named: "icon-check-disable"), for: .normal)
                          }
                          
                 
                          
                          if(orderDetailData.status == ORDER_STATUS_COMPLETE || orderDetailData.status == ORDER_STATUS_DEBT_COMPLETE){
                              self!.btn_checkbox_point.setImage(UIImage(named: "icon-check-disable"), for: .normal)
                              self?.btn_checkbox_vat.isUserInteractionEnabled = false
                              self?.btn_checkbox_discount.isUserInteractionEnabled = false
                              
                              if(orderDetailData.is_apply_vat == ACTIVE){
                                  self!.btn_checkbox_vat.setImage(UIImage(named: "check"), for: .normal)
                              }else{
                                  self!.btn_checkbox_vat.setImage(UIImage(named: "icon-check-enable"), for: .normal)

                              }
                              if(orderDetailData.total_point > 0){
                                  self!.btn_checkbox_point.setImage(UIImage(named: "check"), for: .normal)
                              }else{
                                  self!.btn_checkbox_point.setImage(UIImage(named: "icon-check-disable"), for: .normal)
                              }
                              
                          }
                          
                          
                          
                          //nếu bàn booking đã set up chờ nhận khách thì unable nut1 check VAT và giảm giá
                          if(orderDetailData.booking_status == STATUS_BOOKING_SET_UP
                          || !Utils.checkRoleDiscountGifFood(permission: ManageCacheObject.getCurrentUser().permissions)){
                              self!.btn_checkbox_vat.setImage(UIImage(named:"icon-check-disable"), for: .normal)
                              self!.btn_checkbox_vat.isUserInteractionEnabled = false
                              self!.btn_checkbox_discount.setImage(UIImage(named:"icon-check-disable"),for: .normal)
                              self!.btn_checkbox_discount.isUserInteractionEnabled = false
                          }
                       
                      }
                     
                  }).disposed(by: disposeBag)
                
            }
            
     }
    
    
        
}
