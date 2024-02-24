//
//  ManagerOtherAndExtraFoodViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 21/01/2023.
//

import UIKit

class ManagerOtherAndExtraFoodViewModel: BaseViewModel {
    private(set) weak var view: ManagerOtherAndExtraFoodViewController?
    private var router: ManagerOtherAndExtraFoodRouter?
    
    func bind(view: ManagerOtherAndExtraFoodViewController, router: ManagerOtherAndExtraFoodRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
