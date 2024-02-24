//
//  ManagementAreaTableManagerViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit

extension ManagementAreaTableManagerViewController {
/*
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
 */
}
extension ManagementAreaTableManagerViewController{
    /*
    func callBackChooseBranch(branch: Branch) {
        lbl_branch_name.text = branch.name
        lbl_branch_address.text = branch.address
        viewModel.branch_id.accept(branch.id)
        self.actionManagementArea()
    }
    func callBackChooseBrand(brand: Brand) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.presentModalChooseBranch()
        }
    }
     */
}
