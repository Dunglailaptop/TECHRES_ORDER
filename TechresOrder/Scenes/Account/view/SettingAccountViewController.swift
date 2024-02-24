//
//  SettingAccountViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit

class SettingAccountViewController: BaseViewController {
        var viewModel = SettingAccountViewModel()
        private var router = SettingAccountRouter()
        
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var asd: UILabel!
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            viewModel.bind(view: self, router: router)
            registerCell()
            bindTableView()
            viewModel.dataSectionArray.accept([0,1])
            
    }
    
  
    
    
    @IBAction func actionLogout(_ sender: Any) {
        
    if ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE {
        if Utils.checkRoleOwnerOrCashier(permission: ManageCacheObject.getCurrentUser().permissions) {
            // chốt ca trước khi đăng xuất
            self.presentModalDialogConfirmClosedWorkingSessionViewController()
        } else {
            self.presentModalDialogConfirmViewController(dialog_type: 0, title: "XÁC NHẬN ĐĂNG XUẤT", content: "Đăng xuất khỏi tài khoản này?")
        }
    } else {
        self.presentModalDialogConfirmViewController(dialog_type: 0, title: "XÁC NHẬN ĐĂNG XUẤT", content: "Đăng xuất khỏi tài khoản này?")
    }
        
     
    }
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
}
