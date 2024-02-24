//
//  ChooseCityViewController.swift
//  Techres-Seemt
//
//  Created by Kelvin on 02/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import JonAlert
class ChooseCityViewController: BaseViewController {
    var viewModel = ChooseCityViewModel()
    var router = ChooseCityRouter()
    
    @IBOutlet weak var text_field_search: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate:ChooseCityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        registerCell()
        bindTableViewData()
        
        viewModel.country_id.accept(1)
        
        cities()
        
        
        text_field_search.rx.controlEvent(.editingChanged)
                   .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
                   .withLatestFrom(text_field_search.rx.text)
               .subscribe(onNext:{ query in
                   let cities = self.viewModel.dataFilter.value
                   if !query!.isEmpty{
                       let filterCities = cities.filter{ $0.name.contains(query!.uppercased())}
                       self.viewModel.dataArray.accept(filterCities)
                   }else{
                       self.viewModel.dataArray.accept(cities)
                   }
                   
               }).disposed(by: rxbag)
        
        
    }
    @IBAction func actionCancel(_ sender: Any) {
        viewModel.makePopViewController()
    }

    @IBAction func actionConfirm(_ sender: Any) {
        if(viewModel.dataArray.value.filter({$0.isSelected == ACTIVE}).count == 0 ){
//            Toast.show(message: "Vui lòng chọn thành phố của bạn", controller: self)
            JonAlert.showSuccess(message: "Vui lòng chọn thành phố của bạn!", duration: 2.0)
            return
        }
        delegate?.callBackChooseCity(city: viewModel.dataArray.value.filter({$0.isSelected == ACTIVE})[0])
        viewModel.makePopViewController()
    }
    
    
}