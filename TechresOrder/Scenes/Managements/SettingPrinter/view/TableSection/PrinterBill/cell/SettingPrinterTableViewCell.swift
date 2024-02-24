//
//  SettingPrinterTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 25/01/2023.
//

import UIKit
import RxSwift

class SettingPrinterTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCheck: UIImageView!
    
    @IBOutlet weak var lbl_printer_name: UILabel!
    
    @IBOutlet weak var lbl_printer_ip_address: UILabel!
    
    @IBOutlet weak var btnSetting: UIButton!
    
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
        super.setSelected(false, animated: false)

    }
    
    
    @IBAction func actionToUpdatePrinter(_ sender: Any) {
        guard let viewModel = viewModel else {return}
        var printer = viewModel.printersBill.value[0]
        ManageCacheObject.savePrinterBill(printer, cache_key: KEY_PRINTER_BILL)
        viewModel.printer.accept(printer)
        viewModel.makeUpdatePrinterViewController()
        
    }
    
    
    var viewModel: SettingPrinterViewModel?
    
    
    
    // MARK: - Variable -
    public var data: Kitchen? = nil {
       didSet {
           
           var printer_name = "Máy in mạng Lan/Wifi"
           if(data?.print_type == PRINTER_WIFI){
               printer_name = "Máy in mạng Lan/Wifi"
           }else if(data?.print_type == PRINTER_IMIN){
               printer_name = "In qua Imin"
           }else{
               printer_name = "In qua Sunmi"
           }
           lbl_printer_name.text = printer_name
           lbl_printer_ip_address.text = String(format: "%@:%@", data?.printer_ip_address ?? "", data?.printer_port ?? "")
    //               if(data?.is_selected == ACTIVE){
    //                   imageCheck.image = UIImage(named: "icon-radio-checked")
    //               }else{
    //                   imageCheck.image = UIImage(named: "icon-radio-uncheck")
    //               }
       }
    }
    
}
