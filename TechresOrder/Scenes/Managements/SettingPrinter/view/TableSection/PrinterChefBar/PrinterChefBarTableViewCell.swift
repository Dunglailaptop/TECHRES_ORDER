//
//  PrinterChefBarTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 26/01/2023.
//

import UIKit
import RxSwift

class PrinterChefBarTableViewCell: UITableViewCell {
    @IBOutlet weak var tableView: UITableView!
    
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
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    var viewModel: SettingPrinterViewModel? {
           didSet {
               bindViewModel()
           }
    }
    
}
extension PrinterChefBarTableViewCell{
    //MARK: Register Cells as you want
    func registerCell(){
        let kitchenTableViewCell = UINib(nibName: "KitchenTableViewCell", bundle: .main)
        tableView.register(kitchenTableViewCell, forCellReuseIdentifier: "KitchenTableViewCell")
        tableView.isScrollEnabled = false
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        if let viewModel = viewModel {
            
           viewModel.printersChefBar.asObservable().bind(to: tableView.rx.items(cellIdentifier: "KitchenTableViewCell", cellType: KitchenTableViewCell.self))
              {  (row, kitchen, cell) in
                  cell.viewModel = self.viewModel
                  cell.data = kitchen
              }.disposed(by: disposeBag)
            
        }
    }
}
extension PrinterChefBarTableViewCell:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
