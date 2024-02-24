//
//  DialogConfirmViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 30/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class DialogConfirmViewModel: BaseViewModel {
    private(set) weak var view: DialogConfirmViewController?
    private var router: DialogConfirmRouter?
   
    
    func bind(view: DialogConfirmViewController, router: DialogConfirmRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
