//
//  AccountTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import RxSwift

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_employee_code: UILabel!
    
    @IBOutlet weak var lbl_employee_name: UILabel!
    
    @IBOutlet weak var avatar_employee: UIImageView!
    
    @IBOutlet weak var btnSettingAccount: UIButton!
    
    @IBOutlet weak var view_current_point: UIView!
    
    @IBOutlet weak var view_current_amount: UIView!
    @IBOutlet weak var lbl_current_point: UILabel!
    
    @IBOutlet weak var lbl_current_amount: UILabel!
    
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
    var viewModel: UtilitiesViewModel? {
           didSet {
               bindViewModel()
           }
    }
    
    
  
    
}
extension AccountTableViewCell{
    private func bindViewModel() {
        if let viewModel = viewModel{
            viewModel.account.subscribe( // Thực hiện subscribe Observable
              onNext: { [weak self] account in
                  if account.name.count > 0 {
                      dLog(account.toJSON())
                      self!.lbl_employee_code.text = String(format: "%@", ManageCacheObject.getCurrentUser().username)
                      self!.lbl_employee_name.text = account.name
                      
                      self!.avatar_employee.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: account.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
                      
                   
                  }
                 
                  
                 
              }).disposed(by: disposeBag)
        }
    }
}
