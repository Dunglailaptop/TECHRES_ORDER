//
//  EmployeeReportRevenueTableViewCell.swift
//  ORDER
//
//  Created by Kelvin on 13/05/2023.
//

import UIKit
import Kingfisher
import RxSwift

class EmployeeReportRevenueTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_number: UILabel!
    @IBOutlet weak var lbl_total_revenue: UILabel!
    @IBOutlet weak var lbl_employee_name: UILabel!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var lbl_employee_role_name: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    var index = 0
    
    var report_type = 0
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        lbl_number.layer.masksToBounds = true
        lbl_number.layer.cornerRadius = 10
        // Configure the view for the selected state
    }
    var viewModel: EmployeeReportRevenueViewModel? {
           didSet {


           }
    }
    // MARK: - Variable -
    public var data: RevenueEmployee? = nil {
       didSet {
           lbl_number.text = String(index)
           lbl_employee_name.text = data?.employee_name
           lbl_username.text = data?.username
           lbl_employee_role_name.text = data?.employee_role_name
           lbl_total_revenue.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data!.revenue))
           avatar.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: data!.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
           
       }
    }
}
