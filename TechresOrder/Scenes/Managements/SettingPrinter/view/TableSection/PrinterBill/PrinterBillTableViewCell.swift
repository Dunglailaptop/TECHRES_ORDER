//
//  PrinterBillTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 26/01/2023.
//

import UIKit
import RxSwift

class PrinterBillTableViewCell: UITableViewCell {
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var switch_btn: UISwitch!
    
    var callBackToReloadTableSection: () -> Void = {}
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCell()
        
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var viewModel: SettingPrinterViewModel? {
           didSet {
               bindViewModel()
           }
    }
}
extension PrinterBillTableViewCell{
    //MARK: Register Cells as you want
    func registerCell(){
        let settingPrinterTableViewCell = UINib(nibName: "SettingPrinterTableViewCell", bundle: .main)
        tableView.register(settingPrinterTableViewCell, forCellReuseIdentifier: "SettingPrinterTableViewCell")

        tableView.isScrollEnabled = false

        
        tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
    }
    
    private func bindViewModel() {
        if let viewModel = viewModel {
            
           viewModel.printersBill.asObservable().bind(to: tableView.rx.items(cellIdentifier: "SettingPrinterTableViewCell", cellType: SettingPrinterTableViewCell.self))
              {  (row, printer, cell) in
                  cell.data = printer
                  
                  cell.btnSetting.rx.tap.asDriver()
                                 .drive(onNext: { [weak self] in
                                     self!.viewModel?.printer.accept(printer)
                                     self?.viewModel?.makeUpdatePrinterViewController()
                                 }).disposed(by: cell.disposeBag)

              }.disposed(by: self.disposeBag)
            
        }
    }
}
extension PrinterBillTableViewCell:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return switch_btn.isOn ? 60 : 0
    }
}
