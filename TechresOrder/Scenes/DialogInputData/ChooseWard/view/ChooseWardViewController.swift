//
//  ChooseWardViewController.swift
//  Techres-Seemt
//
//  Created by Kelvin on 02/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import JonAlert
class ChooseWardViewController: BaseViewController {
    var viewModel = ChooseWardViewModel()
    var router = ChooseWardRouter()
    
    @IBOutlet weak var text_field_search: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate:ChooseWardDelegate?
    var district_id = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        registerCell()
        bindTableViewData()
        
       
        viewModel.district_id.accept(district_id)
        wards()
        
        
        text_field_search.rx.controlEvent(.editingChanged)
                   .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
                   .withLatestFrom(text_field_search.rx.text)
               .subscribe(onNext:{ query in
                   let wards = self.viewModel.dataFilter.value
                   if !query!.isEmpty{
                       let filterWards = wards.filter{ $0.name.contains(query!.uppercased())}
                       self.viewModel.dataArray.accept(filterWards)
                   }else{
                       self.viewModel.dataArray.accept(wards)
                   }
                   
               }).disposed(by: rxbag)
        
        
    }
    @IBAction func actionCancel(_ sender: Any) {
        viewModel.makePopViewController()
    }

    @IBAction func actionConfirm(_ sender: Any) {
        if(viewModel.dataArray.value.filter({$0.isSelected == ACTIVE}).count == 0 ){
//            Toast.show(message: "Vui lòng chọn phường/xã của bạn", controller: self)
            JonAlert.showSuccess(message: "Vui lòng chọn phường/xã của bạn!", duration: 2.0)
            return
        }
        
        delegate?.callBackChooseWard(ward: viewModel.dataArray.value.filter({$0.isSelected == ACTIVE})[0])
        viewModel.makePopViewController()
    }
    
    
}
