//
//  UtilitiesViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 21/01/2023.
//

import UIKit
import ObjectMapper

extension UtilitiesViewController {

    func presentModalChooseBrand() {
        let brandViewController = BrandViewController()
        brandViewController.delegate = self
        brandViewController.view.backgroundColor = ColorUtils.blackTransparent()
    
        let nav = UINavigationController(rootViewController: brandViewController)
        // 1
        nav.modalPresentationStyle = .overCurrentContext

        
        // 2
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                
                // 3
                sheet.detents = [.large()]
                
            }
        } else {
            // Fallback on earlier versions
        }
        // 4
            present(nav, animated: true, completion: nil)

        }
    
    
    func presentModalChooseBranch() {
            let branchViewController = BranchViewController()
            branchViewController.delegate = self
            branchViewController.brand_id = ManageCacheObject.getCurrentBrand().id
            branchViewController.view.backgroundColor = ColorUtils.blackTransparent()
        
            let nav = UINavigationController(rootViewController: branchViewController)
            // 1
        nav.modalPresentationStyle = .overCurrentContext

            
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
           
            present(nav, animated: true, completion: nil)

        }
    
    
}
extension UtilitiesViewController:BrandDelegate, BranchDelegate {
    func callBackChooseBrand(brand: Brand) {
        dLog(brand.toJSON())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.presentModalChooseBranch()
        }
        
       
        
    }
    func callBackChooseBranch(branch: Branch) {
        dLog(branch.toJSON())
        ManageCacheObject.saveCurrentBranch(branch)
        viewModel.branch.accept(branch)
    }
    
    
    
}
//MARK: CALL API
extension UtilitiesViewController{
    func getProfile(){
        viewModel.getProfile().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get order Success...")
                if let account  = Mapper<Account>().map(JSONObject: response.data){
                   dLog(account)
                   
                    self.viewModel.account.accept(account)
                }

            }
        }).disposed(by: rxbag)
}
   
}
