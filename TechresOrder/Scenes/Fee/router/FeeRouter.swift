//
//  FeeRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit

class FeeRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = FeeViewController(nibName: "FeeViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToCreateFeeViewController(){
        let feeManagerViewController = FeeManagerRouter().viewController as! FeeManagerViewController
        sourceView?.navigationController?.pushViewController(feeManagerViewController, animated: true)
    }
    func navigateToUpdateFeeMaterialViewController(materialFeeId:Int){
        let UpdateMaterialFeeViewController = UpdateMaterialFeeRouter().viewController as! UpdateMaterialFeeViewController
        UpdateMaterialFeeViewController.materialFeeId = materialFeeId
        sourceView?.navigationController?.pushViewController(UpdateMaterialFeeViewController, animated: true)
    }
    func navigateToUpdateOtherFeedViewController(fee: Fee){
        let UpdateOtherFeedViewController = UpdateOtherFeedRouter().viewController as! UpdateOtherFeedViewController
        UpdateOtherFeedViewController.fee = fee
        sourceView?.navigationController?.pushViewController(UpdateOtherFeedViewController, animated: true)
    }
    
}
