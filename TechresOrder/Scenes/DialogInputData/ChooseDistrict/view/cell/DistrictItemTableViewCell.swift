//
//  DistrictItemTableViewCell.swift
//  Techres-Seemt
//
//  Created by Kelvin on 02/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit

class DistrictItemTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_district_name: UILabel!
    @IBOutlet weak var btnCheck: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: - Variable -
    public var data: District? = nil {
        didSet {
            dLog(data!.toJSON())
            lbl_district_name.text = data?.name
            btnCheck.image = UIImage(named: data?.isSelected == ACTIVE ? "icon-radio-checked" : "icon-radio-uncheck")

        }
    }
}
