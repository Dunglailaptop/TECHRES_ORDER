//
//  FeeTotalTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit
import RxSwift

class FeeTotalTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_total_fee: UILabel!
    @IBOutlet weak var lbl_total_material_fee: UILabel!
    @IBOutlet weak var lbl_total_other_fee: UILabel!
    
//    @IBOutlet weak var btnColspan: UIButton!
    
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
    var viewModel: FeeViewModel? {
           didSet {
               bindViewModel()
           }
    }
    
    private func bindViewModel() {
        if let viewModel = viewModel {
            viewModel.material_fee_total_amount.subscribe( // Thực hiện subscribe Observable
              onNext: { [weak self] material_fee_total_amount in
                  self?.lbl_total_material_fee.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(material_fee_total_amount))
              }).disposed(by: self.disposeBag)
            
            viewModel.other_fee_total_amount.subscribe( // Thực hiện subscribe Observable
              onNext: { [weak self] other_fee_total_amount in
                  self?.lbl_total_other_fee.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(other_fee_total_amount))
              }).disposed(by: self.disposeBag)
            
            viewModel.fee_total_amount.subscribe( // Thực hiện subscribe Observable
              onNext: { [weak self] fee_total_amount in
                  self?.lbl_total_fee.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(fee_total_amount))
              }).disposed(by: self.disposeBag)
            
        }
    }
    
    
}
