//
//  UtilitiesViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import RxSwift


class UtilitiesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    
    var viewModel = UtilitiesViewModel()
    private var router = UtilitiesRouter()
     var rxbag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        dLog(ManageCacheObject.getCurrentUser().id)
        dLog(ManageCacheObject.getCurrentBrand().id)
        
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.employee_id.accept(ManageCacheObject.getCurrentUser().id)
        registerCell()
        bindTableView()
        
        viewModel.dataSectionArray.accept([0,1,2,3,4])
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_FIVE){
//            self.getCurrentPoint(employee_id: ManageCacheObject.getCurrentUser().id)
        }
        self.getProfile()
    }

    //MARK: Register Cells as you want
    func registerCell(){

        let accountTableViewCell = UINib(nibName: "AccountTableViewCell", bundle: .main)
        tableView.register(accountTableViewCell, forCellReuseIdentifier: "AccountTableViewCell")

        let utilitiesBranchTableViewCell = UINib(nibName: "UtilitiesBranchTableViewCell", bundle: .main)
        tableView.register(utilitiesBranchTableViewCell, forCellReuseIdentifier: "UtilitiesBranchTableViewCell")
        
        let managerTableViewCell = UINib(nibName: "ManagerTableViewCell", bundle: .main)
        tableView.register(managerTableViewCell, forCellReuseIdentifier: "ManagerTableViewCell")
        
        let reportTableViewCell = UINib(nibName: "ReportTableViewCell", bundle: .main)
        tableView.register(reportTableViewCell, forCellReuseIdentifier: "ReportTableViewCell")
        
        
        let settingTableViewCell = UINib(nibName: "SettingTableViewCell", bundle: .main)
        tableView.register(settingTableViewCell, forCellReuseIdentifier: "SettingTableViewCell")
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.allowsSelection = false
        
        tableView
            .rx.setDelegate(self)
            .disposed(by: rxbag)
      
        
    }

}
extension UtilitiesViewController{
    func bindTableView(){
        viewModel.dataSectionArray.asObservable()
            .bind(to: tableView.rx.items){ [self] (tableView, index, element) in
                
                dLog(element)
                switch(element){
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell") as! AccountTableViewCell
                    
                    cell.viewModel = viewModel
                    // action setting account
                    cell.btnSettingAccount.rx.tap.asDriver()
                                   .drive(onNext: { [weak self] in
                                       dLog("action setting account")
                                       self!.viewModel.makeSettingAccountViewController()
                                   }).disposed(by: rxbag)

                    
                    if(ManageCacheObject.getSetting().service_restaurant_level_id < 2){
                        
                        cell.view_current_point.isHidden = true
                        cell.view_current_point.frame.size.height = 0
                        cell.view_current_amount.isHidden = true
                        cell.view_current_amount.frame.size.height = 0
                  
                    }else{
                        cell.lbl_current_point.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_target_point))
                        cell.lbl_current_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_bonus_salary))
                    }
                    
                    return cell
                case 1: let cell = tableView.dequeueReusableCell(withIdentifier:"UtilitiesBranchTableViewCell" ) as! UtilitiesBranchTableViewCell
                    cell.viewModel = self.viewModel
                    //Chi giải pháp quản trị mới có thể chọn chi nhánh
                  //  if(ManageCacheObject.getSetting().service_restaurant_level_id >= 1){
                        cell.btnChooseBranch.rx.tap.asDriver()
                                       .drive(onNext: { [weak self] in
                                           dLog("action choose brand")
                                           if(ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_ONE){
                                               self?.presentModalChooseBrand()
                                           }else{
                                               self!.viewModel.makeToUpdateBranchViewController()
                                           }
                                           
                                          
                                       }).disposed(by: rxbag)
                  //  }
                    
                    
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as! SettingTableViewCell
                   
                    cell.btnSettingPrinter.rx.tap.asDriver()
                                   .drive(onNext: { [weak self] in
                                       dLog("action setting printer")
                                       self?.viewModel.makeSettingPrinterViewController()
                                   }).disposed(by: rxbag)

                    if(ManageCacheObject.getSetting().service_restaurant_level_id < GPQT_LEVEL_ONE){
                        Utils.isHideAllView(isHide: true, view: cell.view_intro_customer_register)
                    }else{
                        Utils.isHideAllView(isHide: false, view: cell.view_intro_customer_register)
                        cell.btnRegisterMemberShipCard.rx.tap.asDriver()
                                       .drive(onNext: { [weak self] in
                                           dLog("btnRegisterMemberShipCard")
                                           self?.viewModel.makeMemberRegisterViewController()
                                       }).disposed(by: rxbag)
                    }
                    
                    /*
                            GPBH3 || GPBH1 OPTION 1 || GPBH2 OPTION 2 || GPBH2 OPTION 3
                        */
                    
                    if(
                        ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_THREE
                    || ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE
                    || ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_TWO
                    || ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_THREE

                    ){
                        Utils.isHideAllView(isHide: true, view: cell.view_print_config)
                    }else{
                        Utils.isHideAllView(isHide: false, view: cell.view_print_config)
                    }

