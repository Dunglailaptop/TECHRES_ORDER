//
//  DialogFindPrinterViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 30/01/2023.
//

import UIKit

class DialogFindPrinterViewController: BaseViewController {
    var viewModel = DialogFindPrinterViewModel()
    var router = DialogFindPrinterRouter()
    
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var btnFindPrinter: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        root_view.round(with: .both, radius: 8)
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        btnCancel.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
        
        btnFindPrinter.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
    }


}
