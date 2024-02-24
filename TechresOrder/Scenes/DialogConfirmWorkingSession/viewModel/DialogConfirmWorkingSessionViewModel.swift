//
//  DialogConfirmWorkingSessionViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 30/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class DialogConfirmWorkingSessionViewModel: BaseViewModel {
    private(set) weak var view: DialogConfirmWorkingSessionViewController?
    private var router: DialogConfirmWorkingSessionRouter?
   
    
    func bind(view: DialogConfirmWorkingSessionViewController, router: DialogConfirmWorkingSessionRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
