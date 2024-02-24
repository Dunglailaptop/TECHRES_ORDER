//
//  ChooseDistrictViewController+Extension.swift
//  Techres-Seemt
//
//  Created by Kelvin on 02/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import JonAlert
extension ChooseDistrictViewController{
    func registerCell() {
    
        let districtCell = UINib(nibName: "DistrictItemTableViewCell", bundle: .main)
        tableView.register(districtCell, forCellReuseIdentifier: "DistrictItemTableViewCell")
        
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView
            .rx.setDelegate(self)
            .disposed(by: rxbag)
        
        tableView.rx.modelSelected(District.self) .subscribe(onNext: { [self] element in
            print("Selected \(element)")
            var districts = self.viewModel.dataArray.value
            districts.enumerated().forEach { (index, value) in
                if(element.id == value.id){
                    districts[index].isSelected = ACTIVE
                   }else{
                       districts[index].isSelected = DEACTIVE
                   }
               }
               self.viewModel.dataArray.accept(districts)
            
            
        })
        .disposed(by: rxbag)
        
}
    func bindTableViewData() {
        viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "DistrictItemTableViewCell", cellType: DistrictItemTableViewCell.self))
        {  (row, city, cell) in
            cell.data = city
        }.disposed(by: rxbag)
        
    }
}
extension ChooseDistrictViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ChooseDistrictViewController{
    func districts(){
        viewModel.districts().subscribe(onNext: {
            (response) in
            if (response.code == RRHTTPStatusCode.ok.rawValue){
                if  let districts = Mapper<District>().mapArray(JSONObject: response.data){
                    
                    if(self.viewModel.dataFilter.value.count == 0){
                        self.viewModel.dataFilter.accept(districts)
                    }
                    
                    self.viewModel.dataArray.accept(districts)
                }
            }else{
//                Toast.show(message: response.message ?? String(format: "%d", response.code!), controller: self)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message)
            }
        })
    }
}
