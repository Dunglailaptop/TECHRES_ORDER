//
//  PaymentFooterEndTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by macmini_techres_01 on 25/08/2023.
//

import UIKit
import RxSwift

class PaymentFooterEndTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_order_customer_beer_inventory_quantity: UILabel!
    @IBOutlet weak var lbl_membership_point_used: UILabel!
    @IBOutlet weak var lbl_membership_accumulate_point_used: UILabel!
    @IBOutlet weak var lbl_membership_promotion_point_used: UILabel!
    @IBOutlet weak var lbl_membership_alo_point_used: UILabel!
    
    @IBOutlet weak var lbl_membership_point_used_amount: UILabel!
    @IBOutlet weak var lbl_membership_accumulate_point_used_amount: UILabel!
    @IBOutlet weak var lbl_membership_promotion_point_used_amount: UILabel!
    @IBOutlet weak var lbl_membership_alo_point_used_amount: UILabel!
    
    @IBOutlet weak var contraint_height_view: NSLayoutConstraint!
    var isHiddenView = false
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
    
    private func bindViewModel() {
        if let viewModel = viewModel {
            viewModel.orderDetailData.subscribe( // Thực hiện subscribe Observable
              onNext: { [weak self] orderDetailData in
                  if(orderDetailData.id > 0){
                      self!.lbl_order_customer_beer_inventory_quantity.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: orderDetailData.order_customer_beer_inventory_quantity)
                      self!.lbl_membership_point_used.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: orderDetailData.membership_point_used)
                      self!.lbl_membership_accumulate_point_used.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: orderDetailData.membership_accumulate_point_used)
                      self!.lbl_membership_promotion_point_used.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: orderDetailData.membership_promotion_point_used)
                      self!.lbl_membership_alo_point_used.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: orderDetailData.membership_alo_point_used)
                   
                      self!.lbl_membership_point_used_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: orderDetailData.membership_point_used_amount)
                      self!.lbl_membership_accumulate_point_used_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: orderDetailData.membership_accumulate_point_used_amount)
                      self!.lbl_membership_promotion_point_used_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: orderDetailData.membership_promotion_point_used_amount)
                      self!.lbl_membership_alo_point_used_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: orderDetailData.membership_alo_point_used_amount)

                  }
                 
              }).disposed(by: disposeBag)
            
        }
        
    }
    
}
