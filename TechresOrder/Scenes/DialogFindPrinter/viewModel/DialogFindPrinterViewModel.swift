//
//  DialogFindPrinterViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 31/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class DialogFindPrinterViewModel: BaseViewModel {
    private(set) weak var view: DialogFindPrinterViewController?
    private var router = DialogFindPrinterRouter()
    
  
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    // Khai báo biến để hứng dữ liệu từ VC
 
    
    func bind(view: DialogFindPrinterViewController, router: DialogFindPrinterRouter){
        self.view = view
        self.router = router
        self.router.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router.navigateToPopViewController()
        
    }
}
