//
//  CategoryItemRevenueTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 17/03/2023.
//

import UIKit

class CategoryItemRevenueTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_percent: UILabel!
    @IBOutlet weak var lbl_cate_name: UILabel!
    @IBOutlet weak var view_cate: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    var viewModel: GenerateReportViewModel? {
//           didSet {
//
////               bindViewModel()
//           }
//    }
    
    var color:UIColor?
    var totalAmount:Double = 1.0
    var category:RevenueCategory?{
        didSet{
            view_cate.backgroundColor = color ?? .blue
            lbl_cate_name.text = category?.category_name
            lbl_percent.text = String(format: "%.2f %%", Double(category!.total_amount)/(totalAmount)*100)
        }
    }
    
}