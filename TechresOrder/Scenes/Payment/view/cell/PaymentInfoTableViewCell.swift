//
//  PaymentInfoTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import RxSwift

class PaymentInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_order_code: UILabel!
    @IBOutlet weak var lbl_created_at: UILabel!
    @IBOutlet weak var lbl_employee_name: UILabel!
    @IBOutlet weak var btnCospan: UIButton!
    @IBOutlet weak var lbl_customer_slot: UILabel!
    @IBOutlet weak var lbl_customer_name: UILabel!
    @IBOutlet weak var lbl_customer_phone: UILabel!
    
    @IBOutlet weak var view_customer_phone: UIView!
    @IBOutlet weak var view_customer_name: UIView!
    
    
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
extension PaymentInfoTableViewCell{
    private func bindViewModel() {
            if let viewModel = viewModel {
               
                viewModel.orderDetailData.subscribe( // Thực hiện subscribe Observable
                  onNext: { [weak self] orderDetailData in
                      if(orderDetailData.id > 0){
                          self?.lbl_created_at.text = orderDetailData.created_at
                          self!.lbl_order_code.text = String(format: "#%d", orderDetailData.id)
                          self!.lbl_employee_name.text = orderDetailData.employee_name
                          self!.lbl_customer_slot.text = String(format: "Số khách: %d", orderDetailData.customer_slot_number)
                          if(orderDetailData.customer_name.count > 0){
                              self?.lbl_customer_name.text = orderDetailData.customer_name
                              self?.lbl_customer_phone.text = orderDetailData.customer_phone
                          }else{
                              Utils.isHideAllView(isHide: true, view: (self?.view_customer_phone)!)
                              Utils.isHideAllView(isHide: true, view: (self?.view_customer_name)!)
                          }
                      }
                     
                  }).disposed(by: disposeBag)
                
            }
            
     }
        
}
