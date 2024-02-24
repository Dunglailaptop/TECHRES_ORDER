//
//  FoodManagementViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import RxSwift

class FoodManagementViewController: BaseViewController {
    var viewModel = FoodManagementViewModel()
    var router = FoodManagementRouter()
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var view_no_data: UIView!    
    @IBOutlet weak var textfield_search_food: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var view_clear_search: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view_clear_search.isHidden = true
        
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.status.accept(-1)
        registerCell()
        bindTableViewData()
        
//        refreshControl.attributedTitle = NSAttributedString(string: "")

        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UItableViewController
        viewModel.dataArray.subscribe(onNext: {foods in
            if foods.count > 0 {
                self.view_no_data.isHidden = true
            } else {
                self.view_no_data.isHidden = false
            }
        }).disposed(by: rxbag)
        
        textfield_search_food.rx.controlEvent([.editingChanged])
                .asObservable().subscribe({ [unowned self] _ in
                    print("My text : \(self.textfield_search_food.text ?? "")")
                    let foods = self.viewModel.dataFoodSearchArray.value
                   
                    if !self.textfield_search_food.text!.isEmpty{
                        let foods_filter = foods.filter({ $0.normalize_name.lowercased().range(of: self.textfield_search_food.text!, options: .caseInsensitive) != nil || $0.prefix.lowercased().range(of: self.textfield_search_food.text!, options: .caseInsensitive) != nil || $0.name.lowercased().range(of: self.textfield_search_food.text!, options: .caseInsensitive) != nil})
                        self.viewModel.dataArray.accept(foods_filter)
                        dLog(foods_filter)
                        
                        
                        view_clear_search.isHidden = false
                    }else{
                        dLog(foods.toJSON())
                        self.viewModel.dataArray.accept(foods)
                        
                        view_clear_search.isHidden = true
                    }
                    
                    
                 
                }).disposed(by: rxbag)
        
    }
    @objc func refresh(_ sender: AnyObject) {
          // Code to refresh table view
        self.getFoodsManagement()
        refreshControl.endRefreshing()
    }
    @IBAction func actionCreate(_ sender: Any) {
        viewModel.food.accept(Food())
        viewModel.makeCreateFoodViewController()
        textfield_search_food.text = ""
        view_clear_search.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFoodsManagement()
    }
    
    
    
    @IBAction func actionClearSearch(_ sender: Any) {
        textfield_search_food.text = ""
        view_clear_search.isHidden = true
        getFoodsManagement()
    }
    
}