//                    if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE){
//                        Utils.isHideAllView(isHide: true, view: cell.view_print_config)
//                    }else if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_TWO){
//                        Utils.isHideAllView(isHide: true, view: cell.view_print_config)
//                    }
                    
                    return cell
                    
                case 3:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ManagerTableViewCell" ) as! ManagerTableViewCell
                    
                    cell.btnManagementArea.rx.tap.asDriver()
                                   .drive(onNext: { [weak self] in
                                       dLog("action setting account")
                                       self?.viewModel.makeManagementAreaTableViewController()
                                   }).disposed(by: rxbag)
                    
                    cell.btnManagementFood.rx.tap.asDriver()
                                   .drive(onNext: { [weak self] in
                                       dLog("action setting account")
                                       self?.viewModel.makeManagementCategoryFoodNoteViewController()
                                   }).disposed(by: rxbag)

                    cell.btnManagementOrder.rx.tap.asDriver()
                                   .drive(onNext: { [weak self] in
                                       dLog("action order management")
                                       self?.viewModel.makeOrderManagementViewController()
                                   }).disposed(by: rxbag)
                    return cell
                    
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"ReportTableViewCell" ) as! ReportTableViewCell
                    
                    cell.btnReportRevenue.rx.tap.asDriver()
                                   .drive(onNext: { [weak self] in
                                       dLog("action btnReportRevenue")
                                       self!.viewModel.makeToRevenueDetailViewController(report_type:REPORT_TYPE_TODAY)
                                   }).disposed(by: rxbag)
                    
                    cell.btnReportAnalyticsRevenue.rx.tap.asDriver()
                                   .drive(onNext: { [weak self] in
                                       dLog("action btnReportAnalyticsRevenue")
                                       self!.viewModel.makeToReportBusinessAnalyticsViewController()
                                   }).disposed(by: rxbag)
                    
                    cell.btnReportBusiness.rx.tap.asDriver()
                                   .drive(onNext: { [weak self] in
                                       dLog("action btnReportBusiness")
                                       self!.viewModel.makeToReportBusinessViewController()

                                   }).disposed(by: rxbag)
                    
                
                    cell.btnReportByEmployee.rx.tap.asDriver()
                                   .drive(onNext: { [weak self] in
                                       dLog("action btnReportRevenue")
                                       self!.viewModel.makeToEmployeeReportRevenueViewController()
                                   }).disposed(by: rxbag)
                    
                    if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE){
                        Utils.isHideAllView(isHide: true, view: cell.view_report_employee)
                    }
                    //NẾU LÀ GIẢI PHÁP QUẢN TRỊ THÌ ẨN VIEW NÀY ĐI 
                    if(ManageCacheObject.getSetting().service_restaurant_level_id < GPQT_LEVEL_ONE ){
                        // ẩn view_report_cell khi đang không phải quyền chủ nhà hàng
                        if (Utils.checkRoleOwner(permission: ManageCacheObject.getCurrentUser().permissions)){
                            Utils.isHideAllView(isHide: false, view: cell.view_report_cell)
                        }else{
                            Utils.isHideAllView(isHide: true, view: cell.view_report_cell)
                        }
                    }else{
                        Utils.isHideAllView(isHide: true, view: cell.view_report_cell)
                    }
                    return cell
 
                }
            }
    }
}

extension UtilitiesViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch indexPath.row{
            case 0:
                return 100
                
            case 1:
                return 80
                
            case 2:
                
               
                /* TH1: GPBH3 || GPBH1 OPTION 1 || GPBH2 OPTION 2 || GPBH2 OPTION 3
                            
                    */
                if(
                    ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_THREE
                || ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE
                || ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_TWO
                || ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_THREE
                    
                ){
                    if(ManageCacheObject.getSetting().service_restaurant_level_id < GPQT_LEVEL_ONE){
                        return 0
                    }else{
                        return 60
                    }
    
                }else{
                    if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_ONE){
                        return 80
//                        if(ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_ONE){
//                            return 0
//                        }else{
//                            return 60
//                        }
                    }else{
//                        if(ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_THREE){
//                            return 80
//                        }else{
//                            return 60
//                        }
                        return 60
                    }
                }
                
                
            case 3:
                if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_ONE){
                    return 60
                }else{
                    if(ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_ONE){
                        return 60
                    }else{
                        return 189
                    }
                    
                    
                }
                
            default:
                if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_ONE){
                    return 0
                }else{
                    if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE){
                       return 200
                    }else{
                        return 252
                    }
                   
                }
                
            }
    }
}
