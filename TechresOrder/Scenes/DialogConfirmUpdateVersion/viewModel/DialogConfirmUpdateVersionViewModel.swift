//
//  DialogConfirmUpdateVersionViewModel.swift
//  TECHRES - Bán Hàng
//
//  Created by Kelvin on 19/03/2023.
//

import UIKit

class DialogConfirmUpdateVersionViewModel: BaseViewModel {
    private(set) weak var view: DialogConfirmUpdateVersionViewController?
    private var router: DialogConfirmWorkingSessionRouter?
   
    
    func bind(view: DialogConfirmUpdateVersionViewController, router: DialogConfirmWorkingSessionRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
