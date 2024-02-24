//
//  ReportTotalAmountTempTodayTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import RxSwift
class ReportTotalAmountTempTodayTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_total_amout_inday: UILabel!
    
    @IBOutlet weak var lbl_total_cash: UILabel!
    @IBOutlet weak var lbl_total_atm: UILabel!
    @IBOutlet weak var lbl_total_transfer: UILabel!
    @IBOutlet weak var lbl_total_point_used: UILabel!
    @IBOutlet weak var lbl_total_sell: UILabel!
    @IBOutlet weak var lbl_total_debit: UILabel!
    
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
    
    
    var viewModel:GenerateReportViewModel? {
       didSet {
           guard let viewModel = self.viewModel else {return}
           viewModel.dailyOrderReport.subscribe(onNext: { [self] (dailyOrderReport) in
                 lbl_total_amout_inday.text =  Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.total_amount)
                 lbl_total_cash.text =  Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.cash_amount)
                 lbl_total_sell.text =  Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.revenue_paid)
                 lbl_total_debit.text =  Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.total_revenue_amount_deposit)
            }).disposed(by: disposeBag)
       }
    }

}

