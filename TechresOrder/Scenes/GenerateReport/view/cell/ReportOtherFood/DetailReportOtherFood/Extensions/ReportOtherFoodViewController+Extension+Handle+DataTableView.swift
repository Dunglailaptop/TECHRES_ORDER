//
//  ReportOtherFoodViewController+Extension+Handle+DataTableView.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 12/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//MARK: REGISTER CELL TABLE VIEW
extension ReportOtherFoodViewController {
    func registerCellAndBindTableView(){
        registerCell()
        bindTableView()
    }
    
    private func registerCell() {
        let foodItemReportOtherFoodTableViewCell = UINib(nibName: "FoodItemReportOtherFoodTableViewCell", bundle: .main)
        tableView.register(foodItemReportOtherFoodTableViewCell, forCellReuseIdentifier: "FoodItemReportOtherFoodTableViewCell")

        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.rx.setDelegate(self).disposed(by: rxbag)
    }
    
    private func bindTableView() {
        viewModel.report.map{$0.foods}.bind(to: tableView.rx.items(cellIdentifier: "FoodItemReportOtherFoodTableViewCell", cellType: FoodItemReportOtherFoodTableViewCell.self))
           {  (row, data, cell) in
               cell.index = row + 1
               cell.data = data
           }.disposed(by: rxbag)
    }
}

extension ReportOtherFoodViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
