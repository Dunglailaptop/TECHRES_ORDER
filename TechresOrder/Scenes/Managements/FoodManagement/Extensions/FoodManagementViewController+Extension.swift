//
//  FoodManagementViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift

//MARK: -- CALL API
extension FoodManagementViewController {
    func getFoodsManagement(){
        viewModel.getFoodsManagement().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let foods = Mapper<Food>().mapArray(JSONObject: response.data) {
                    if(foods.count > 0){
                      
                        dLog(foods.count)
                        self.viewModel.dataArray.accept(foods)
//                        if(self.viewModel.dataFoodSearchArray.value.count == 0){
//                            self.viewModel.dataFoodSearchArray.accept(foods)
//                        }
                        self.viewModel.dataFoodSearchArray.accept(foods)
                    }else{
                        self.viewModel.dataArray.accept([])
                        
                    }

                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
}

extension FoodManagementViewController{
    func registerCell() {
        let foodManagementTableViewCell = UINib(nibName: "FoodManagementTableViewCell", bundle: .main)
        tableView.register(foodManagementTableViewCell, forCellReuseIdentifier: "FoodManagementTableViewCell")
        
        self.tableView.estimatedRowHeight = 170
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView
            .rx.setDelegate(self)
            .disposed(by: rxbag)
        
        tableView.rx.modelSelected(Food.self) .subscribe(onNext: { [self] element in
            print("Selected \(element)")
            self.viewModel.food.accept(element)
            self.viewModel.makeCreateFoodViewController()
            textfield_search_food.text = ""
            view_clear_search.isHidden = true
        })
        .disposed(by: rxbag)
        
    }
    
    func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "FoodManagementTableViewCell", cellType: FoodManagementTableViewCell.self))
           {  (row, food, cell) in
               cell.data = food
               
               cell.viewModel = self.viewModel
           }.disposed(by: rxbag)
       }
}
extension FoodManagementViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension FoodManagementViewController: TechresDelegate{
    func callBackReload() {
        self.getFoodsManagement()
    }
}
