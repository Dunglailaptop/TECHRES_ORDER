//
//  FeeViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper
import RxRelay
extension FeeViewController:UITableViewDelegate {
    
    //MARK: Register Cells as you want
    func registerCell(){

        let feeTotalTableViewCell = UINib(nibName: "FeeTotalTableViewCell", bundle: .main)
        tableView.register(feeTotalTableViewCell, forCellReuseIdentifier: "FeeTotalTableViewCell")

        let feeMaterialTableViewCell = UINib(nibName: "FeeMaterialTableViewCell", bundle: .main)
        tableView.register(feeMaterialTableViewCell, forCellReuseIdentifier: "FeeMaterialTableViewCell")
        
        let otherFeeTableViewCell = UINib(nibName: "OtherFeeTableViewCell", bundle: .main)
        tableView.register(otherFeeTableViewCell, forCellReuseIdentifier: "OtherFeeTableViewCell")
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 1200
        tableView.rx.setDelegate(self).disposed(by: rxbag)
        
    }
    
    func bindTableSection(){
        viewModel.dataSectionArray.bind(to: tableView.rx.items){ [self] (tableView, index, element) in
            switch(element){
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FeeTotalTableViewCell") as! FeeTotalTableViewCell
                    cell.viewModel = viewModel
                    return cell
                
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"FeeMaterialTableViewCell" ) as! FeeMaterialTableViewCell
                    cell.viewModel = self.viewModel
                    return cell
             
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"OtherFeeTableViewCell" ) as! OtherFeeTableViewCell
                    cell.viewModel = viewModel
                    return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        dLog("3")
        switch indexPath.row {
            case 0:
                return 190
            
            case 1:
                let sectionHeight = viewModel.materialFees.value.count > 0
                        ? CGFloat((viewModel.materialFees.value.count*60) + 70)
                        : (200 + 70) // nếu không có dữ liệu thì +200 để chèn no_view_data
                return sectionHeight
            
            case 2:
                let sectionHeight = viewModel.otherFees.value.count > 0
                    ? CGFloat((viewModel.otherFees.value.count*60) + 70)
                    : (200 + 70) // nếu không có dữ liệu thì +200 để chèn no_view_data
                return sectionHeight
            
            default:
                return 0
        }
    }
    
  
}


extension FeeViewController{
    func checkFilterSelected(view_selected:UIView, textTitle:UILabel){
        view_filter_today.backgroundColor = .white
        view_filter_yesterday.backgroundColor = .white
        view_filter_thisweek.backgroundColor = .white
        view_filter_lastmonth.backgroundColor = .white
        view_filter_thismonth.backgroundColor = .white
        view_filter_three_month.backgroundColor = .white
        view_filter_this_year.backgroundColor = .white
        view_filter_last_year.backgroundColor = .white
        view_filter_three_year.backgroundColor = .white
        
        btn_filter_today.textColor = ColorUtils.main_color()
        btn_filter_yesterday.textColor = ColorUtils.main_color()
        btn_filter_thisweek.textColor = ColorUtils.main_color()
        btn_filter_lastmonth.textColor = ColorUtils.main_color()
        btn_filter_thismonth.textColor = ColorUtils.main_color()
        btn_filter_three_month.textColor = ColorUtils.main_color()
        btn_filter_this_year.textColor = ColorUtils.main_color()
        btn_filter_last_year.textColor = ColorUtils.main_color()
        btn_filter_three_year.textColor = ColorUtils.main_color()
        
        textTitle.textColor = ColorUtils.white()
        view_selected.backgroundColor = ColorUtils.main_color()
//        fees()
    }
    
}

