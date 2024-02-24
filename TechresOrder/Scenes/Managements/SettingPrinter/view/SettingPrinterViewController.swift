//
//  SettingPrinterViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 25/01/2023.
//

import UIKit

class SettingPrinterViewController: BaseViewController {
    var viewModel = SettingPrinterViewModel()
    var router = SettingPrinterRouter()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        registerCell()
        bindTableView()
        
        viewModel.dataSectionArray.accept([0,1])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        kitchens()
//        printersBill(is_print_bill: ACTIVE)
        
    }

    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
}
