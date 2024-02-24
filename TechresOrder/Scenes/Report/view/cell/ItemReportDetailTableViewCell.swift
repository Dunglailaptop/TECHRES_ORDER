//
//  ItemReportDetailTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 06/02/2023.
//

import UIKit
import RxSwift

class ItemReportDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_report_date: UILabel!
    @IBOutlet weak var lbl_total_revenue: UILabel!
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

        // Configure the view for the selected state
    }
    var viewModel: ReportViewModel? {
           didSet {
//               bindViewModel()
           }
    }
    // MARK: - Variable -
       public var data: Revenue? = nil {
           didSet {
                lbl_total_revenue.text =  Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data!.total_revenue)
                let substringHour = data!.report_time.components(separatedBy: [" "])
                let substringDate = substringHour[0].components(separatedBy: ["-"])
                switch(self.viewModel?.report_type.value){
                   case REPORT_TYPE_TODAY:
                       let hour = substringHour[1].components(separatedBy: [":"])
                       lbl_report_date.text = String(format: "%@:00", hour.first!)
                       break
                   case REPORT_TYPE_YESTERDAY:
                       let hour = substringHour[1].components(separatedBy: [":"])
                       lbl_report_date.text = String(format: "%@:00", hour.first!)
                       break
                    
                   case REPORT_TYPE_THIS_WEEK:
                       var s = "Thứ 2"
                       switch self.index {
                           case 0:
                               s = "Thứ 2"
                               break
                           case 1:
                               s = "Thứ 3"
                               break
                           case 2:
                               s = "Thứ 4"
                               break
                           case 3:
                               s = "Thứ 5"
                               break
                           case 4:
                               s = "Thứ 6"
                               break
                           case 5:
                               s = "Thứ 7"
                               break
                           default:
                               s = "Chủ nhật"
                           }
                       self.lbl_report_date.text = s
                       break

                    case REPORT_TYPE_LAST_MONTH:
                        lbl_report_date.text = String(format: "%@/%@", substringDate[2],substringDate[1])
                        break
                    
                    case REPORT_TYPE_THIS_MONTH:
                        lbl_report_date.text = String(format: "%@/%@", substringDate[2],substringDate[1])
                       break

                    case REPORT_TYPE_THREE_MONTHS:
                        lbl_report_date.text = String(format: "%@/%@", substringDate[2],substringDate[1])
                       break

                    case REPORT_TYPE_THIS_YEAR:
                        lbl_report_date.text = String(format: "%@/%@", substringDate[1], substringDate[0])
                        break

                    case REPORT_TYPE_LAST_YEAR:
                        lbl_report_date.text = String(format: "%@/%@", substringDate[1], substringDate[0])
                        break

                    case REPORT_TYPE_THREE_YEAR:
                        lbl_report_date.text = String(format: "%@/%@", substringDate[1], substringDate[0])
                        break

                    case REPORT_TYPE_ALL_YEAR:
                        lbl_report_date.text = String(format: "%@", substringDate[0])
                        break

                    default:
                       break
                }
           }
       }
    
}
