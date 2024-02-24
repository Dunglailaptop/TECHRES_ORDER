//
//  PraricyPolicyViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 12/02/2023.
//

import UIKit

class PraricyPolicyViewModel: BaseViewModel {
    private(set) weak var view: PravicyPolicyViewController?
    private var router: PraricyPolicyRouter?
    
    
    func bind(view: PravicyPolicyViewController, router: PraricyPolicyRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    
}
