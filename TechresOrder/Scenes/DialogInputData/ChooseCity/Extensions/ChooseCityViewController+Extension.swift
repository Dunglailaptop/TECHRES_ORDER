//
//  ChooseCityViewController+Extension.swift
//  Techres-Seemt
//
//  Created by Kelvin on 02/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import JonAlert
extension ChooseCityViewController{
    func registerCell() {
    
        let cityCell = UINib(nibName: "CityItemTableViewCell", bundle: .main)
        tableView.register(cityCell, forCellReuseIdentifier: "CityItemTableViewCell")
        
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView
            .rx.setDelegate(self)
            .disposed(by: rxbag)
        
        tableView.rx.modelSelected(Cities.self) .subscribe(onNext: { [self] element in
            print("Selected \(element)")
            var cities = self.viewModel.dataArray.value
            cities.enumerated().forEach { (index, value) in
                if(element.id == value.id){
                    cities[index].isSelected = ACTIVE
                   }else{
                       cities[index].isSelected = DEACTIVE
                   }
               }
               self.viewModel.dataArray.accept(cities)
            
            
        })
        .disposed(by: rxbag)
        
}
    func bindTableViewData() {
        viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "CityItemTableViewCell", cellType: CityItemTableViewCell.self))
        {  (row, city, cell) in
            cell.data = city
        }.disposed(by: rxbag)
        
    }
}
extension ChooseCityViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ChooseCityViewController{
    func cities(){
        viewModel.cities().subscribe(onNext: {
            (response) in
            if (response.code == RRHTTPStatusCode.ok.rawValue){
                if  let cities = Mapper<Cities>().mapArray(JSONObject: response.data){
                    
                    if(self.viewModel.dataFilter.value.count == 0){
                        self.viewModel.dataFilter.accept(cities)
                    }
                    
                    self.viewModel.dataArray.accept(cities)
                }
            }else{
//                Toast.show(message: response.message ?? String(format: "%d", response.code!), controller: self)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message)
            }
        })
    }
}
