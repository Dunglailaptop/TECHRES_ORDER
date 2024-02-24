//
//  ManagementTableViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import SNCollectionViewLayout
import ObjectMapper
import MSPeekCollectionViewDelegateImplementation



class ManagementTableViewController: BaseViewController {
    var viewModel = ManagementTableViewModel()
    var router = ManagementTableRouter()
    var areas = [Area]()
    @IBOutlet weak var tableCollectionView: UICollectionView!
    
    var branch_id = 0
    
    var behavior: MSCollectionViewPeekingBehavior!
    @IBOutlet weak var areacollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        registerAreaCell()
        registerCell()
        
        viewModel.branch_id.accept(branch_id)
        viewModel.status.accept("")
        viewModel.status_area.accept(ACTIVE)
        binđDataAreaCollectionView()
        binđDataCollectionView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAreas()
    }
  
   
    @IBAction func actionCreate(_ sender: Any) {
        self.presentModalCreateTableViewController()
    }
    
}
