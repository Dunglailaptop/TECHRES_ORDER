//
//  ManagementAreaViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import SNCollectionViewLayout
import ObjectMapper
import MSPeekCollectionViewDelegateImplementation


class ManagementAreaViewController: BaseViewController {
    var viewModel = ManagementAreaViewModel()
    var router = ManagementAreaRouter()
    
    var branch_id = 0
    var behavior: MSCollectionViewPeekingBehavior!
    @IBOutlet weak var areaCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        registerAreaCell()
        
        viewModel.branch_id.accept(branch_id)
        viewModel.status.accept(-1)
        binđDataCollectionView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAreas()
    }
  
    @IBAction func actionCreate(_ sender: Any) {
        self.presentModalCreateAreaViewController()
    }
    
    
}
