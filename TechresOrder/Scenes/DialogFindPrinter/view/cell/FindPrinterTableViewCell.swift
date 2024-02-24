//
//  FindPrinterTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 30/01/2023.
//

import UIKit

class FindPrinterTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_ip_printer: UILabel!
    
    @IBOutlet weak var image_checked: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
