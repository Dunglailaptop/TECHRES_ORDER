//
//  DialogConfirmClosedWorkingSessionViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 30/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class DialogConfirmClosedWorkingSessionViewModel: BaseViewModel {
    private(set) weak var view: DialogConfirmClosedWorkingSessionViewController?
    private var router: DialogConfirmClosedWorkingSessionRouter?
   
    
    func bind(view: DialogConfirmClosedWorkingSessionViewController, router: DialogConfirmClosedWorkingSessionRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
