//
//  PaymentTotalAmountTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import RxSwift
class PaymentTotalAmountTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_total_payment: UILabel!
    
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
extension PaymentTotalAmountTableViewCell{
    private func bindViewModel() {
            if let viewModel = viewModel {
                viewModel.orderDetailData.subscribe( // Thực hiện subscribe Observable
                  onNext: { [weak self] orderDetailData in
                      if(orderDetailData.id > 0){
                          
                          if(ManageCacheObject.getSetting().is_hide_total_amount_before_complete_bill == ACTIVE && !Utils.checkRoleOwnerAndGeneralManager(permission: ManageCacheObject.getCurrentUser().permissions)){
                              if(orderDetailData.total_amount > 1000){
                                  self?.lbl_total_payment.text = Utils.hideTotalAmount(amount: Float(orderDetailData.total_final_amount))
                              }else{
                                  self?.lbl_total_payment.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(orderDetailData.total_final_amount))
                              }
                          }else{
                              self?.lbl_total_payment.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(orderDetailData.total_final_amount))
                          }
                          
                         
                      }
                     
                  }).disposed(by: disposeBag)
                
            }
            
     }
        
}
