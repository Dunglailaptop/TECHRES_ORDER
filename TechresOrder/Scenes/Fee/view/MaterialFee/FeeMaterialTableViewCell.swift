//
//  FeeMaterialTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit
import RxSwift

class FeeMaterialTableViewCell: UITableViewCell {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbl_total_material_fee: UILabel!
    
    @IBOutlet weak var btnColspan: UIButton!
    
    @IBOutlet weak var no_data_view: UIView!
    
    @IBOutlet weak var height_of_tableView: NSLayoutConstraint!
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCell()
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
}
extension FeeMaterialTableViewCell{
    //MARK: Register Cells as you want
    func registerCell(){
        let cell = UINib(nibName: "FeeMaterialItemTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "FeeMaterialItemTableViewCell")
        tableView.rowHeight = 60
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isScrollEnabled = false
    }
    
    private func bindViewModel() {
        if let viewModel = viewModel {

             
            viewModel.materialFees.asObservable().bind(to: tableView.rx.items(cellIdentifier: "FeeMaterialItemTableViewCell", cellType: FeeMaterialItemTableViewCell.self))
              {(row, fee, cell) in
                 
                cell.data = fee
                cell.btnUpdateFeedMaterial.rx.tap.asDriver()
                .drive(onNext: { [weak self] in
                    self?.viewModel!.makeToUpdateFeeMaterialViewController(materialFeeId: fee.id)
                }).disposed(by: self.disposeBag)
                 
                  
              }.disposed(by: self.disposeBag)
            
            viewModel.material_fee_total_amount.subscribe( // Thực hiện subscribe Observable
              onNext: { [weak self] material_fee_total_amount in
                  self?.lbl_total_material_fee.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(material_fee_total_amount))
              }).disposed(by: self.disposeBag)
            
            viewModel.materialFees.subscribe( // Thực hiện subscribe Observable
              onNext: { [self] materialFees in
                  no_data_view.isHidden = materialFees.count > 0 ? true : false
            }).disposed(by: self.disposeBag)
        }
    }
}

