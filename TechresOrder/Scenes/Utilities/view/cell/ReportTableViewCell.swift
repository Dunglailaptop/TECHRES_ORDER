//
//  ReportTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    @IBOutlet weak var btnReportRevenue: UIButton!
    @IBOutlet weak var btnReportAnalyticsRevenue: UIButton!
    @IBOutlet weak var btnReportBusiness: UIButton!
    @IBOutlet weak var btnReportByEmployee: UIButton!
    @IBOutlet weak var view_report_employee: UIView!    
    @IBOutlet weak var view_report_cell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
