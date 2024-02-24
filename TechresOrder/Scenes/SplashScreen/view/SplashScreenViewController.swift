//
//  SplashScreenViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 14/01/2023.
//

import UIKit

class SplashScreenViewController: UIViewController {
    private var viewModel = SplashScreenViewModel()

    private var router = SplashScreenRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewModel.bind(view: self, router: router)
        
        if(ManageCacheObject.isLogin()){
            dLog("Ready login...")
            viewModel.makeMainViewController()
        }else{
            dLog("Not Login...")
            viewModel.makeLoginViewController()
        }
       
    }


    

}
