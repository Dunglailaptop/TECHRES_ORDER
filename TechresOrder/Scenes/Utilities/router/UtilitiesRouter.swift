//
//  UtilitiesRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit
import RxSwift

class UtilitiesRouter {
    
    
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = UtilitiesViewController(nibName: "UtilitiesViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToSettingAccountViewController(){
        let settingAccountViewController = SettingAccountRouter().viewController as! SettingAccountViewController

        sourceView?.navigationController?.pushViewController(settingAccountViewController, animated: true)
    }
    func navigateToManagementAreaTableViewController(){
        let managementAreaTableManagerViewController = ManagementAreaTableManagerRouter().viewController as! ManagementAreaTableManagerViewController
        sourceView?.navigationController?.pushViewController(managementAreaTableManagerViewController, animated: true)
    }
    
    func navigateToManagementCategoryFoodNoteViewController(){
        let managerCategoryFoodNoteViewController = ManagerCategoryFoodNoteRouter().viewController as! ManagerCategoryFoodNoteViewController
        sourceView?.navigationController?.pushViewController(managerCategoryFoodNoteViewController, animated: true)
    }
    
    func navigateToSettingPrinterViewController(){
        let settingPrinterViewController = SettingPrinterRouter().viewController as! SettingPrinterViewController
        sourceView?.navigationController?.pushViewController(settingPrinterViewController, animated: true)
    }
    
    func navigateToOrderManagementViewController(){
        let orderManagementViewController = OrderManagementRouter().viewController as! OrderManagementViewController
        sourceView?.navigationController?.pushViewController(orderManagementViewController, animated: true)
    }
    
    func navigateToMemberRegisterViewController(){
        let memberRegisterViewController = MemberRegisterRouter().viewController as! MemberRegisterViewController
        sourceView?.navigationController?.pushViewController(memberRegisterViewController, animated: true)
    }
    func navigateToRevenueDetailViewController(report_type:Int){
        let revenueDetailViewController = RevenueDetailRouter().viewController as! RevenueDetailViewController
        revenueDetailViewController.report_type = report_type
        sourceView?.navigationController?.pushViewController(revenueDetailViewController, animated: true)
    }
    
    func navigateToReportBusinessAnalyticsViewController(){
        let reportBusinessAnalyticsViewController = ReportBusinessAnalyticsRouter().viewController as! ReportBusinessAnalyticsViewController
        sourceView?.navigationController?.pushViewController(reportBusinessAnalyticsViewController, animated: true)
    }
    
    func navigateToReportBusinessViewController(){
        let reportBusinessViewController = ReportBusinessRouter().viewController as! ReportBusinessViewController
        sourceView?.navigationController?.pushViewController(reportBusinessViewController, animated: true)
    }
    func navigateToEmployeeReportRevenueViewController(){
        let employeeReportRevenueViewController = EmployeeReportRevenueRouter().viewController as! EmployeeReportRevenueViewController
        sourceView?.navigationController?.pushViewController(employeeReportRevenueViewController, animated: true)
    }
    
    func navigationToUpdateBranchViewController() {
        let UpdateBranchViewController = UpdateBranchRouter().viewController as! UpdateBranchViewController
        sourceView?.navigationController?.pushViewController(UpdateBranchViewController, animated: true)
    }
}
