//
//  GenerateReportViewController+Extension.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import JonAlert
extension GenerateReportViewController{
    
    func presentModalChooseBrand() {
        let brandViewController = BrandViewController()
        let nav = UINavigationController(rootViewController: brandViewController)
        // 1
        nav.modalPresentationStyle = .pageSheet
        // 2
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                // 3
                sheet.detents = [.medium()]
            }
        } else {
            // Fallback on earlier versions
        }
        // 4
        brandViewController.delegate = self
        present(nav, animated: true, completion: nil)

    }
    func presentModalChooseBranch() {
        let branchViewController = BranchViewController()
        let nav = UINavigationController(rootViewController: branchViewController)
        // 1
        nav.modalPresentationStyle = .pageSheet

        
        // 2
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                
                // 3
                sheet.detents = [.medium()]
                
            }
        } else {
            // Fallback on earlier versions
        }
        // 4
        branchViewController.delegate = self
        branchViewController.brand_id = ManageCacheObject.getCurrentBrand().id
        present(nav, animated: true, completion: nil)

    }
}
extension GenerateReportViewController:BrandDelegate {
    func callBackChooseBrand(brand: Brand) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.presentModalChooseBranch()
        }
        
    }
    
    
}
extension GenerateReportViewController:BranchDelegate {
    func callBackChooseBranch(branch: Branch) {
        lbl_branch_name.text = branch.name
        lbl_branch_address.text = branch.address
        viewModel.branch_id.accept(branch.id)
        if(ManageCacheObject.isLogin()){
            reportRevenueTodayByBranch()
            reportRevenueTodayByTime()
            getSaleReport()//MARK: báo cáo bán hàng
//            getEstimateRevenueCostProfitReport()//MARK: báo cao doanh thu chi phí lợi nhuận (ước tính)
//            getSumRevenueCostProfitReport()//MARK: báo cao doanh thu chi phí lợi nhuận (tổng hợp)
            getReportRevenueArea()//MARK: báo cáo doanh thu khu vực bàn
            getReportTableRevenue()//MARK: báo cáo doanh thu bàn
            getReportRevenueEmployee()//MARK: báo cáo doanh thu nhân viên
            getRevenueReportByFood() //MARK: báo cáo danh thu bán hàng món ăn
            getRevenueReportCommodity()//MARK: báo cáo danh thu bán hàng hàng hoá
            getCategoryReport()//MARK: báo cáo danh mục
            getGiftedFoodReport()//MARK: báo cáo món tặng
            getReportFoodOther()//MARK: báo cáo doanh thu món ngoài menu
            getReportFoodCancel()//MARK: báo cao doanh thu món huỷ
            getVATReport()//MARK: báo cao doanh thu VAT
            getdiscountReport()//MARK: báo cao doanh thu các món giảm giá
            getReportSurcharge()//MARK: báo cao doanh thu phụ thu
        }
    }
}






