//
//  ManagementAreaTableManagerViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import RxRelay


class ManagementAreaTableManagerViewModel: BaseViewModel {
    private(set) weak var view: ManagementAreaTableManagerViewController?
    private var router: ManagementAreaTableManagerRouter?
   
    var branch_id = BehaviorRelay<Int>(value: 0)
    
    func bind(view: ManagementAreaTableManagerViewController, router: ManagementAreaTableManagerRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
