//
//  SettingAccountRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 20/01/2023.
//

import UIKit

class SettingAccountRouter {
    
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = SettingAccountViewController(nibName: "SettingAccountViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToUpdateProfileViewController(){
        let updateProfileViewController = UpdateProfileRouter().viewController as! UpdateProfileViewController
        sourceView?.navigationController?.pushViewController(updateProfileViewController, animated: true)
    }
    func navigateToChangePasswordViewController(){
        let changePasswordViewController = ChangePasswordRouter().viewController as! ChangePasswordViewController
        sourceView?.navigationController?.pushViewController(changePasswordViewController, animated: true)
    }
    func navigateToPravicyPolicyViewController(){
        let pravicyPolicyViewController = PraricyPolicyRouter().viewController as! PravicyPolicyViewController
        sourceView?.navigationController?.pushViewController(pravicyPolicyViewController, animated: true)
    }
    func navigateToTermOfUseViewController(){
        let termOfUseViewController = TermOfUseRouter().viewController as! TermOfUseViewController
        sourceView?.navigationController?.pushViewController(termOfUseViewController, animated: true)
    }
    
    func navigateToSentErrorViewController(){
        let sentErrorViewController = SentErrorRouter().viewController as! SentErrorViewController
        sourceView?.navigationController?.pushViewController(sentErrorViewController, animated: true)
    }
    
    func navigateToFeedBackDeveloperViewController(){
        let feedbackDeveloperViewController = FeedbackDeveloperRouter().viewController as! FeedbackDeveloperViewController
        sourceView?.navigationController?.pushViewController(feedbackDeveloperViewController, animated: true)
    }
    
    func navigateToClosedWorkingSessionViewController(){
        let closedWorkingSessionViewController = ClosedWorkingSessionRouter().viewController as! ClosedWorkingSessionViewController
        closedWorkingSessionViewController.delegate = sourceView as! SettingAccountViewController
        sourceView?.navigationController?.pushViewController(closedWorkingSessionViewController, animated: true)
    }
   
}
