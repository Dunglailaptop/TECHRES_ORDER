//
//  ChooseEmployeeNeedShareTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit

class ChooseEmployeeNeedShareTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var lbl_department_name: UILabel!
    @IBOutlet weak var lbl_role_name: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var viewModel: ChooseEmployeeNeedShareViewModel? {
           didSet {
              
               
           }
    }
    
    // MARK: - Variable -
    public var data: Account? = nil {
        didSet {
            lbl_name.text = data?.name
            lbl_role_name.text = data?.username
            lbl_department_name.text = data?.role_name
            avatar.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: data!.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
            
            if(data!.isSelect==1){
                if let image = UIImage(named: "check_2") {
                    btnCheck.setImage(image, for: .normal)
//                    btnCheck.tintColor = ColorUtils.main_color()
                }
            }else{
               if let image = UIImage(named: "un_check_2") {
                   btnCheck.setImage(image, for: .normal)
//                   btnCheck.tintColor = ColorUtils.main_color()
               }
                
            }
            
            
        }
    }
    
}
