//
//  BrandTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit

class BrandTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_branch_name: UILabel!
    
    @IBOutlet weak var lbl_branch_address: UILabel!
    
    @IBOutlet weak var avatar_branch: UIImageView!
    
    @IBOutlet weak var btnEditBranch: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnEditBranch.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel: BrandViewModel? {
           didSet {
              
               
           }
    }
    
    // MARK: - Variable -
    public var data: Brand? = nil {
        didSet {
            lbl_branch_name.text = data?.name
            let link_image = Utils.getFullMediaLink(string: data?.logo_url ?? "")
            avatar_branch.kf.setImage(with: URL(string: link_image), placeholder: UIImage(named: "image_defauft_medium"))
//            lbl_branch_address.text = data?.address
        }
    }
    
    
}
