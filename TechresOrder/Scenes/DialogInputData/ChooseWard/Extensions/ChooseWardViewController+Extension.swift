//
//  ChooseWardViewController+Extension.swift
//  Techres-Seemt
//
//  Created by Kelvin on 02/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import JonAlert
extension ChooseWardViewController{
    func registerCell() {
    
        let wardCell = UINib(nibName: "WardItemTableViewCell", bundle: .main)
        tableView.register(wardCell, forCellReuseIdentifier: "WardItemTableViewCell")
        
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView
            .rx.setDelegate(self)
            .disposed(by: rxbag)
        
        tableView.rx.modelSelected(Ward.self) .subscribe(onNext: { [self] element in
            print("Selected \(element)")
            var wards = self.viewModel.dataArray.value
            wards.enumerated().forEach { (index, value) in
                if(element.id == value.id){
                    wards[index].isSelected = ACTIVE
                   }else{
                       wards[index].isSelected = DEACTIVE
                   }
               }
               self.viewModel.dataArray.accept(wards)
            
            
        })
        .disposed(by: rxbag)
        
}
    func bindTableViewData() {
        viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "WardItemTableViewCell", cellType: WardItemTableViewCell.self))
        {  (row, ward, cell) in
            cell.data = ward
        }.disposed(by: rxbag)
        
    }
}
extension ChooseWardViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ChooseWardViewController{
    func wards(){
        viewModel.wards().subscribe(onNext: {
            (response) in
            if (response.code == RRHTTPStatusCode.ok.rawValue){
                if  let cities = Mapper<Ward>().mapArray(JSONObject: response.data){
                    
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
