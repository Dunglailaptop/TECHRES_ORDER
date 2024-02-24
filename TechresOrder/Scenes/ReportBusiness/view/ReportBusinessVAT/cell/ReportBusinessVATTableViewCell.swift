//
//  FoodReportRevenueTableViewCell.swift
//  ORDER
//
//  Created by Kelvin on 06/06/2023.
//

import UIKit

class ReportBusinessVATTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_amount: UILabel!
    
    @IBOutlet weak var lbl_name: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public var data:VATReportData? = nil {
       didSet {
           lbl_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data?.amount ?? 0)
       }
    }

}
