//
//  ManagementAreaTableManagerViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit

class ManagementAreaTableManagerViewController: BaseViewController {
    var viewModel = ManagementAreaTableManagerViewModel()
    var router = ManagementAreaTableManagerRouter()
    @IBOutlet weak var view_container: UIView!
    
    @IBOutlet weak var btn_management_area: UIButton!
    
    @IBOutlet weak var btn_management_table: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lbl_management_area: UILabel!
    
    @IBOutlet weak var lbl_management_table: UILabel!
    
    
    @IBOutlet weak var view_management_area: UIView!
    @IBOutlet weak var view_management_table: UIView!
    
    @IBOutlet weak var lbl_header: UILabel!
    
//    @IBOutlet weak var lbl_branch_name: UILabel!
//    @IBOutlet weak var lbl_branch_address: UILabel!
//
//    @IBOutlet weak var branch_avatar: UIImageView!
//    @IBOutlet weak var btn_choose_branch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        lbl_header.text = "QUẢN LÝ KHU VỰC/BÀN"
        self.btn_management_area.titleLabel?.isHidden = true
        self.btn_management_table.titleLabel?.isHidden = true
        
        self.lbl_management_area.textColor = ColorUtils.green_online()
        
        
        self.lbl_management_table.textColor = ColorUtils.green_transparent()
        self.view_management_area.isHidden = false
        self.view_management_table.isHidden = true
       
        
        
        // add area when load view
      
//         let managementAreaViewController = ManagementAreaViewController(nibName: "ManagementAreaViewController", bundle: Bundle.main)
//        managementAreaViewController.branch_id = self.viewModel.branch_id.value
//        addManagerViewController(managementAreaViewController)
//
//        let managementTableViewController = ManagementTableViewController(nibName: "ManagementTableViewController", bundle: Bundle.main)
//        managementTableViewController.remove()
       
        
        // action payment
        btn_management_table.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.actionManagementTable()
                       }).disposed(by: rxbag)
//
        btn_management_area.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.actionManagementArea()
                       }).disposed(by: rxbag)
        
        btnBack.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
        
//        btn_choose_branch.rx.tap.asDriver()
//                       .drive(onNext: { [weak self] in
//                           self!.presentModalChooseBrand()
//                       }).disposed(by: rxbag)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actionManagementArea()
    }
    func actionManagementArea() {
        self.lbl_management_area.textColor = ColorUtils.green_online()

        self.lbl_management_table.textColor = ColorUtils.green_transparent()

        self.view_management_area.isHidden = false
        self.view_management_table.isHidden = true

        // add order proccessing when load view
        let managementAreaViewController = ManagementAreaViewController(nibName: "ManagementAreaViewController", bundle: Bundle.main)
        managementAreaViewController.branch_id = self.viewModel.branch_id.value

        addViewController(managementAreaViewController)


        let managementTableViewController = ManagementTableViewController(nibName: "ManagementTableViewController", bundle: Bundle.main)
        managementTableViewController.remove()
        
        
    }
    
 func actionManagementTable(){
        self.lbl_management_area.textColor = ColorUtils.green_transparent()

        self.lbl_management_table.textColor = ColorUtils.green_online()

        self.view_management_area.isHidden = true
        self.view_management_table.isHidden = false

        let managementTableViewController = ManagementTableViewController(nibName: "ManagementTableViewController", bundle: Bundle.main)
        managementTableViewController.branch_id = self.viewModel.branch_id.value
        addViewController(managementTableViewController)

        let managementAreaViewController = ManagementAreaViewController(nibName: "ManagementAreaViewController", bundle: Bundle.main)
        managementAreaViewController.remove()
        
    }



}
