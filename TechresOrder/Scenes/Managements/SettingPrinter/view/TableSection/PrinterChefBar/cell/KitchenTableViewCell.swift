//
//  KitchenTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 31/01/2023.
//

import UIKit

class KitchenTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_printer_name: UILabel!
    
//    @IBOutlet weak var lbl_printer_ip_address: UILabel!
    
    @IBOutlet weak var btnSetting: UIButton!
    
    @IBOutlet weak var lbl_active_status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionToUpdatePrinter(_ sender: Any) {
        guard let viewModel = viewModel else {return}
        
        if let position = viewModel.printersChefBar.value.firstIndex{$0.id == data?.id}{
            viewModel.kitchen.accept(viewModel.printersChefBar.value[position])
            viewModel.makeUpdateKitchenViewController()
        }
    }
    
    
    public var viewModel: SettingPrinterViewModel?
    
    // MARK: - Variable -
    public var data: Kitchen? = nil {
        didSet {

            lbl_printer_name.attributedText = Utils.setMultipleFontAndColorForLabel(
                label: lbl_printer_name,
                attributes: [
                    (str:String(format: "%@\n", data?.printer_name ?? ""),font:UIFont.systemFont(ofSize: 14,weight: .semibold),color:.black),
                    (str:String(format: "%@:%@", data?.printer_ip_address ?? "", data?.printer_port ?? ""),font:UIFont.systemFont(ofSize: 10),color:ColorUtils.gray_600())
                ])
            
            
            lbl_active_status.text = data?.is_have_printer == ACTIVE ? "ĐANG HOẠT ĐỘNG" : "NGỪNG HOẠT ĐỘNG"
            lbl_active_status.textColor = data?.is_have_printer == ACTIVE ? ColorUtils.green_600() : ColorUtils.gray_400()
        }
    }
}
