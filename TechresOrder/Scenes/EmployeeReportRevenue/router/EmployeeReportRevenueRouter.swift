//
//  EmployeeReportRevenueRouter.swift
//  ORDER
//
//  Created by Kelvin on 13/05/2023.
//

import UIKit

class EmployeeReportRevenueRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = EmployeeReportRevenueViewController(nibName: "EmployeeReportRevenueViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
}
